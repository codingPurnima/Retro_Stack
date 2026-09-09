import 'package:flutter/widgets.dart';

import '../theme/dimensions.dart';

/// Directional touch target for the D-pad.
class NavDirectionTouch extends StatelessWidget {
  final String label;
  final bool isPressed;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final Widget child;

  const NavDirectionTouch({
    super.key,
    required this.label,
    required this.isPressed,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapCancel,
      child: AnimatedScale(
        duration: RetroDimensions.keyPressDuration,
        scale: isPressed ? 0.85 : 1.0,
        child: Padding(padding: const EdgeInsets.all(2.0), child: child),
      ),
    );
  }
}
