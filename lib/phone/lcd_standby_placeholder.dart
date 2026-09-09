import 'package:flutter/widgets.dart';

import '../theme/colors.dart';
import '../theme/dimensions.dart';
import 'lcd_status_bar.dart';
import 'pixel_divider.dart';

/// Standby / Preview screen displayed inside the LCD during Stage 1.
class LcdStandbyPlaceholder extends StatelessWidget {
  const LcdStandbyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Column(
        children: [
          // Tiny Status Bar (Section 13)
          const LcdStatusBar(),
          const Spacer(),

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
          const SizedBox(height: 4.0),
          const PixelDivider(),
          const SizedBox(height: 6.0),
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
          const Spacer(),

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
