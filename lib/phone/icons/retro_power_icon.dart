
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/theme/colors.dart';

/// Clean printed retro mobile phone power/end symbol (IEC 5009 open circle with vertical stroke).
class RetroPowerIcon extends StatelessWidget {
  final Color color;
  final double size;

  const RetroPowerIcon({
    super.key,
    this.color = RetroColors.buttonIconRed,
    this.size = 13.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RetroPowerPainter(color: color),
    );
  }
}

class _RetroPowerPainter extends CustomPainter {
  final Color color;

  _RetroPowerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 2.0) / 2;

    // Open circle with gap at top (~70 deg gap)
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -pi / 2 + 0.6, 2 * pi - 1.2, false, strokePaint);

    // Vertical power stroke through top gap
    canvas.drawLine(
      Offset(center.dx, 0.5),
      Offset(center.dx, center.dy - 0.5),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RetroPowerPainter oldDelegate) =>
      oldDelegate.color != color;
}
