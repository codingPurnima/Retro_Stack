part of '../game_stack.dart';

// ------------------------------------------------------------
// COLLISION / CONNECTION
// ------------------------------------------------------------

extension GameStackCollapse on GameStack {
  void _checkConnections() {
    /*
     * Check from the TOP downward.
     *
     * This means if Box 5 loses support:
     *
     * 1,2,3,4 remain
     * 5 falls
     *
     * rather than throwing the whole tower away.
     */
    for (int i = boxes.length - 1; i > 0; i--) {
      final Box upper = boxes[i];
      final Box lower = boxes[i - 1];

      final double overlap =
          _calculateOverlap(
        upper,
        lower,
      );

      final double requiredOverlap =
          upper.size.x *
          minimumOverlapRatio;

      if (overlap < requiredOverlap) {
        _detachFrom(i);
        return;
      }
    }

    /*
     * If the tower has become extremely tilted and still happens
     * to have mathematical overlap everywhere, allow the highest
     * connection to fail.
     *
     * This prevents an impossible tower from remaining frozen.
     */
    if (angle.abs() >= collapseAngle &&
        boxes.length > 1) {
      _detachFrom(boxes.length - 1);
    }
  }

  // ------------------------------------------------------------
  // OVERLAP
  // ------------------------------------------------------------

  double _calculateOverlap(
    Box upper,
    Box lower,
  ) {
    final double upperLeft =
        upper.position.x;

    final double upperRight =
        upper.position.x + upper.size.x;

    final double lowerLeft =
        lower.position.x;

    final double lowerRight =
        lower.position.x + lower.size.x;

    final double overlapLeft =
        max(upperLeft, lowerLeft);

    final double overlapRight =
        min(upperRight, lowerRight);

    return max(
      0,
      overlapRight - overlapLeft,
    );
  }

  // ------------------------------------------------------------
  // DETACH
  // ------------------------------------------------------------

  void _detachFrom(int index) {
    if (index <= 0 ||
        index >= boxes.length) {
      return;
    }

    isCollapsing = true;

    final List<Box> fallingBoxes =
        boxes.sublist(index);

    boxes.removeRange(
      index,
      boxes.length,
    );

    for (final Box box in fallingBoxes) {
      final Vector2? local =
          _localPositions.remove(box);

      box.isInStack = false;
      box.hasLanded = false;
      box.isDropping = true;

      /*
       * Transfer the stack's angular motion to the falling box.
       *
       * v = ω × r
       */
      if (local != null) {
        final double tangentialX =
            -local.y * angularVelocity;

        final double tangentialY =
            local.x * angularVelocity;

        box.velocity.x +=
            tangentialX;

        box.velocity.y +=
            tangentialY;
      }

      /*
       * Small outward push in the direction of the lean.
       */
      box.velocity.x +=
          sin(angle) * 80;

      box.velocity.y +=
          cos(angle).abs() * 10;

      box.angle = angle;
    }

    /*
     * The remaining tower is still a valid stack.
     */
    isCollapsing = false;

    /*
     * A collapse removes some rotational energy.
     */
    angularVelocity *= 0.35;

    /*
     * If only the base remains, return it to upright.
     */
    if (boxes.length == 1) {
      angle = 0;
      angularVelocity = 0;
      boxes.first.angle = 0;
    }
  }
}