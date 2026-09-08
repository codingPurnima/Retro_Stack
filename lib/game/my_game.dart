import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';

import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/audio/game_audio.dart';
import 'package:retro_stack_frontend/game/components/pedestal_platform.dart';

import 'package:retro_stack_frontend/game/my_world.dart';
import 'package:retro_stack_frontend/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/box.dart';
import '../backgrounds/game_background.dart';
import 'components/game_stack.dart';

enum GamePlayState { startScreen, playing, paused, menu, gameOver }

class MyGame extends FlameGame<MyWorld> with HasCollisionDetection {
  static const double virtualWidth = 480;
  static const double virtualHeight = 750;

  @override
  Color backgroundColor() => RetroColors.gameSkyTop;

  MyGame()
    : super(
        world: MyWorld(),
        camera: CameraComponent.withFixedResolution(
          width: virtualWidth,
          height: virtualHeight,
        ),
      ) {
    // Register default overlay entry points so overlays can be safely managed
    // in standalone game tests as well as when hosted in GameWidget.
    overlays.addEntry(
      'StartScreen',
      (context, game) => const SizedBox.shrink(),
    );
    overlays.addEntry('Menu', (context, game) => const SizedBox.shrink());
    overlays.addEntry('Pause', (context, game) => const SizedBox.shrink());
    overlays.addEntry('GameOver', (context, game) => const SizedBox.shrink());
  }

  Box? currentBox;
  Box? lastBox;
  final double groundY = 730;

  late GameStack stack;

  bool gameOver = false;

  final double spawnScreenY = 100; // point where every new box should appear
  final double cameraTriggerY =
      150; // move camera up when stack reaches this close to the top

  int score = 0;
  late TextComponent scoreText;

  int highScore = 0;
  bool isNewHighScore = false;

  static const String _highScoreKey = 'high_score';

  // --- Sound Management ---
  bool soundEnabled = true;
  final ValueNotifier<bool> soundEnabledNotifier = ValueNotifier<bool>(true);
  static const String _soundEnabledKey = 'sound_enabled';

  // --- Physical Key & Navigation Notifier ---
  final ValueNotifier<String?> keyEventNotifier = ValueNotifier<String?>(null);

  // --- First Drop & Instructional Hint State ---
  bool hasPerformedFirstDrop = false;
  final ValueNotifier<bool> showDropHintNotifier = ValueNotifier<bool>(false);

  /// Current high-level game state determined by active overlays and engine status.
  GamePlayState get playState {
    if (overlays.isActive('Menu')) return GamePlayState.menu;
    if (overlays.isActive('StartScreen')) return GamePlayState.startScreen;
    if (overlays.isActive('GameOver')) return GamePlayState.gameOver;
    if (overlays.isActive('Pause') || paused) return GamePlayState.paused;
    return GamePlayState.playing;
  }

  @override
  Future<void> onLoad() async {
    await GameAudio.initialize();

    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(_highScoreKey) ?? 0;
    soundEnabled = prefs.getBool(_soundEnabledKey) ?? true;
    soundEnabledNotifier.value = soundEnabled;
    GameAudio.soundEnabled = soundEnabled;

    camera.viewfinder.position = Vector2(virtualWidth / 2, virtualHeight / 2);

    // In-game retro background with sky, distant towers, clouds, crane, and status HUD
    camera.backdrop.add(GameBackgroundComponent());

    // Retro SCORE display matching inspiration image status bar
    scoreText = TextComponent(
      text: 'SCORE 000',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 18.5,
          color: RetroColors.hudText,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          fontFamily: 'monospace',
        ),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(44, 18),
    );

    camera.viewport.add(scoreText);

