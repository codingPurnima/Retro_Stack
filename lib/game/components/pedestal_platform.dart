import 'dart:ui';

import 'package:flame/components.dart';
import 'package:retro_stack_frontend/game/my_game.dart';
import 'package:retro_stack_frontend/theme/colors.dart';

/// The stone masonry pedestal platform on which the stack tower is built.
class PedestalPlatform extends PositionComponent {
  PedestalPlatform({required double groundY})
    : super(
        position: Vector2(MyGame.virtualWidth / 2 - 220, groundY),
        size: Vector2(440, 32),
      );

  @override
  void render(Canvas canvas) {
    final double w = size.x;
    final double h = size.y;

    // Dark outline
    final borderPaint = Paint()..color = RetroColors.pedestalBorder;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), borderPaint);

    // Main body
    final bodyPaint = Paint()..color = RetroColors.pedestalBody;
    canvas.drawRect(Rect.fromLTWH(2, 2, w - 4, h - 4), bodyPaint);

    // Top beveled stone slab
    final topPaint = Paint()..color = RetroColors.pedestalTop;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, 8.0), topPaint);

    // Highlight line on top edge
    final highlightPaint = Paint()..color = RetroColors.stoneBlockHighlight;
    canvas.drawLine(const Offset(0, 1.0), Offset(w, 1.0), highlightPaint);

    // Masonry stone brick seams
    final seamPaint = Paint()
      ..color = RetroColors.pedestalBorder
      ..strokeWidth = 2.0;

    // Horizontal split
    canvas.drawLine(const Offset(2, 18.0), Offset(w - 2, 18.0), seamPaint);

    // Vertical joints (staggered bricks) - evenly spaced at 70px intervals
    const jointSpacing = 70.0;
    for (double x = 45.0; x < w; x += jointSpacing) {
      canvas.drawLine(Offset(x, 8.0), Offset(x, 18.0), seamPaint);
    }
    // Lower row staggered joints (offset by half spacing)
    for (double x = 80.0; x < w; x += jointSpacing) {
      canvas.drawLine(Offset(x, 18.0), Offset(x, h - 2), seamPaint);
    }
  }
}