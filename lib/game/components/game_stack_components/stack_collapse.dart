part of '../game_stack.dart';

// ------------------------------------------------------------
// COLLISION / CONNECTION & ROTATIONAL TOPPLE
// ------------------------------------------------------------

extension GameStackCollapse on GameStack {
  void _checkConnections() {
    /*
     * Check from the TOP downward.
     *
     * If Box i loses overlap support on Box i-1, Box i and all boxes
     * above it topple smoothly to the side in a rotational arc.
     */
    for (int i = boxes.length - 1; i > 0; i--) {
      final Box upper = boxes[i];
      final Box lower = boxes[i - 1];

      final double overlap = _calculateOverlap(
        upper,
        lower,
      );

      final double requiredOverlap =
          upper.size.x * minimumOverlapRatio;

      if (overlap < requiredOverlap) {
        _startTopple(i);
        return;
      }
    }

    /*
     * If the tower has become excessively tilted, topple the entire stack
     * above the base around the contact edge.
     */
    if (angle.abs() >= collapseAngle && boxes.length > 1) {
      _startTopple(1);
    }
  }

  // ------------------------------------------------------------
  // OVERLAP CALCULATION
  // ------------------------------------------------------------

  double _calculateOverlap(
    Box upper,
    Box lower,
  ) {
    final double upperLeft = upper.position.x;
    final double upperRight = upper.position.x + upper.size.x;

    final double lowerLeft = lower.position.x;
    final double lowerRight = lower.position.x + lower.size.x;

    final double overlapLeft = max(upperLeft, lowerLeft);
    final double overlapRight = min(upperRight, lowerRight);

    return max(
      0,
      overlapRight - overlapLeft,
    );
  }

  // ------------------------------------------------------------
  // ROTATIONAL TOPPLE INITIATION
  // ------------------------------------------------------------

  void _startTopple(int index) {
    if (index <= 0 || index >= boxes.length) {
      return;
    }

    final Box upper = boxes[index];
    final Box lower = boxes[index - 1];

    final double upperCenterX = upper.position.x + upper.size.x / 2;
    final double lowerCenterX = lower.position.x + lower.size.x / 2;
    final double offset = upperCenterX - lowerCenterX;

    // Determine topple direction: +1 = right (clockwise), -1 = left (counter-clockwise)
    int toppleDirection;
    if (offset.abs() > 0.5) {
      toppleDirection = offset.isNegative ? -1 : 1;
    } else if (angle.abs() > 0.02) {
      toppleDirection = angle.isNegative ? -1 : 1;
    } else {
      toppleDirection = 1;
    }

    // Fulcrum is the top edge/corner of the supporting box on the fall side
    final double fulcrumX = toppleDirection > 0
        ? lower.position.x + lower.size.x
        : lower.position.x;
    final double fulcrumY = lower.position.y;
    final Vector2 fulcrum = Vector2(fulcrumX, fulcrumY);

    final List<Box> topplingBoxes = boxes.sublist(index);
    boxes.removeRange(index, boxes.length);

    // Un-rotate current box positions to establish local relative offsets around the fulcrum
    final double cosCurrent = cos(angle);
    final double sinCurrent = sin(angle);
    final Map<Box, Vector2> localOffsets = {};

    for (final Box box in topplingBoxes) {
      _localPositions.remove(box);
      box.isInStack = false;
      box.hasLanded = false;
      box.isDropping = false; // Controlled by TopplingGroup during the rotational arc

      final Vector2 center = Vector2(
        box.position.x + box.size.x / 2,
        box.position.y + box.size.y / 2,
      );

      final double dx = center.x - fulcrum.x;
      final double dy = center.y - fulcrum.y;

      // Inverse-rotate by current stack angle
      final double unrotX = dx * cosCurrent + dy * sinCurrent;
      final double unrotY = -dx * sinCurrent + dy * cosCurrent;

      localOffsets[box] = Vector2(unrotX, unrotY);
    }

    // Initial angular velocity kick in the direction of the fall
    final double initialAngVel =
        toppleDirection * max(angularVelocity.abs() * 1.5, 1.8);

    _topplingGroups.add(
      TopplingGroup(
        boxes: topplingBoxes,
        fulcrum: fulcrum,
        localOffsets: localOffsets,
        direction: toppleDirection,
        angle: angle,
        angularVelocity: initialAngVel,
      ),
    );

    // Stabilize or reset remaining standing tower
    if (boxes.length == 1) {
      angle = 0;
      angularVelocity = 0;
      boxes.first.angle = 0;
    } else {
      angularVelocity *= 0.2;
    }
  }

  // ------------------------------------------------------------
  // UPDATE ACTIVE TOPPLING GROUPS
  // ------------------------------------------------------------

  void _updateTopplingGroups(double dt) {
    if (_topplingGroups.isEmpty) {
      return;
    }

    for (final TopplingGroup group in _topplingGroups) {
      group.update(dt);
    }

    _topplingGroups.removeWhere((group) => group.isFinished);
  }
}

// ------------------------------------------------------------
// TOPPLING CLUSTER (ARC ROTATION CONTROLLER)
// ------------------------------------------------------------

class TopplingGroup {
  final List<Box> boxes;
  final Vector2 fulcrum;
  final Map<Box, Vector2> localOffsets;
  final int direction; // +1 = right (clockwise), -1 = left (counter-clockwise)
  double angle;
  double angularVelocity;
  bool isFinished = false;

  TopplingGroup({
    required this.boxes,
    required this.fulcrum,
    required this.localOffsets,
    required this.direction,
    required this.angle,
    required this.angularVelocity,
  });

  void update(double dt) {
    if (isFinished) {
      return;
    }

    // Accelerating torque as the tower leans further: tau ~ g * sin(angle)
    final double absAngle = angle.abs();
    final double angularAcceleration =
        direction * (6.0 + 16.0 * sin(min(absAngle, pi / 2)));

    angularVelocity += angularAcceleration * dt;
    angle += angularVelocity * dt;

    final double cosA = cos(angle);
    final double sinA = sin(angle);

    for (final Box box in boxes) {
      final Vector2 local = localOffsets[box]!;

      final double rotX = local.x * cosA - local.y * sinA;
      final double rotY = local.x * sinA + local.y * cosA;

      box.position.setValues(
        fulcrum.x + rotX - box.size.x / 2,
        fulcrum.y + rotY - box.size.y / 2,
      );

      box.angle = angle;
    }

    // Once rotated to approximately 80 degrees (~1.4 rad), release into freefall with momentum
    if (absAngle >= pi * 0.44) {
      release();
    }
  }

  void release() {
    isFinished = true;

    for (final Box box in boxes) {
      box.isInStack = false;
      box.hasLanded = false;
      box.isDropping = true;

      // Tangential velocity v = omega x r
      final double rX = (box.position.x + box.size.x / 2) - fulcrum.x;
      final double rY = (box.position.y + box.size.y / 2) - fulcrum.y;

      final double tangentialX = -rY * angularVelocity;
      final double tangentialY = rX * angularVelocity;

      box.velocity.x = tangentialX + direction * 40.0;
      box.velocity.y = tangentialY + 20.0;

      // Impart rotational tumbling spin to each falling box
      box.angularVelocity = angularVelocity * 0.6;
      box.angle = angle;
    }
  }
}