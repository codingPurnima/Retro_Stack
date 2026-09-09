import 'package:flutter/widgets.dart';

import '../theme/colors.dart';

/// Custom painter for subtle horizontal scanlines (Section 11).
class LcdScanlinePainter extends CustomPainter {
  const LcdScanlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = RetroColors.lcdScanline
      ..strokeWidth = 1.0;

    for (double y = 0.0; y < size.height; y += 3.0) {
      canvas.drawLine(Offset(0.0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
