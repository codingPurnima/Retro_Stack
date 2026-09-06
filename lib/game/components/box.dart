import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/game/components/pendulum.dart';
import 'package:retro_stack_frontend/theme/colors.dart';

class Box extends RectangleComponent with CollisionCallbacks {
  final Vector2 gameSize;

  final VoidCallback onLanded;
  final Box? targetBox;

  // PENDULUM
  late Vector2 pivot;
  final Pendulum pendulum;
  bool isAttached = true;

  final double pendulumSpeedMultiplier;
  final double horizontalVelocityTransfer = 0.45;

  // FALLING
  final Vector2 velocity = Vector2.zero();
  final double gravity = 900;
  double angularVelocity = 0.0;

  bool hasLanded = false;
  bool isDropping = false;
  bool isInStack = false;

  Box({
    required this.gameSize,
    required this.onLanded,
    required this.targetBox,
    required Vector2 position,
    this.pendulumSpeedMultiplier = 1.0,

    double stringLength = 200,
    double pendulumGravity = 900,
    double damping = 0.08,
    double initialAngle = 0.35,
    double initialAngularVelocity = 0,
    double energyRecovery = 0.90,
  }) : pendulum = Pendulum(
         stringLength: stringLength,
         gravity: pendulumGravity,
         damping: damping,
         angle: initialAngle,
         angularVelocity: initialAngularVelocity,
         speedMultiplier: pendulumSpeedMultiplier,
         energyRecovery: energyRecovery,
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
    } else if (isDropping && !isInStack) {
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

    velocity.setValues(releaseVelocity.x * horizontalVelocityTransfer, releaseVelocity.y);

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
    angle += angularVelocity * dt;
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
        isInStack = true;

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

    final double overlapWidth = max(0.0, overlapRight - overlapLeft);

    final double requiredRatio = size.x * 0.60;
    const double epsilon = 0.5;

    final bool valid = overlapWidth + epsilon >= requiredRatio;
    return valid;
  }

  void stopX() {
    velocity.x = 0;
  }

  void stopY() {
    velocity.y = 0;
  }

  @override
  void render(Canvas canvas) {
    // 1. Draw the crane cable / chain and hook when swinging
    if (isAttached) {
      final Offset boxTopCenter = Offset(size.x / 2, 0);
      final Offset localPivot = Offset(
        pivot.x - position.x,
        pivot.y - position.y,
      );

      // Chain cable
      final Paint chainPaint = Paint()
        ..color = RetroColors.craneChain
        ..strokeWidth = 3.0;
      canvas.drawLine(localPivot, boxTopCenter, chainPaint);

      // Chain link tick highlights
      final Paint chainHighlight = Paint()
        ..color = RetroColors.craneGirderLight
        ..strokeWidth = 1.2;
      canvas.drawLine(
        Offset(localPivot.dx + 0.5, localPivot.dy),
        Offset(boxTopCenter.dx + 0.5, boxTopCenter.dy),
        chainHighlight,
      );

      // Top metallic shackle / hook bracket
      final Paint shacklePaint = Paint()..color = RetroColors.craneGirderDark;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(boxTopCenter.dx, -3.0),
          width: 8.0,
          height: 6.0,
        ),
        shacklePaint,
      );
      final Paint shackleHighlight = Paint()
        ..color = RetroColors.craneGirderLight;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(boxTopCenter.dx, -4.5),
          width: 6.0,
          height: 2.0,
        ),
        shackleHighlight,
      );
    }

    // 2. Draw Stone Block Body (50x50)
    final double w = size.x;
    final double h = size.y;

    // Outer dark outline
    final Paint borderPaint = Paint()..color = RetroColors.stoneBlockBorder;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), borderPaint);

    // Inner main stone face
    final Paint mainPaint = Paint()..color = RetroColors.stoneBlockMain;
    canvas.drawRect(Rect.fromLTWH(1.5, 1.5, w - 3.0, h - 3.0), mainPaint);

    // Top & Left highlight bevel
    final Paint highlightPaint = Paint()
      ..color = RetroColors.stoneBlockHighlight;
    // Top bevel bar
    canvas.drawRect(Rect.fromLTWH(1.5, 1.5, w - 3.0, 2.5), highlightPaint);
    // Left bevel bar
    canvas.drawRect(Rect.fromLTWH(1.5, 1.5, 2.5, h - 3.0), highlightPaint);

    // Bottom & Right shadow bevel
    final Paint shadowPaint = Paint()..color = RetroColors.stoneBlockShadow;
    // Bottom shadow bar
    canvas.drawRect(Rect.fromLTWH(1.5, h - 4.0, w - 3.0, 2.5), shadowPaint);
    // Right shadow bar
    canvas.drawRect(Rect.fromLTWH(w - 4.0, 1.5, 2.5, h - 3.0), shadowPaint);

    // Subtle stone cleft / masonry fissures
    final Paint detailPaint = Paint()..color = RetroColors.stoneBlockDetail;
    canvas.drawRect(Rect.fromLTWH(16.0, 14.0, 2.0, 18.0), detailPaint);
    canvas.drawRect(Rect.fromLTWH(18.0, 22.0, 10.0, 2.0), detailPaint);
    canvas.drawRect(Rect.fromLTWH(32.0, 28.0, 2.0, 12.0), detailPaint);
  }
}