    // Stone masonry pedestal platform where the stack is built
    world.add(PedestalPlatform(groundY: groundY));
  }

  /// Safely removes all active Box, Pendulum, GameStack, and temporary gameplay components from world,
  /// and immediately processes pending removals so world is completely clean synchronously.
  void clearGameplayComponents() {
    processLifecycleEvents();
    final toRemove = world.children
        .where((c) => c is! PedestalPlatform)
        .toList();
    for (final component in toRemove) {
      component.removeFromParent();
    }
    processLifecycleEvents();
    if (world.children.whereType<PedestalPlatform>().isEmpty) {
      world.add(PedestalPlatform(groundY: groundY));
      processLifecycleEvents();
    }
  }

  void spawnFirstBox() {
    final box = Box(
      gameSize: Vector2(virtualWidth, virtualHeight),
      onLanded: boxLanded,
      targetBox: null,
      position: Vector2(virtualWidth / 2 - 25, spawnScreenY),
      pendulumSpeedMultiplier: pendulumSpeedMultiplier,
    );
    currentBox = box;
    world.add(box);
  }

  /// Whether the current swinging box is eligible to be dropped.
  bool get canDropBox {
    final box = currentBox;
    return box != null &&
        box.isAttached &&
        !box.isDropping &&
        !box.hasLanded &&
        !gameOver &&
        !paused &&
        playState == GamePlayState.playing;
  }

  /// Drops the swinging box. Physical OK button during gameplay is the primary and only trigger.
  void dropBox() {
    if (!canDropBox) return;
    final box = currentBox;
    if (box != null) {
      if (!hasPerformedFirstDrop) {
        hasPerformedFirstDrop = true;
        showDropHintNotifier.value = false;
      }
      box.drop();
    }
  }

  /// Toggles global sound preference and persists to SharedPreferences.
  Future<void> toggleSound() async {
    soundEnabled = !soundEnabled;
    soundEnabledNotifier.value = soundEnabled;
    GameAudio.soundEnabled = soundEnabled;
    if (!soundEnabled) {
      GameAudio.stopBgm();
    } else {
      if (playState == GamePlayState.playing) {
        GameAudio.playCheerfulBgm();
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, soundEnabled);
  }

  /// Toggles the retro mobile options menu popup.
  void toggleMenu() {
    if (overlays.isActive('Menu')) {
      overlays.remove('Menu');
      if (!overlays.isActive('Pause') &&
          !overlays.isActive('StartScreen') &&
          !gameOver &&
          paused) {
        resumeEngine();
      }
    } else {
      if (!paused) {
        pauseEngine();
      }
      overlays.add('Menu');
    }
  }

  /// Toggles pause/resume on the Flame game engine.
  void togglePause() {
    if (gameOver ||
        overlays.isActive('StartScreen') ||
        overlays.isActive('Menu')) {
      return;
    }
    if (paused) {
      resumeGame();
    } else {
      pauseGame();
    }
  }

  /// Pauses the Flame game engine and shows the retro Pause overlay.
  void pauseGame() {
    if (!paused && !gameOver) {
      pauseEngine();
      overlays.add('Pause');
    }
  }

  /// Resumes the Flame game engine and dismisses the Pause overlay.
  void resumeGame() {
    if (paused) {
      overlays.remove('Pause');
      resumeEngine();
    }
  }

  /// Starts or restarts gameplay from the Title / Start Screen or Game Over.
  void startGame() {
    overlays.remove('StartScreen');
    overlays.remove('Pause');
    overlays.remove('Menu');
    overlays.remove('GameOver');

    // 1. Remove all previous run gameplay components
    clearGameplayComponents();

    // 2. Reset gameplay state
    gameOver = false;
    hasPerformedFirstDrop = false;
    showDropHintNotifier.value = true;
    score = 0;
    scoreText.text = 'SCORE 000';
    lastBox = null;

    // 3. Reset camera and cancel any camera effects
    camera.stop();
    camera.viewfinder.removeAll(
      camera.viewfinder.children.whereType<Effect>().toList(),
    );
    camera.viewfinder.position = Vector2(virtualWidth / 2, virtualHeight / 2);

    // 4. Exactly one owner creates the initial gameplay objects
    stack = GameStack();
    world.add(stack);
    spawnFirstBox();

    // 5. Synchronously process lifecycle events so tree is ready
    processLifecycleEvents();

    if (paused) {
      resumeEngine();
    }

    if (soundEnabled) {
      GameAudio.playCheerfulBgm(forceRestart: true);
    }
  }

  /// Exits back to the Game Home / Start Screen when physical END / Power key is pressed.
  void resetToStartScreen() {
    overlays.remove('GameOver');
    overlays.remove('Pause');
    overlays.remove('Menu');
    if (!overlays.isActive('StartScreen')) {
      overlays.add('StartScreen');
    }

    pauseEngine();
    GameAudio.stopBgm();

    camera.stop();
    camera.viewfinder.removeAll(
      camera.viewfinder.children.whereType<Effect>().toList(),
    );
    camera.viewfinder.position = Vector2(virtualWidth / 2, virtualHeight / 2);

    clearGameplayComponents();

    currentBox = null;
    lastBox = null;
    hasPerformedFirstDrop = false;
    showDropHintNotifier.value = false;
    gameOver = false;
    score = 0;
    scoreText.text = 'SCORE 000';
  }

  /// Centralized physical button handler dispatched from PhoneShell.
  /// Uses explicit state-aware input routing to consume inputs based on current game state.
  void handlePhysicalKey(String key) {
    final currentState = playState;

    switch (key) {
      case 'OK':
        switch (currentState) {
          case GamePlayState.startScreen:
            startGame();
            return; // Consumed completely! Does NOT drop the first box!

          case GamePlayState.menu:
            // Forward OK to Menu overlay for item activation
            keyEventNotifier.value = null;
            keyEventNotifier.value = 'OK';
            return;

          case GamePlayState.gameOver:
            restartGame();
            return;

          case GamePlayState.paused:
            resumeGame();
            return;

          case GamePlayState.playing:
            if (canDropBox) {
              GameAudio.playBoxRelease();
            }
            dropBox();
            return;
        }

      case 'SOUND':
        toggleSound();
        return;

      case 'MENU':
        toggleMenu();
        return;

      case 'PAUSE/RESUME':
        if (currentState == GamePlayState.menu) {
          toggleMenu();
        } else if (currentState == GamePlayState.playing ||
            currentState == GamePlayState.paused) {
          togglePause();
        }
        return;

      case 'END':
        resetToStartScreen();
        return;

      case 'UP':
      case 'DOWN':
        if (currentState == GamePlayState.menu) {
          keyEventNotifier.value = null;
          keyEventNotifier.value = key;
        }
        return;

      case 'LEFT':
      case 'RIGHT':
        // Unassigned directional keys remain inactive
        return;
    }
  }

  void restartGame() {
    startGame();
  }

  @override
  void update(double dt) {
    if (gameOver || playState != GamePlayState.playing) {
      return;
    }

    // Clamp dt to avoid physics explosions during cold startup lag or frame spikes
    final double clampedDt = dt.clamp(0.0, 1.0 / 30.0);

    super.update(clampedDt);

    final box = currentBox;
    if (box != null && box.isDropping && lastBox == null) {
      checkGroundCollision();
    }

    /*
    * Any box that falls below the visible world
    * means the tower has collapsed badly enough
    * to end the game.
    */
    for (final component in world.children) {
      if (component is Box &&
          component.isDropping &&
          component.position.y > camera.visibleWorldRect.bottom + 100) {
        endGame();
        break;
      }
    }
  }

  void endGame() async {
    if (gameOver) return;
    gameOver = true;
    showDropHintNotifier.value = false;
    final box = currentBox;
    if (box != null) {
      box.velocity.setZero();
      box.isDropping = false;
    }

    GameAudio.stopBgm();
    GameAudio.playGameOver();

    overlays.add('GameOver');

    if (score > highScore) {
      highScore = score;
      isNewHighScore = true;

      GameAudio.playHighScore();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highScoreKey, highScore);
    } else {
      isNewHighScore = false;
    }
  }

  void checkGroundCollision() {
    final box = currentBox;
    if (box == null) return;
    if (box.position.y + box.size.y >= groundY) {
      box.position.y = groundY - box.size.y;

      box.velocity.y = 0;
      box.hasLanded = true;
      box.isDropping = false;

      boxLanded();
    }
  }

  void spawnNextBox() {
    final Rect visibleWorld = camera.visibleWorldRect;
    final double spawnWorldY = visibleWorld.top + spawnScreenY;

    final box = Box(
      gameSize: Vector2(virtualWidth, virtualHeight),
      onLanded: boxLanded,
      targetBox: lastBox,
      position: Vector2(virtualWidth / 2 - 25, spawnWorldY),
      pendulumSpeedMultiplier: pendulumSpeedMultiplier,
    );
    currentBox = box;
    world.add(box);
  }

  void boxLanded() {
    final box = currentBox;
    if (box == null || box.hasPlayedLandSound) return;
    box.hasPlayedLandSound = true;
    lastBox = box;

    stack.addBox(box);

    score++;
    scoreText.text = 'SCORE ${score.toString().padLeft(3, '0')}';

    GameAudio.playBoxLand();

    if (shouldMoveCamera()) {
      moveCameraUp();
      return;
    }
    spawnNextBox();
  }

  void moveCameraUp() {
    final double targetStackScreenY = virtualHeight - 250;
    final targetCameraY =
        lastBox!.position.y - (targetStackScreenY - virtualHeight / 2);

    camera.viewfinder.add(
      MoveEffect.to(
        Vector2(camera.viewfinder.position.x, targetCameraY),
        EffectController(duration: 0.5),
        onComplete: () {
          spawnNextBox();
        },
      ),
    );
  }

  bool shouldMoveCamera() {
    final double stackTop = lastBox!.position.y;

    final double visibleTop = camera.visibleWorldRect.top;

    return stackTop <= visibleTop + cameraTriggerY + lastBox!.size.y;
  }

  double get pendulumSpeedMultiplier {
    return 1.0 +
        (score ~/ 4) *
            0.15; // every 7 successful boxes, pendulum gets 15% faster
  }

  @override
  void onRemove() {
    GameAudio.stopBgm();
    super.onRemove();
  }
}
