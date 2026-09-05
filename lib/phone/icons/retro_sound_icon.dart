import 'dart:math';

import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/theme/colors.dart';

/// Clean printed retro mobile phone sound symbol (speaker cone + sound waves).
class RetroSoundIcon extends StatelessWidget {
  final Color color;
  final double size;

  const RetroSoundIcon({
    super.key,
    this.color = RetroColors.buttonIconRed,
    this.size = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.8),
      painter: _RetroSoundPainter(color: color),
    );
  }
}

class _RetroSoundPainter extends CustomPainter {
  final Color color;

  _RetroSoundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final double h = size.height;
    final double midY = h / 2;

    // Speaker body: small back box + flared cone
    final path = Path()
      ..moveTo(0, midY - 2.5)
      ..lineTo(3.5, midY - 2.5)
      ..lineTo(8.0, 1.0)
      ..lineTo(8.0, h - 1.0)
      ..lineTo(3.5, midY + 2.5)
      ..lineTo(0, midY + 2.5)
      ..close();
    canvas.drawPath(path, fillPaint);

    // Sound waves (two arcs)
    final wave1Rect = Rect.fromCenter(
      center: Offset(6.5, midY),
      width: 8.5,
      height: 8.5,
    );
    canvas.drawArc(wave1Rect, -pi / 3, 2 * pi / 3, false, strokePaint);

    final wave2Rect = Rect.fromCenter(
      center: Offset(6.5, midY),
      width: 14.0,
      height: 14.0,
    );
    canvas.drawArc(wave2Rect, -pi / 3.5, 2 * pi / 3.5, false, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _RetroSoundPainter oldDelegate) =>
      oldDelegate.color != color;
}
