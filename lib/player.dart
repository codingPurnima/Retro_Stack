import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Player extends RectangleComponent with KeyboardHandler {
  final Vector2 velocity = Vector2.zero();

  Player({required Vector2 gameSize})
    : _gameSize = gameSize,
      super(size: Vector2.all(50), position: Vector2(50, 300));

  final Vector2 _gameSize;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    if (position.x < 0) {
      position.x = 0;
    }

    if (position.x + size.x > _gameSize.x) {
      position.x = _gameSize.x - size.x;
    }

    if (position.y < 0) {
      position.y = 0;
    }

    if (position.y + size.y > _gameSize.y) {
      position.y = _gameSize.y - size.y;
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
}
