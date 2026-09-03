part of '../game_stack.dart';

// ------------------------------------------------------------
// GEOMETRY
// ------------------------------------------------------------

extension GameStackGeometry on GameStack {
  // ------------------------------------------------------------
  // APPLY STACK ROTATION
  // ------------------------------------------------------------

  void _applyRotation() {
    final double cosAngle = cos(angle);
    final double sinAngle = sin(angle);

    for (final Box box in boxes) {
      final Vector2 local =
          _localPositions[box]!;

      final double rotatedX =
          local.x * cosAngle -
          local.y * sinAngle;

      final double rotatedY =
          local.x * sinAngle +
          local.y * cosAngle;

      final Vector2 center = Vector2(
        basePivot.x + rotatedX,
        basePivot.y + rotatedY,
      );

      box.position.setValues(
        center.x - box.size.x / 2,
        center.y - box.size.y / 2,
      );

      /*
       * The individual boxes visually follow the stack.
       */
      box.angle = angle;
    }
  }
}