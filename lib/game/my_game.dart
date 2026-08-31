import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'components/box.dart';

class MyGame extends FlameGame with TapCallbacks {
  late Box currentBox;
  Box? lastBox;
  final double groundY = 700;
  final double spawnLimitY = 100;

  bool gameOver = false;

  @override
  Future<void> onLoad() async {
    currentBox = Box(gameSize: size);
    add(currentBox);
  }

  @override
  void onTapDown(TapDownEvent event) {
    currentBox.drop();
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
    } else {
      checkBoxCollision();
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

      lastBox = currentBox;

      spawnNextBox();
    }
  }

  void checkBoxCollision() {
    final currentBottom = currentBox.position.y + currentBox.size.y;

    final currentLeft = currentBox.position.x;

    final currentRight = currentBox.position.x + currentBox.size.x;

    final previousTop = lastBox!.position.y;

    final previousLeft = lastBox!.position.x;

    final previousRight = lastBox!.position.x + lastBox!.size.x;

    final isHorizontallyOverlapping =
        currentLeft < previousRight && currentRight > previousLeft;

    if (currentBottom >= previousTop && isHorizontallyOverlapping) {
      currentBox.position.y = previousTop - currentBox.size.y;

      currentBox.velocity.y = 0;
      currentBox.hasLanded = true;
      currentBox.isDropping = false;

      lastBox = currentBox;

      spawnNextBox();
    }
  }

  void spawnNextBox() {
    if (lastBox!.position.y <= spawnLimitY) {
      gameOver = true;
      return;
    }

    currentBox = Box(gameSize: size);

    add(currentBox);
  }
}
