import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import 'lcd_scanline_painter.dart';
import 'lcd_standby_placeholder.dart';

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
            child ?? const LcdStandbyPlaceholder(),

            // Subtle LCD Scanline overlay
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: LcdScanlinePainter()),
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