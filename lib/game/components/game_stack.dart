import 'dart:math';

import 'package:flame/components.dart';

import 'box.dart';

part 'game_stack_components/stack_physics.dart';
part 'game_stack_components/stack_geometry.dart';
part 'game_stack_components/stack_collapse.dart';

class GameStack extends Component {
  // ------------------------------------------------------------
  // PHYSICS
  // ------------------------------------------------------------

  /// Gravity used to calculate gravitational torque.
  final double gravity;

  /// Rotational damping.
  ///
  /// Prevents the stack from oscillating forever.
  final double angularDamping;

  /// Small horizontal imbalance that is considered negligible.
  ///
  /// For a 50px box, 0.20 means 10px.
  ///
  /// This is important because a box with very good overlap
  /// should NOT immediately make the tower lean.
  final double balanceTolerance;

  /// Minimum overlap required for two boxes to remain connected.
  ///
  /// Your game requires 60% overlap.
  final double minimumOverlapRatio;

  /// How much angular movement is required before we start
  /// considering the stack genuinely unstable.
  ///
  /// This is NOT the main physics calculation. It simply
  /// prevents tiny floating-point movement from causing collapse.
  final double collapseAngle;

  // ------------------------------------------------------------
  // STACK DATA
  // ------------------------------------------------------------

  final List<Box> boxes = [];

  /// The bottom-center of the first box.
  late Vector2 basePivot;

  /// Current rotation of the complete stack.
  ///
  /// Flame's positive rotation is clockwise on screen.
  double angle = 0.0;

  /// Current angular velocity.
  double angularVelocity = 0.0;

  bool isCollapsing = false;

  /// Position of each box's CENTER relative to [basePivot]
  /// when the box becomes part of the stack.
  final Map<Box, Vector2> _localPositions = {};

  /// Active clusters of boxes currently toppling over in a rotational arc.
  final List<TopplingGroup> _topplingGroups = [];

  GameStack({
    this.gravity = 135,
    this.angularDamping = 5.0,
    this.balanceTolerance = 0.30,
    this.minimumOverlapRatio = 0.60,
    this.collapseAngle = 0.70,
  });

  // ------------------------------------------------------------
  // ADD BOX
  // ------------------------------------------------------------

  void addBox(Box box) {
    if (boxes.contains(box)) {
      return;
    }

    /*
     * The first landed box establishes the base.
     */
    if (boxes.isEmpty) {
      basePivot = Vector2(
        box.position.x + box.size.x / 2,
        box.position.y + box.size.y,
      );
    }

    boxes.add(box);

    /*
     * Store the box center relative to the base.
     *
     * We deliberately capture the position BEFORE the stack
     * starts applying any rotation.
     */
    final Vector2 center = Vector2(
      box.position.x + box.size.x / 2,
      box.position.y + box.size.y / 2,
    );

    _localPositions[box] = center - basePivot;

    box.isInStack = true;

    /*
     * A newly landed box starts with no additional velocity.
     *
     * The stack will decide whether its distribution creates
     * enough torque to move.
     */
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------

  @override
  void update(double dt) {
    super.update(dt);

    // Update active rotational topple animations
    _updateTopplingGroups(dt);

    if (boxes.length < 2) {
      return;
    }

    if (isCollapsing) {
      return;
    }

    _updatePhysics(dt);
    _applyRotation();
    _checkConnections();
  }
}