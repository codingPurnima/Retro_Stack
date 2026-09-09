import 'package:flutter/widgets.dart';

import '../../theme/colors.dart';
import '../../theme/dimensions.dart';
import 'phone_faceplate.dart';
import 'phone_chin.dart';

/// The outer feature phone shell widget (Sections 2, 4, 5, 31).
///
/// Houses the physical molded phone body, speaker, LCD bezel frame, and keypad.
/// Uses the fixed logical reference coordinate system (300 × 625) and scales
/// uniformly and responsively within any parent constraints.
class PhoneShell extends StatelessWidget {
  /// Optional child displayed inside the LCD screen (e.g. Flame game in Stage 5).
  final Widget? lcdChild;

  /// Optional callback invoked when any key on the phone keypad is pressed.
  final ValueChanged<String>? onKeyPressed;

  /// Whether the center OK button should show a subtle instructional emphasis.
  final bool highlightOk;

  const PhoneShell({
    super.key,
    this.lcdChild,
    this.onKeyPressed,
    this.highlightOk = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final bool isBounded =
            availableWidth.isFinite && availableHeight.isFinite;

        final double targetWidth;
        final double targetHeight;

        if (isBounded) {
          // Scale the complete phone frame to occupy most of the available vertical height
          // while maintaining reasonable top/bottom spacing.
          final maxTargetHeight =
              availableHeight * RetroDimensions.phoneScaleFactor;
          final maxTargetWidth =
              availableWidth * RetroDimensions.phoneScaleFactor;

          double h = maxTargetHeight;
          double w = h * RetroDimensions.aspectRatio;

          // Proportional width clamp: ensure the phone preserves aspect ratio without horizontal overflow
          if (w > maxTargetWidth) {
            w = maxTargetWidth;
            h = w / RetroDimensions.aspectRatio;
          }

          targetWidth = w;
          targetHeight = h;
        } else {
          targetWidth = RetroDimensions.designWidth;
          targetHeight = RetroDimensions.designHeight;
        }

        return Center(
          child: SizedBox(
            width: targetWidth,
            height: targetHeight,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(
                width: RetroDimensions.designWidth,
                height: RetroDimensions.designHeight,
                child: Center(
                  child: Container(
              width: RetroDimensions.phoneBodyWidth,
              height: RetroDimensions.phoneBodyHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  RetroDimensions.phoneCornerRadius,
                ),
                border: Border.all(
                  color: RetroColors.chromeHighlight,
                  width: RetroDimensions.phoneChromeRimWidth,
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    RetroColors.phoneBodyLight,
                    RetroColors.phoneBodyMid,
                    RetroColors.phoneBodyDark,
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: RetroColors.phoneShadow,
                    offset: Offset(0.0, RetroDimensions.phoneShadowOffsetY),
                    blurRadius: RetroDimensions.phoneShadowBlur,
                    spreadRadius: 3.0,
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  // Outer Chrome specular edge highlight
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          RetroDimensions.phoneCornerRadius - 1.0,
                        ),
                        border: Border.all(
                          color: const Color(0x33FFFFFF),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),

                  // Top-Right Outer Chrome Specular Flare (matching inspiration image)
                  Positioned(
                    top: 1.0,
                    right: 25.0,
                    child: Container(
                      width: 85.0,
                      height: 3.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x00FFFFFF),
                            Color(0xFAFFFFFF),
                            Color(0x00FFFFFF),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Faceplate (speaker, LCD, controls)
                  PhoneFaceplate(
                    lcdChild: lcdChild,
                    onKeyPressed: onKeyPressed,
                    highlightOk: highlightOk,
                  ),

                  // Exposed Slider Chin details at the bottom
                  PhoneChin(),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
},
);
  }
}
