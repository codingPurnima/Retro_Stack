import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';

import 'package:flutter/material.dart';

import 'package:retro_stack_frontend/game/my_world.dart';
import 'components/box.dart';
import 'components/game_stack.dart';

class MyGame extends FlameGame<MyWorld>
    with TapCallbacks, HasCollisionDetection {
  MyGame() : super(world: MyWorld());

  late Box currentBox;
  Box? lastBox;
  final double groundY = 700;

  late GameStack stack;

  bool gameOver = false;

  final double spawnScreenY = 100; // point where every new box should appear
  final double cameraTriggerY =
      150; // move camera up when stack reaches this close to the top

  int score = 0;
  late TextComponent scoreText;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.position = size / 2;

    scoreText = TextComponent(
      text: '0',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 20),
    );

    camera.viewport.add(scoreText);

    stack = GameStack();
    world.add(stack);

    spawnFirstBox();
  }

  void spawnFirstBox() {
    currentBox = Box(
      gameSize: size,
      onLanded: boxLanded,
      targetBox: null,
      position: Vector2(size.x / 2 - 25, spawnScreenY),
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
    scoreText.text = '0';

    camera.stop();
    camera.viewfinder.position = size / 2;
    world.removeAll(world.children.toList());
    lastBox = null;

    stack = GameStack();
    world.add(stack);
    spawnFirstBox();
  }

  @override
  void update(double dt) {
    if (gameOver) {
      return;
    }

    super.update(dt);

    if (currentBox.isDropping &&
        lastBox == null) {
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
          component.position.y >
              camera.visibleWorldRect.bottom + 100) {
        endGame();
        break;
      }
    }
  }

  void endGame() {
    gameOver = true;
    currentBox.velocity.setZero();
    currentBox.isDropping = false;
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
      gameSize: size,
      onLanded: boxLanded,
      targetBox: lastBox,
      position: Vector2(size.x / 2 - 25, spawnWorldY),
      pendulumSpeedMultiplier: pendulumSpeedMultiplier,
    );

    world.add(currentBox);
  }

  void boxLanded() {
    lastBox = currentBox;

    stack.addBox(currentBox);

    score++;
    scoreText.text = '$score';

    if (shouldMoveCamera()) {
      moveCameraUp();
      return;
    }
    spawnNextBox();
  }

  void moveCameraUp() {
    final double targetStackScreenY = size.y - 250;
    // final targetCameraY = camera.viewfinder.position.y - cameraShift;
    final targetCameraY =
        lastBox!.position.y - (targetStackScreenY - size.y / 2);

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
