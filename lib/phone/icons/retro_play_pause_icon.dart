
import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/theme/colors.dart';

/// Clean printed retro mobile phone pause/resume symbol (play triangle + pause bars).
class RetroPlayPauseIcon extends StatelessWidget {
  final Color color;
  final double size;

  const RetroPlayPauseIcon({
    super.key,
    this.color = RetroColors.buttonIconRed,
    this.size = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.75),
      painter: _RetroPlayPausePainter(color: color),
    );
  }
}

class _RetroPlayPausePainter extends CustomPainter {
  final Color color;

  _RetroPlayPausePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double h = size.height;
    final double midY = h / 2;

    // Play triangle on left
    final playPath = Path()
      ..moveTo(0, 0.5)
      ..lineTo(6.0, midY)
      ..lineTo(0, h - 0.5)
      ..close();
    canvas.drawPath(playPath, paint);

    // Pause bars on right
    final double barWidth = 1.8;
    final double barGap = 1.5;
    final double startX = 8.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(startX, 0.5, barWidth, h - 1.0),
        const Radius.circular(0.5),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(startX + barWidth + barGap, 0.5, barWidth, h - 1.0),
        const Radius.circular(0.5),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RetroPlayPausePainter oldDelegate) =>
      oldDelegate.color != color;
}
