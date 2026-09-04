import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';

/// Reusable LCD Screen Shell with physical bezel and recessed display surface (Section 8).
///
/// Accepts an optional [child] widget. If null, renders a nostalgic monochrome
/// green LCD placeholder screen suitable for Stage 1.
class LcdScreen extends StatelessWidget {
  /// The content displayed inside the LCD display.
  final Widget? child;

  const LcdScreen({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: RetroDimensions.lcdFrameWidth,
      height: RetroDimensions.lcdFrameHeight,
      decoration: BoxDecoration(
        color: RetroColors.bezelOuter,
        borderRadius: BorderRadius.circular(
          RetroDimensions.lcdBezelCornerRadius,
        ),
        border: Border.all(color: RetroColors.bezelHighlight, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: RetroColors.phoneShadow,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(RetroDimensions.lcdBezelPadding),
      child: Container(
        decoration: BoxDecoration(
          color: RetroColors.lcdLight,
          borderRadius: BorderRadius.circular(
            RetroDimensions.lcdInnerCornerRadius,
          ),
          border: Border.all(
            color: RetroColors.bezelInner,
            width: RetroDimensions.lcdInnerBorderWidth,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // LCD Content or Placeholder (muted palette)
            child ?? const _LcdStandbyPlaceholder(),

            // Subtle LCD Scanline overlay
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _LcdScanlinePainter()),
              ),
            ),

            // Subtle Glass Glare / Lens Reflection (Section 12)
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              height: 40.0,
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [RetroColors.lcdGlare, Color(0x00FFFFFF)],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standby / Preview screen displayed inside the LCD during Stage 1.
class _LcdStandbyPlaceholder extends StatelessWidget {
  const _LcdStandbyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Column(
        children: [
          // Tiny Status Bar (Section 13)
          _LcdStatusBar(),
          Spacer(),

          // Centered Retro Stack Standby Title
          Text(
            'RETRO STACK',
            style: TextStyle(
              fontSize: RetroDimensions.lcdPlaceholderTitleSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: RetroColors.lcdDarkest,
              height: 1.0,
            ),
          ),
          SizedBox(height: 4.0),
          _PixelDivider(),
          SizedBox(height: 6.0),
          Text(
            'STAGE 1 — SHELL READY',
            style: TextStyle(
              fontSize: RetroDimensions.lcdPlaceholderSubSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: RetroColors.lcdDark,
              height: 1.0,
            ),
          ),
          Spacer(),

          // Soft key hints on LCD bottom edge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MENU',
                style: TextStyle(
                  fontSize: RetroDimensions.lcdStatusBarFontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: RetroColors.lcdDark,
                ),
              ),
              Text(
                'SELECT',
                style: TextStyle(
                  fontSize: RetroDimensions.lcdStatusBarFontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: RetroColors.lcdDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Simulated feature phone status bar showing signal, clock, and battery.
class _LcdStatusBar extends StatelessWidget {
  const _LcdStatusBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Signal Indicator (3 bars)
        Text(
          '▮▮▮',
          style: TextStyle(
            fontSize: RetroDimensions.lcdStatusBarFontSize,
            color: RetroColors.lcdDarkest,
            letterSpacing: 1.0,
            height: 1.0,
          ),
        ),
        // Clock
        Text(
          '12:00',
          style: TextStyle(
            fontSize: RetroDimensions.lcdStatusBarFontSize,
            fontWeight: FontWeight.bold,
            color: RetroColors.lcdDarkest,
            letterSpacing: 0.5,
            height: 1.0,
          ),
        ),
        // Battery Indicator
        Text(
          '[■■■]',
          style: TextStyle(
            fontSize: RetroDimensions.lcdStatusBarFontSize,
            fontWeight: FontWeight.bold,
            color: RetroColors.lcdDarkest,
            letterSpacing: 0.5,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

/// Subtle dotted pixel divider.
class _PixelDivider extends StatelessWidget {
  const _PixelDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 120.0, height: 2.0, color: RetroColors.lcdDark);
  }
}

/// Custom painter for subtle horizontal scanlines (Section 11).
class _LcdScanlinePainter extends CustomPainter {
  const _LcdScanlinePainter();

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
