import 'package:flame/components.dart';
import 'package:flutter/services.dart';
class Player extends RectangleComponent with KeyboardHandler {
  final Vector2 velocity = Vector2.zero();

  Player() : super(size: Vector2.all(50), position: Vector2(10, 100));

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  void handleInput(Set<LogicalKeyboardKey> keysPressed) {
    velocity.x = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = 200;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -200;
    }
  }
}
