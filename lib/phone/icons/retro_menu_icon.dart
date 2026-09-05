import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';

/// Clean printed retro mobile phone menu symbol (three horizontal bars).
class RetroMenuIcon extends StatelessWidget {
  final Color color;
  final double size;

  const RetroMenuIcon({
    super.key,
    this.color = RetroColors.buttonIconRed,
    this.size = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.75),
      painter: _RetroMenuPainter(color: color),
    );
  }
}

class _RetroMenuPainter extends CustomPainter {
  final Color color;

  _RetroMenuPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double left = 1.0;
    final double right = size.width - 1.0;
    final double spacing = size.height / 2;

    canvas.drawLine(Offset(left, 0), Offset(right, 0), paint);
    canvas.drawLine(Offset(left, spacing), Offset(right, spacing), paint);
    canvas.drawLine(Offset(left, size.height), Offset(right, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _RetroMenuPainter oldDelegate) =>
      oldDelegate.color != color;
}
