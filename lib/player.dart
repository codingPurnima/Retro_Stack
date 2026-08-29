import 'package:flame/components.dart';

class Player extends RectangleComponent {
  Player() : super(size: Vector2.all(50), position: Vector2(10, 100));

  @override
  void update(double dt) {
    super.update(dt);
    position.x += 100 * dt;

    if (position.x > 400) {
      position.x = 0;
    }
  }
}
