import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Box extends RectangleComponent with CollisionCallbacks {
  final Vector2 velocity = Vector2(100, 0);
  final Vector2 gameSize;

  bool hasLanded = false;
  bool isDropping = false;

  final VoidCallback onLanded;
  final Box? targetBox;

  Box({required this.gameSize, required this.onLanded, required this.targetBox, required Vector2 position})
    : super(size: Vector2.all(50), position: position);

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

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other == targetBox && isDropping && !hasLanded) {
      if(hasValidOverlap(targetBox!)){
        stopY();
        isDropping = false;
        hasLanded = true;

        onLanded();
      }
    }
  }

  bool hasValidOverlap(Box target) {
  final double currentLeft = position.x;
  final double currentRight = position.x + size.x;

  final double targetLeft = target.position.x;
  final double targetRight =
      target.position.x + target.size.x;

  final double overlapLeft =
      max(currentLeft, targetLeft);

  final double overlapRight =
      min(currentRight, targetRight);

  final double overlapWidth =
      overlapRight - overlapLeft;

  return overlapWidth >= (size.x / 2) -10;
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
