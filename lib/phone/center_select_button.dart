import 'package:flutter/widgets.dart';

import '../theme/colors.dart';
import '../theme/dimensions.dart';

/// Center selection button for the D-pad.
class CenterSelectButton extends StatefulWidget {
  final bool isPressed;
  final bool isHighlighted;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;

  const CenterSelectButton({
    super.key,
    required this.isPressed,
    this.isHighlighted = false,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
  });

  @override
  State<CenterSelectButton> createState() => _CenterSelectButtonState();
}

class _CenterSelectButtonState extends State<CenterSelectButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.isHighlighted) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant CenterSelectButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted != oldWidget.isHighlighted) {
      if (widget.isHighlighted) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topOffset = widget.isPressed ? 1.5 : 0.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => widget.onTapDown(),
      onTapUp: (_) => widget.onTapUp(),
      onTapCancel: widget.onTapCancel,
      child: SizedBox(
        width: RetroDimensions.navCenterButtonSize,
        height: RetroDimensions.navCenterButtonSize + 2.0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shadow
            Positioned(
              top: 2.0,
              child: Container(
                width: RetroDimensions.navCenterButtonSize,
                height: RetroDimensions.navCenterButtonSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: RetroColors.keyShadow,
                ),
              ),
            ),
            // Button surface
            AnimatedPositioned(
              duration: RetroDimensions.keyPressDuration,
              curve: Curves.easeOutQuad,
              top: topOffset,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, _) {
                  final Color borderColor;
                  if (widget.isPressed) {
                    borderColor = RetroColors.chromeShadow;
                  } else if (widget.isHighlighted) {
                    borderColor = Color.lerp(
                      RetroColors.chromeHighlight,
                      RetroColors.buttonIconRed,
                      _pulseAnimation.value,
                    )!;
                  } else {
                    borderColor = RetroColors.chromeHighlight;
                  }

                  return Container(
                    width: RetroDimensions.navCenterButtonSize,
                    height: RetroDimensions.navCenterButtonSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(
                        color: borderColor,
                        width: widget.isHighlighted ? 1.4 : 1.0,
                      ),
                      gradient: RadialGradient(
                        center: const Alignment(-0.2, -0.3),
                        radius: 0.8,
                        colors: widget.isPressed
                            ? [
                                RetroColors.keyPressedSurface,
                                RetroColors.keyShadow,
                              ]
                            : [
                                RetroColors.phoneBodyLight,
                                RetroColors.phoneBodyMid,
                                RetroColors.phoneBodyDark,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.isHighlighted
                              ? RetroColors.buttonIconRed.withValues(
                                  alpha: 0.3 * _pulseAnimation.value,
                                )
                              : RetroColors.keyShadow,
                          offset: Offset(0.0, widget.isPressed ? 0.5 : 1.8),
                          blurRadius: widget.isHighlighted
                              ? 3.0 * _pulseAnimation.value + 1.0
                              : (widget.isPressed ? 0.5 : 2.0),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 8.0,
                          color: RetroColors.navArrowColor,
                          height: 1.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
