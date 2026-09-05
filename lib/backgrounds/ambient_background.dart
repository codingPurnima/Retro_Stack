import 'package:flutter/widgets.dart';
import 'ambient_background_painter.dart';

/// Ambient backdrop rendering a soft atmospheric pixel-art sky, distant towers,
/// gentle pixel clouds, and a grounded table reflection outside the phone.
class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Custom-painted atmospheric backdrop
        const Positioned.fill(
          child: CustomPaint(
            painter: AmbientBackdropPainter(),
          ),
        ),
        // Child content (PhoneShell)
        child,
      ],
    );
  }
}


