import 'package:flutter/widgets.dart';

import '../theme/colors.dart';
import '../theme/dimensions.dart';

/// Simulated feature phone status bar showing signal, clock, and battery.
class LcdStatusBar extends StatelessWidget {
  const LcdStatusBar({super.key});

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
