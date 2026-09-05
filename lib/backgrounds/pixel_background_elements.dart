import 'dart:ui';

void drawCloud(
  Canvas canvas, {
  required double x,
  required double y,
  required double scale,
  required Paint paint,
}) {
  final p = 5.0 * scale;
  final blocks = [
    const [0, 0, 9, 3],
    const [-1, 2, 6, 2],
    const [-2, 4, 3, 2],
    const [1, -2, 12, 3],
    const [2, 1, 8, 2],
  ];

  for (final b in blocks) {
    canvas.drawRect(
      Rect.fromLTWH(x + b[1] * p, y + b[0] * p, b[2] * p, b[3] * p),
      paint,
    );
  }
}

void drawPixelTower(
  Canvas canvas, {
  required double baseX,
  required double groundY,
  required double width,
  required double height,
  required double spireHeight,
  required Paint paint,
}) {
  // Stepped pixel-art tower structure
  final halfW = width / 2;
  final topY = groundY - height;

  // Base body
  canvas.drawRect(
    Rect.fromLTRB(baseX - halfW, topY + height * 0.45, baseX + halfW, groundY),
    paint,
  );

  // Mid tower section (narrower)
  final midW = halfW * 0.78;
  canvas.drawRect(
    Rect.fromLTRB(
      baseX - midW,
      topY + height * 0.18,
      baseX + midW,
      topY + height * 0.45,
    ),
    paint,
  );

  // Upper balcony / crenelation ledge
  final ledgeW = halfW * 0.95;
  canvas.drawRect(
    Rect.fromLTRB(
      baseX - ledgeW,
      topY + height * 0.12,
      baseX + ledgeW,
      topY + height * 0.18,
    ),
    paint,
  );

  // Tower crown
  final crownW = halfW * 0.6;
  canvas.drawRect(
    Rect.fromLTRB(baseX - crownW, topY, baseX + crownW, topY + height * 0.12),
    paint,
  );

  // Spire / flagpole needle
  canvas.drawRect(
    Rect.fromLTWH(baseX - 1.5, topY - spireHeight, 3.0, spireHeight),
    paint,
  );
  // Spire finial
  canvas.drawRect(
    Rect.fromLTWH(baseX - 3.0, topY - spireHeight - 4.0, 6.0, 4.0),
    paint,
  );
}

void drawPixelSpire(
  Canvas canvas, {
  required double baseX,
  required double groundY,
  required double width,
  required double height,
  required double spireHeight,
  required Paint paint,
}) {
  final halfW = width / 2;
  final topY = groundY - height;

  // Main tower column
  canvas.drawRect(
    Rect.fromLTRB(
      baseX - halfW * 0.8,
      topY + height * 0.35,
      baseX + halfW * 0.8,
      groundY,
    ),
    paint,
  );
  // Upper tier
  canvas.drawRect(
    Rect.fromLTRB(
      baseX - halfW,
      topY + height * 0.15,
      baseX + halfW,
      topY + height * 0.35,
    ),
    paint,
  );
  // Crown
  canvas.drawRect(
    Rect.fromLTRB(
      baseX - halfW * 0.7,
      topY,
      baseX + halfW * 0.7,
      topY + height * 0.15,
    ),
    paint,
  );
  // Spire needle
  canvas.drawRect(
    Rect.fromLTWH(baseX - 2.0, topY - spireHeight, 4.0, spireHeight),
    paint,
  );
  // Spire tip flag/finial
  canvas.drawRect(
    Rect.fromLTWH(baseX - 4.0, topY - spireHeight - 6.0, 8.0, 6.0),
    paint,
  );
}

void drawCastleTurret(
  Canvas canvas, {
  required double baseX,
  required double groundY,
  required double width,
  required double height,
  required Paint paint,
  required Color slitColor,
}) {
  final halfW = width / 2;
  final topY = groundY - height;

  // Main body
  canvas.drawRect(
    Rect.fromLTRB(baseX - halfW, topY + 20.0, baseX + halfW, groundY),
    paint,
  );

  // Overhanging battlement ledge
  final ledgeW = halfW + 4.0;
  canvas.drawRect(
    Rect.fromLTRB(baseX - ledgeW, topY + 8.0, baseX + ledgeW, topY + 20.0),
    paint,
  );

  // Crenelations (notches on top)
  final step = (ledgeW * 2) / 5;
  for (int i = 0; i < 5; i += 2) {
    canvas.drawRect(
      Rect.fromLTWH(baseX - ledgeW + i * step, topY, step, 8.0),
      paint,
    );
  }

  // Window slit cutouts (darker)
  final slitPaint = Paint()..color = slitColor;
  canvas.drawRect(
    Rect.fromLTWH(baseX - 3.0, topY + 45.0, 6.0, 16.0),
    slitPaint,
  );
  canvas.drawRect(
    Rect.fromLTWH(baseX - 3.0, topY + 85.0, 6.0, 16.0),
    slitPaint,
  );
}
