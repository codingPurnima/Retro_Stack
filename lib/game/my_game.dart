import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';

import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/game/components/pedestal_platform.dart';

import 'package:retro_stack_frontend/game/my_world.dart';
import 'package:retro_stack_frontend/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/box.dart';
import '../backgrounds/game_background.dart';
import 'components/game_stack.dart';

class MyGame extends FlameGame<MyWorld>
    with TapCallbacks, HasCollisionDetection {
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
      );

  late Box currentBox;
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

  @override
  Future<void> onLoad() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(_highScoreKey) ?? 0;

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

    stack = GameStack();
    world.add(stack);

    spawnFirstBox();
  }

  void spawnFirstBox() {
    currentBox = Box(
      gameSize: Vector2(virtualWidth, virtualHeight),
      onLanded: boxLanded,
      targetBox: null,
      position: Vector2(virtualWidth / 2 - 25, spawnScreenY),
      pendulumSpeedMultiplier: pendulumSpeedMultiplier,
    );
    world.add(currentBox);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!currentBox.hasLanded) {
      currentBox.drop();
    }
  }

  void restartGame() {
    overlays.remove("GameOver");
    gameOver = false;

    score = 0;
    scoreText.text = 'SCORE 000';

    camera.stop();
    camera.viewfinder.position = Vector2(virtualWidth / 2, virtualHeight / 2);
    world.removeAll(world.children.toList());
    lastBox = null;

    world.add(PedestalPlatform(groundY: groundY));
    stack = GameStack();
    world.add(stack);
    spawnFirstBox();
  }

  @override
  void update(double dt) {
    if (gameOver) {
      return;
    }

    // Clamp dt to avoid physics explosions during cold startup lag or frame spikes
    final double clampedDt = dt.clamp(0.0, 1.0 / 30.0);

    super.update(clampedDt);

    if (currentBox.isDropping && lastBox == null) {
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
    gameOver = true;
    currentBox.velocity.setZero();
    currentBox.isDropping = false;
    overlays.add('GameOver');

    if (score > highScore) {
      highScore = score;
      isNewHighScore = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highScoreKey, highScore);
    } else {
      isNewHighScore = false;
    }
    overlays.add('GameOver');
  }

  void checkGroundCollision() {
    if (currentBox.position.y + currentBox.size.y >= groundY) {
      currentBox.position.y = groundY - currentBox.size.y;

      currentBox.velocity.y = 0;
      currentBox.hasLanded = true;
      currentBox.isDropping = false;

      boxLanded();
    }
  }

  void spawnNextBox() {
    final Rect visibleWorld = camera.visibleWorldRect;
    final double spawnWorldY = visibleWorld.top + spawnScreenY;

    currentBox = Box(
      gameSize: Vector2(virtualWidth, virtualHeight),
      onLanded: boxLanded,
      targetBox: lastBox,
      position: Vector2(virtualWidth / 2 - 25, spawnWorldY),
      pendulumSpeedMultiplier: pendulumSpeedMultiplier,
    );

    world.add(currentBox);
  }

  void boxLanded() {
    lastBox = currentBox;

    stack.addBox(currentBox);

    score++;
    scoreText.text = 'SCORE ${score.toString().padLeft(3, '0')}';

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
        (score ~/ 7) *
            0.15; // every 7 successful boxes, pendulum gets 15% faster
  }
}
