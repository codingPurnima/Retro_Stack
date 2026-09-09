import 'package:flutter/widgets.dart';

import '../theme/colors.dart';
import '../theme/dimensions.dart';

/// Visual surface for a physical retro keypad key.
class RetroKeySurface extends StatelessWidget {
  final bool isPressed;
  final double width;
  final double height;
  final String label;
  final String? subLabel;

  const RetroKeySurface({
    super.key,
    required this.isPressed,
    required this.width,
    required this.height,
    required this.label,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    final topOffset = isPressed ? RetroDimensions.keyPressedTranslation : 0.0;
    final currentShadowDepth = isPressed ? 0.5 : RetroDimensions.keyRaisedDepth;

    return SizedBox(
      width: width,
      height: height + RetroDimensions.keyRaisedDepth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: RetroDimensions.keyRaisedDepth,
            left: 0.0,
            right: 0.0,
            height: height,
            child: Container(
              decoration: BoxDecoration(
                color: RetroColors.keyShadow,
                borderRadius: BorderRadius.circular(
                  RetroDimensions.keyCornerRadius,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: RetroDimensions.keyPressDuration,
            curve: Curves.easeOutQuad,
            top: topOffset,
            left: 0.0,
            right: 0.0,
            height: height,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  RetroDimensions.keyCornerRadius,
                ),
                border: Border.all(
                  color: isPressed
                      ? RetroColors.keyBorder
                      : RetroColors.keyHighlight,
                  width: 0.8,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isPressed
                      ? [
                          RetroColors.keyPressedSurface,
                          RetroColors.keyPressedSurface,
                        ]
                      : [
                          RetroColors.keySurfaceTop,
                          RetroColors.keySurfaceBottom,
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: RetroColors.keyShadow,
                    offset: Offset(0.0, currentShadowDepth),
                    blurRadius: isPressed ? 1.0 : 2.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: RetroDimensions.keyNumberFontSize,
                      fontWeight: FontWeight.bold,
                      color: isPressed
                          ? RetroColors.keyTextPressed
                          : RetroColors.keyText,
                      height: 1.0,
                    ),
                  ),
                  if (subLabel != null && subLabel!.isNotEmpty) ...[
                    const SizedBox(height: 1.5),
                    Text(
                      subLabel!,
                      style: TextStyle(
                        fontSize: RetroDimensions.keySubLabelFontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                        color: isPressed
                            ? RetroColors.keyTextPressed
                            : RetroColors.keySubText,
                        height: 1.0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
