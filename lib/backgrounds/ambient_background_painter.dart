import 'package:retro_stack_frontend/backgrounds/pixel_background_elements.dart';

import '../theme/colors.dart';
import 'package:flutter/widgets.dart';


class AmbientBackdropPainter extends CustomPainter {
  const AmbientBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Atmospheric sky gradient (top to horizon)
    final horizonY = h * 0.86;
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          RetroColors.ambientSkyTop,
          RetroColors.ambientSkyBottom,
        ],
        stops: [0.0, 0.9],
      ).createShader(Rect.fromLTWH(0, 0, w, horizonY));

    canvas.drawRect(Rect.fromLTWH(0, 0, w, horizonY), skyPaint);

    // 2. Table / ground plane beneath horizon
    final groundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          RetroColors.ambientGround,
          RetroColors.ambientGround.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromLTWH(0, horizonY, w, h - horizonY));

    canvas.drawRect(Rect.fromLTWH(0, horizonY, w, h - horizonY), groundPaint);

    // Subtle horizon seam line
    final horizonLine = Paint()
      ..color = const Color(0x22FFFFFF)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, horizonY), Offset(w, horizonY), horizonLine);

    // 3. Faint Distant Pixel-Art Towers (Layer 1 - Far)
    _drawFarTowers(canvas, w, horizonY);

    // 4. Distant Pixel-Art Towers (Layer 2 - Near)
    _drawNearTowers(canvas, w, horizonY);

    // 5. Gentle Pixel Clouds in upper sky
    _drawPixelClouds(canvas, w, horizonY);

    // 6. Soft ground shadow directly beneath the phone center
    _drawPhoneGroundShadow(canvas, w, horizonY);
  }

  void _drawFarTowers(Canvas canvas, double w, double groundY) {
    final paint = Paint()
      ..color = RetroColors.ambientTowerFar
      ..style = PaintingStyle.fill;

    // Far Left Citadel Silhouette
    final leftX = w * 0.04;
    drawPixelTower(
      canvas,
      baseX: leftX,
      groundY: groundY,
      width: 44.0,
      height: 220.0,
      spireHeight: 45.0,
      paint: paint,
    );

    // Far Right Fortress Silhouette
    final rightX = w * 0.88;
    drawPixelTower(
      canvas,
      baseX: rightX,
      groundY: groundY,
      width: 50.0,
      height: 250.0,
      spireHeight: 55.0,
      paint: paint,
    );
  }

  void _drawNearTowers(Canvas canvas, double w, double groundY) {
    final paint = Paint()
      ..color = RetroColors.ambientTowerNear
      ..style = PaintingStyle.fill;

    // Near Left Tower
    final leftX = w * 0.11;
    drawPixelTower(
      canvas,
      baseX: leftX,
      groundY: groundY,
      width: 34.0,
      height: 170.0,
      spireHeight: 30.0,
      paint: paint,
    );

    // Near Right Tower
    final rightX = w * 0.81;
    drawPixelTower(
      canvas,
      baseX: rightX,
      groundY: groundY,
      width: 38.0,
      height: 190.0,
      spireHeight: 36.0,
      paint: paint,
    );
  }

  void _drawPixelClouds(Canvas canvas, double w, double groundY) {
    final paint = Paint()
      ..color = RetroColors.ambientCloud
      ..style = PaintingStyle.fill;

    // Cloud cluster 1 (Upper Left)
    drawCloud(canvas, x: w * 0.08, y: groundY * 0.16, scale: 1.0, paint: paint);

    // Cloud cluster 2 (Mid Left)
    drawCloud(canvas, x: w * 0.02, y: groundY * 0.38, scale: 0.75, paint: paint);

    // Cloud cluster 3 (Upper Right)
    drawCloud(canvas, x: w * 0.76, y: groundY * 0.20, scale: 1.1, paint: paint);

    // Cloud cluster 4 (Mid Right)
    drawCloud(canvas, x: w * 0.84, y: groundY * 0.44, scale: 0.7, paint: paint);
  }

  void _drawPhoneGroundShadow(Canvas canvas, double w, double groundY) {
    // Radial soft shadow grounded under the phone
    final shadowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          RetroColors.ambientGroundShadow,
          const Color(0x00000000),
        ],
      ).createShader(
        Rect.fromCenter(
          center: Offset(w * 0.5, groundY + 18.0),
          width: 240.0,
          height: 38.0,
        ),
      );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, groundY + 18.0),
        width: 240.0,
        height: 38.0,
      ),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}