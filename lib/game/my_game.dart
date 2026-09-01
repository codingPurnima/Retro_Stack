import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';

import 'package:flutter/material.dart';

import 'package:retro_stack_frontend/game/my_world.dart';
import 'components/box.dart';

class MyGame extends FlameGame<MyWorld>
    with TapCallbacks, HasCollisionDetection {
  MyGame() : super(world: MyWorld());

  late Box currentBox;
  Box? lastBox;
  final double groundY = 700;

  bool gameOver = false;

  final double spawnScreenY = 100; // point where every new box should appear
  final double cameraTriggerY =
      150; // move camera up when stack reaches this close to the top
  final double cameraShift = 250; // move camera this far up

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

    spawnFirstBox();
  }

  void spawnFirstBox() {
    currentBox = Box(
      gameSize: size,
      onLanded: boxLanded,
      targetBox: null,
      position: Vector2(50, spawnScreenY),
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
    spawnFirstBox();
  }

  @override
  void update(double dt) {
    if (gameOver) {
      return;
    }

    super.update(dt);

    if (!currentBox.isDropping) {
      return;
    }

    if (lastBox == null) {
      checkGroundCollision();
    }

    if (currentBox.position.y > camera.visibleWorldRect.bottom) {
      endGame();
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
      position: Vector2(50, spawnWorldY),
    );

    world.add(currentBox);
  }

  void boxLanded() {
    lastBox = currentBox;

    score++;
    scoreText.text = '$score';

    if (shouldMoveCamera()) {
      moveCameraUp();
      return;
    }
    spawnNextBox();
  }

  void moveCameraUp() {
    final targetCameraY = camera.viewfinder.position.y - cameraShift;

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
}
