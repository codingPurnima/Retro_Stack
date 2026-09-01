import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';

import 'package:retro_stack_frontend/game/my_world.dart';

import 'components/box.dart';

class MyGame extends FlameGame<MyWorld>
    with TapCallbacks, HasCollisionDetection {
  MyGame() : super(world: MyWorld());

  late Box currentBox;
  Box? lastBox;
  final double groundY = 700;

  bool gameOver = false;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.position = size / 2;

    currentBox = Box(
      gameSize: size,
      onLanded: boxLanded,
      targetBox: null,
      position: Vector2(50, 100),
    );
    world.add(currentBox);
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
    final spawnY = camera.visibleWorldRect.top + 50;
    currentBox = Box(
      gameSize: size,
      onLanded: boxLanded,
      targetBox: lastBox,
      position: Vector2(50, spawnY),
    );

    world.add(currentBox);
  }

  void boxLanded() {
    lastBox = currentBox;

    if (isStackNearTop()) {
      moveCameraUp();
    }
    spawnNextBox();
  }

  void moveCameraUp() {
    camera.viewfinder.add(
    MoveByEffect(
      Vector2(0, -200),
      EffectController(duration: 0.5),
    ),
  );
  }

  bool isStackNearTop() {
    return lastBox!.position.y <= camera.visibleWorldRect.top + 100;
  }
}
