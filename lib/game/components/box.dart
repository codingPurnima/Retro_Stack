import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/game/components/pendulum.dart';

class Box extends RectangleComponent with CollisionCallbacks {
  final Vector2 gameSize;

  final VoidCallback onLanded;
  final Box? targetBox;

  // PENDULUM
  late Vector2 pivot;
  final Pendulum pendulum;
  bool isAttached = true;

  final double pendulumSpeedMultiplier;

  // FALLING
  final Vector2 velocity = Vector2.zero();
  final double gravity = 900;

  bool hasLanded = false;
  bool isDropping = false;

  Box({
    required this.gameSize,
    required this.onLanded,
    required this.targetBox,
    required Vector2 position,
    this.pendulumSpeedMultiplier=1.0,

    double stringLength = 200,
    double pendulumGravity = 900,
    double damping = 0.08,
    double initialAngle = 0.35,
    double initialAngularVelocity = 0,
  }) : pendulum = Pendulum(
         stringLength: stringLength,
         gravity: pendulumGravity,
         damping: damping,
         angle: initialAngle,
         angularVelocity: initialAngularVelocity,
         speedMultiplier: pendulumSpeedMultiplier,
       ),
       super(size: Vector2.all(50), position: position) {
    pivot = Vector2(position.x + size.x / 2, position.y - stringLength);
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isAttached) {
      updatePendulum(dt);
    } else if (isDropping) {
      updateFalling(dt);
    }
  }

  void updatePendulum(double dt) {
    pendulum.update(dt);

    final Vector2 bobOffset = pendulum.bobOffset;

    // bobOffset represents the position of the box's top-center relative to the pivot.

    final double boxCenterX = pivot.x + bobOffset.x;

    final double boxTopY = pivot.y + bobOffset.y;

    position.x = boxCenterX - size.x / 2;

    position.y = boxTopY;
  }

  void drop() {
    if (!isAttached || hasLanded) {
      return;
    }

    // Get the actual linear velocity produced by the physical pendulum at the moment of release.
    final Vector2 releaseVelocity = pendulum.linearVelocity;

    velocity.setFrom(releaseVelocity);

    // Add a little downward velocity.
    //
    // This makes the release feel more natural for the
    // stacking mechanic instead of allowing the box to
    // momentarily move upward.
    // if (velocity.y < 0) {
    //   velocity.y = 0;
    // }

    // The string is now detached.
    isAttached = false;
    isDropping = true;
  }

  void updateFalling(double dt) {
    velocity.y += gravity * dt;

    position += velocity * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other == targetBox && isDropping && !hasLanded) {
      if (hasValidOverlap(targetBox!)) {
        stopY();
        position.y = targetBox!.position.y - size.y;
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
    final double targetRight = target.position.x + target.size.x;

    final double overlapLeft = max(currentLeft, targetLeft);

    final double overlapRight = min(currentRight, targetRight);

    final double overlapWidth = overlapRight - overlapLeft;

    return overlapWidth >= (size.x / 2) - 10;
  }

  void stopX() {
    velocity.x = 0;
  }

  void stopY() {
    velocity.y = 0;
  }

  @override
  void render(Canvas canvas) {
    if (isAttached) {
      final Paint paint = Paint()
        ..color = Colors.white
        ..strokeWidth = 3;

      // Box's top-center in local coordinates.
      final Offset boxTopCenter = Offset(size.x / 2, 0);

      // Convert the world-space pivot into the Box's
      // local coordinate system.
      final Offset localPivot = Offset(
        pivot.x - position.x,
        pivot.y - position.y,
      );

      canvas.drawLine(localPivot, boxTopCenter, paint);
    }

    super.render(canvas);
  }
}
