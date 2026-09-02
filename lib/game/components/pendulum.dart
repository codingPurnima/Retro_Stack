import 'dart:math';

import 'package:flame/components.dart';

class Pendulum {
  final double stringLength;
  final double gravity;

  /// Damping coefficient.
  /// Higher values make the pendulum lose energy faster.
  /// A small value keeps the motion natural while preventing
  /// the swing from continuing forever.
  final double damping;

  /// Current angle in radians.
  double angle;

  /// Current angular velocity in radians/second.
  double angularVelocity;

  Pendulum({
    required this.stringLength,
    this.gravity = 900,
    this.damping = 0.08,
    this.angle = 0.45,
    this.angularVelocity = 0,
  });

  /// Advances the pendulum physics by [dt] seconds.
  void update(double dt) {
    // Physical pendulum equation:
    //
    // θ'' = -(g / L) * sin(θ) - damping * θ'
    //
    // The first part is gravity.
    // The second part removes a small amount of energy.

    final double angularAcceleration =
        -(gravity / stringLength) * sin(angle) -
        damping * angularVelocity;

    // Semi-implicit Euler integration.
    //
    // Update velocity first, then position.
    angularVelocity += angularAcceleration * dt;
    angle += angularVelocity * dt;
  }

  /// Returns the position of the end of the string relative
  /// to the pivot.
  Vector2 get bobOffset {
    return Vector2(
      sin(angle) * stringLength,
      cos(angle) * stringLength,
    );
  }

  /// Returns the linear velocity of the bob.
  ///
  /// This is useful when the box is released from the string.
  Vector2 get linearVelocity {
    return Vector2(
      cos(angle) * stringLength * angularVelocity,
      -sin(angle) * stringLength * angularVelocity,
    );
  }

  /// Resets the pendulum.
  void reset({
    double angle = 0.45,
    double angularVelocity = 0,
  }) {
    this.angle = angle;
    this.angularVelocity = angularVelocity;
  }
}