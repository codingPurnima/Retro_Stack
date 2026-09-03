part of '../game_stack.dart';

// ------------------------------------------------------------
// PHYSICS
// ------------------------------------------------------------

extension GameStackPhysics on GameStack {
  void _updatePhysics(double dt) {
    final double centerOfMassX =
        _calculateCenterOfMassX();

    final double imbalance =
        centerOfMassX - basePivot.x;

    /*
     * Ignore small imbalances.
     *
     * Example:
     *
     * 50px box
     * 80% overlap
     * ~10px maximum center displacement
     *
     * The default tolerance is 10px.
     *
     * Therefore a nicely landed second box will remain upright.
     */
    final double tolerance =
        boxes.first.size.x * balanceTolerance;

    double effectiveImbalance = 0.0;

    if (imbalance.abs() > tolerance) {
      effectiveImbalance =
          imbalance.sign *
          (imbalance.abs() - tolerance);
    }

    /*
     * If the stack is effectively balanced, we don't generate
     * gravitational torque.
     */
    final double totalMass =
        boxes.length.toDouble();

    /*
     * Gravitational torque:
     *
     * τ = r × F
     *
     * In our 2D coordinate system this becomes:
     *
     * τ = horizontal COM offset × total mass × gravity
     */
    final double torque =
        effectiveImbalance *
        totalMass *
        gravity;

    /*
     * Calculate the stack's moment of inertia around the base.
     *
     * This makes taller stacks behave differently from short
     * stacks instead of using an arbitrary "tower height"
     * divisor.
     */
    final double momentOfInertia =
        _calculateMomentOfInertia();

    final double angularAcceleration =
        torque / momentOfInertia -
        angularDamping * angularVelocity;

    /*
     * Semi-implicit Euler integration.
     *
     * This is what gives us continuous, gradual rotation.
     */
    angularVelocity +=
        angularAcceleration * dt;

    angle +=
        angularVelocity * dt;

    /*
     * When essentially balanced and almost stationary,
     * settle the stack exactly at zero.
     */
    if (effectiveImbalance == 0 &&
        angularVelocity.abs() < 0.001) {
      angularVelocity = 0;

      angle *= 0.96;

      if (angle.abs() < 0.0001) {
        angle = 0;
      }
    }
  }

  // ------------------------------------------------------------
  // CENTER OF MASS
  // ------------------------------------------------------------

  double _calculateCenterOfMassX() {
    if (boxes.isEmpty) {
      return basePivot.x;
    }

    double totalMass = 0;
    double weightedX = 0;

    final double cosAngle = cos(angle);
    final double sinAngle = sin(angle);

    for (final Box box in boxes) {
      const double mass = 1.0;

      final Vector2 local =
          _localPositions[box]!;

      /*
       * Rotate the ORIGINAL local position into world space.
       *
       * We don't use box.position here because box.position is
       * itself controlled by this stack.
       */
      final double rotatedX =
          local.x * cosAngle -
          local.y * sinAngle;

      final double worldX =
          basePivot.x + rotatedX;

      weightedX += worldX * mass;
      totalMass += mass;
    }

    return weightedX / totalMass;
  }

  // ------------------------------------------------------------
  // MOMENT OF INERTIA
  // ------------------------------------------------------------

  double _calculateMomentOfInertia() {
    double inertia = 0;

    for (final Box box in boxes) {
      const double mass = 1.0;

      final Vector2 local =
          _localPositions[box]!;

      /*
       * Treat every box as a point mass at its center.
       *
       * I = m r²
       */
      final double distanceSquared =
          local.x * local.x +
          local.y * local.y;

      inertia +=
          mass * distanceSquared;
    }

    /*
     * Prevent division by zero for extremely small stacks.
     */
    return max(inertia, 1.0);
  }
}