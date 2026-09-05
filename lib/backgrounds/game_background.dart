import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/backgrounds/pixel_background_elements.dart';
import '../theme/colors.dart';
import '../game/my_game.dart';

/// Game background component rendering the in-game sky, distant pixel-art towers,
/// clouds, crane girder mechanism, and retro status prompts.
class GameBackgroundComponent extends PositionComponent
    with HasGameReference<MyGame> {
  double _pulseTimer = 0.0;

  GameBackgroundComponent()
    : super(
        size: Vector2(MyGame.virtualWidth, MyGame.virtualHeight),
        position: Vector2.zero(),
      );

  @override
  void update(double dt) {
    super.update(dt);
    _pulseTimer += dt;
  }

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

    // 6. Bottom Prompt Banner (Visible only until first actual drop in active session)
    if (game.playState == GamePlayState.playing && !game.hasPerformedFirstDrop) {
      _drawBottomPrompt(canvas, w, h);
    }
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
    // High-contrast instructional hint panel: [ OK ] PRESS TO DROP
    const bannerW = 250.0;
    const bannerH = 32.0;
    final bannerX = (w - bannerW) / 2;
    final bannerY = h - 58.0;

    final double pulse = 0.5 + 0.5 * sin(_pulseTimer * 3.5);

    // Drop shadow
    final shadowPaint = Paint()..color = const Color(0x99000000);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bannerX, bannerY + 2.0, bannerW, bannerH),
        const Radius.circular(4.0),
      ),
      shadowPaint,
    );

    // High-contrast deep ink background
    final bgPaint = Paint()..color = const Color(0xF210151C);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bannerX, bannerY, bannerW, bannerH),
        const Radius.circular(4.0),
      ),
      bgPaint,
    );

    // Subtle pulsing retro border
    final borderColor = Color.lerp(
      const Color(0xFF6C8C9E),
      const Color(0xFFFFFFFF),
      pulse * 0.8,
    )!;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bannerX, bannerY, bannerW, bannerH),
        const Radius.circular(4.0),
      ),
      borderPaint,
    );

    // Mini representation of physical center OK button
    const miniBtnW = 34.0;
    const miniBtnH = 20.0;
    final miniBtnX = bannerX + 10.0;
    final miniBtnY = bannerY + (bannerH - miniBtnH) / 2;

    final miniBtnPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFEAF2F8),
          Color(0xFFADC2D1),
          Color(0xFF6B879B),
        ],
      ).createShader(Rect.fromLTWH(miniBtnX, miniBtnY, miniBtnW, miniBtnH));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(miniBtnX, miniBtnY, miniBtnW, miniBtnH),
        const Radius.circular(4.0),
      ),
      miniBtnPaint,
    );

    final miniBtnBorder = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(miniBtnX, miniBtnY, miniBtnW, miniBtnH),
        const Radius.circular(4.0),
      ),
      miniBtnBorder,
    );

    // Mini OK button label
    final okTextPainter = TextPainter(
      text: const TextSpan(
        text: 'OK',
        style: TextStyle(
          color: Color(0xFF16181A),
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
          fontFamily: 'monospace',
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    okTextPainter.paint(
      canvas,
      Offset(
        miniBtnX + (miniBtnW - okTextPainter.width) / 2,
        miniBtnY + (miniBtnH - okTextPainter.height) / 2,
      ),
    );

    // Instructional hint text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'PRESS TO DROP',
        style: TextStyle(
          color: Color(0xFFEAF2F8),
          fontSize: 12.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.8,
          fontFamily: 'monospace',
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final remainingW = bannerW - (miniBtnW + 16.0);
    textPainter.paint(
      canvas,
      Offset(
        bannerX + miniBtnW + 16.0 + (remainingW - textPainter.width) / 2 - 4.0,
        bannerY + (bannerH - textPainter.height) / 2,
      ),
    );
  }
}