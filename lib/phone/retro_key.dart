import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';

/// Reusable physical keypad key widget with tactile press animation (Sections 20, 21).
///
/// Avoids Material buttons in favor of custom tactile molded plastic styling.
class RetroKey extends StatefulWidget {
  /// Primary label shown on the key (e.g., '1', '5', '*', '#').
  final String label;

  /// Optional sub-label shown below the number (e.g., 'JKL', 'ABC', '+').
  final String? subLabel;

  /// Width of the key.
  final double width;

  /// Height of the key.
  final double height;

  /// Callback invoked when the key press is released.
  final ValueChanged<String>? onKeyPressed;

  const RetroKey({
    super.key,
    required this.label,
    this.subLabel,
    this.width = RetroDimensions.keyWidth,
    this.height = RetroDimensions.keyHeight,
    this.onKeyPressed,
  });

  @override
  State<RetroKey> createState() => _RetroKeyState();
}

class _RetroKeyState extends State<RetroKey> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (!_isPressed) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      widget.onKeyPressed?.call(widget.label);
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topOffset = _isPressed ? RetroDimensions.keyPressedTranslation : 0.0;
    final currentShadowDepth = _isPressed
        ? 0.5
        : RetroDimensions.keyRaisedDepth;

    return Padding(
      padding: const EdgeInsets.all(RetroDimensions.keyHitPadding),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: SizedBox(
          width: widget.width,
          height: widget.height + RetroDimensions.keyRaisedDepth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bottom 3D depth / bevel base
              Positioned(
                top: RetroDimensions.keyRaisedDepth,
                left: 0.0,
                right: 0.0,
                height: widget.height,
                child: Container(
                  decoration: BoxDecoration(
                    color: RetroColors.keyShadow,
                    borderRadius: BorderRadius.circular(
                      RetroDimensions.keyCornerRadius,
                    ),
                  ),
                ),
              ),
              // Moving key surface with tactile downward translation
              AnimatedPositioned(
                duration: RetroDimensions.keyPressDuration,
                curve: Curves.easeOutQuad,
                top: topOffset,
                left: 0.0,
                right: 0.0,
                height: widget.height,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      RetroDimensions.keyCornerRadius,
                    ),
                    border: Border.all(
                      color: _isPressed
                          ? RetroColors.keyBorder
                          : RetroColors.keyHighlight,
                      width: 0.8,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _isPressed
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
                        blurRadius: _isPressed ? 1.0 : 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: RetroDimensions.keyNumberFontSize,
                          fontWeight: FontWeight.bold,
                          color: _isPressed
                              ? RetroColors.keyTextPressed
                              : RetroColors.keyText,
                          height: 1.0,
                        ),
                      ),
                      if (widget.subLabel != null &&
                          widget.subLabel!.isNotEmpty) ...[
                        const SizedBox(height: 1.5),
                        Text(
                          widget.subLabel!,
                          style: TextStyle(
                            fontSize: RetroDimensions.keySubLabelFontSize,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            color: _isPressed
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
        ),
      ),
    );
  }
}
