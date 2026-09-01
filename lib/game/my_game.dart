import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'components/box.dart';

class MyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Box currentBox;
  Box? lastBox;
  final double groundY = 700;
  final double spawnLimitY = 100;

  bool gameOver = false;

  @override
  Future<void> onLoad() async {
    currentBox = Box(gameSize: size, onLanded: boxLanded, targetBox: null);
    add(currentBox);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!currentBox.hasLanded) {
      currentBox.drop();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameOver) {
      return;
    }

    if (!currentBox.isDropping) {
      return;
    }

    if (lastBox == null) {
      checkGroundCollision();
    }

    if (currentBox.position.y > size.y) {
      gameOver = true;
    }
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
    currentBox = Box(gameSize: size, onLanded: boxLanded, targetBox: lastBox);

    add(currentBox);
  }

  void boxLanded() {
    lastBox = currentBox;
    spawnNextBox();
  }
}
