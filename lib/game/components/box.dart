import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Box extends RectangleComponent with KeyboardHandler {
  final Vector2 velocity = Vector2(100, 0);
  final Vector2 gameSize;

  bool hasLanded = false;
  bool isDropping = false;

  Box({required this.gameSize})
    : super(size: Vector2.all(50), position: Vector2(50, 100));

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    if (position.x < 0) {
      position.x = 0;
      autoMovementX();
    }

    if (position.x + size.x > gameSize.x) {
      position.x = gameSize.x - size.x;
      autoMovementX();
    }
  }

  void handleInput(Set<LogicalKeyboardKey> keysPressed) {
    velocity.x = 0;
    velocity.y = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = 200;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -200;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      velocity.y = -200;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      velocity.y = 200;
    }
  }

  void moveLeft() {
    velocity.x = -200;
  }

  void moveRight() {
    velocity.x = 200;
  }

  void moveDown() {
    velocity.y = 200;
  }

  void stopX() {
    velocity.x = 0;
  }

  void stopY() {
    velocity.y = 0;
  }

  void autoMovementX() {
    velocity.x = -velocity.x;
  }

  void drop() {
    velocity.x = 0;
    moveDown();
    isDropping = true;
  }
}
