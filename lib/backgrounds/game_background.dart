import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/backgrounds/pixel_background_elements.dart';
import '../theme/colors.dart';
import '../game/my_game.dart';

/// Game background component rendering the in-game sky, distant pixel-art towers,
/// clouds, crane girder mechanism, and retro status prompts.
class GameBackgroundComponent extends PositionComponent
    with HasGameReference<MyGame> {
  GameBackgroundComponent()
    : super(
        size: Vector2(MyGame.virtualWidth, MyGame.virtualHeight),
        position: Vector2.zero(),
      );

  @override
  void render(Canvas canvas) {
    final double w = size.x;
    final double h = size.y;

    // 1. Sky Gradient
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [RetroColors.gameSkyTop, RetroColors.gameSkyBottom],
        stops: [0.0, 0.85],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), skyPaint);

    // 2. Distant Pixel-Art Towers (Layer 1 - Far Spires)
    _drawFarTowers(canvas, w, h);

    // 3. Mid-Distance Pixel-Art Towers (Layer 2 - Castles with battlements)
    _drawNearTowers(canvas, w, h);

    // 4. In-Game Pixel Clouds
    _drawPixelClouds(canvas, w, h);

    // 5. Top Status Bar (Signal bars, Battery)
    _drawStatusBarDecorations(canvas, w);

    // 6. Bottom Prompt Banner ('— PRESS OK TO DROP —')
    _drawBottomPrompt(canvas, w, h);
  }

  void _drawFarTowers(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..color = RetroColors.gameTowerFar.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    // Left far slender spire
    drawPixelSpire(
      canvas,
      baseX: w * 0.18,
      groundY: h * 0.85,
      width: 48.0,
      height: 280.0,
      spireHeight: 50.0,
      paint: paint,
    );

    // Right far tower
    drawPixelSpire(
      canvas,
      baseX: w * 0.82,
      groundY: h * 0.85,
      width: 54.0,
      height: 310.0,
      spireHeight: 60.0,
      paint: paint,
    );
  }

  void _drawNearTowers(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..color = RetroColors.gameTowerNear.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    // Left castle turret with battlements
    drawCastleTurret(
      canvas,
      baseX: w * 0.12,
      groundY: h * 0.88,
      width: 42.0,
      height: 210.0,
      paint: paint,
      slitColor: RetroColors.stoneBlockBorder.withValues(alpha: 0.3),
    );

    // Right castle turret
    drawCastleTurret(
      canvas,
      baseX: w * 0.88,
      groundY: h * 0.90,
      width: 46.0,
      height: 230.0,
      paint: paint,
      slitColor: RetroColors.stoneBlockBorder.withValues(alpha: 0.3)
    );
  }

  void _drawPixelClouds(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..color = RetroColors.gameCloud
      ..style = PaintingStyle.fill;

    // Cluster 1 (Left mid-sky)
    drawCloud(canvas, x: w * 0.05, y: h * 0.28, scale: 1.2, paint: paint);

    // Cluster 2 (Right mid-sky)
    drawCloud(canvas, x: w * 0.70, y: h * 0.32, scale: 1.3, paint: paint);

    // Cluster 3 (Far right low)
    drawCloud(canvas, x: w * 0.65, y: h * 0.52, scale: 0.9, paint: paint);
  }

  void _drawStatusBarDecorations(Canvas canvas, double w) {
    // 1. Signal strength bars (top left)
    final barPaint = Paint()
      ..color = RetroColors.hudText
      ..style = PaintingStyle.fill;

    const startX = 20.0;
    const baseY = 32.0;
    for (int i = 0; i < 4; i++) {
      final barHeight = 4.0 + i * 4.5;
      canvas.drawRect(
        Rect.fromLTWH(startX + i * 4.5, baseY - barHeight, 3.0, barHeight),
        barPaint,
      );
    }

    // 2. Battery icon (top right)
    final batteryX = w - 44.0;
    const batteryY = 22.0;
    final outlinePaint = Paint()
      ..color = RetroColors.hudText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawRect(
      Rect.fromLTWH(batteryX, batteryY, 22.0, 11.0),
      outlinePaint,
    );
    // Battery terminal nipple
    canvas.drawRect(
      Rect.fromLTWH(batteryX + 22.0, batteryY + 3.0, 2.5, 5.0),
      barPaint,
    );
    // Battery fill bars
    canvas.drawRect(
      Rect.fromLTWH(batteryX + 2.5, batteryY + 2.5, 5.0, 6.0),
      barPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(batteryX + 9.0, batteryY + 2.5, 5.0, 6.0),
      barPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(batteryX + 15.5, batteryY + 2.5, 4.0, 6.0),
      barPaint,
    );
  }

  void _drawBottomPrompt(Canvas canvas, double w, double h) {
    // Bottom banner prompt: '—  PRESS 5 TO DROP  —'
    const bannerW = 280.0;
    const bannerH = 26.0;
    final bannerX = (w - bannerW) / 2;
    final bannerY = h - 52.0;

    final bgPaint = Paint()..color = RetroColors.hudPromptBg;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bannerX, bannerY, bannerW, bannerH),
        const Radius.circular(3.0),
      ),
      bgPaint,
    );

    final borderPaint = Paint()
      ..color = RetroColors.hudPromptText.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bannerX, bannerY, bannerW, bannerH),
        const Radius.circular(3.0),
      ),
      borderPaint,
    );

    // Draw text with TextPainter
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '—   PRESS OK TO DROP   —',
        style: TextStyle(
          color: RetroColors.hudPromptText,
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        bannerX + (bannerW - textPainter.width) / 2,
        bannerY + (bannerH - textPainter.height) / 2,
      ),
    );
  }
}