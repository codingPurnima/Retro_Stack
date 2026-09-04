import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';

/// Soft keys row widget for the feature phone shell (Section 17).
///
/// Features left and right action keys with tactile press feedback.
class SoftKeys extends StatelessWidget {
  /// Label for the left soft key (default 'MENU').
  final String leftLabel;

  /// Label for the right soft key (default 'SELECT').
  final String rightLabel;

  /// Callback when a soft key is tapped.
  final ValueChanged<String>? onKeyPressed;

  const SoftKeys({
    super.key,
    this.leftLabel = 'MENU',
    this.rightLabel = 'SELECT',
    this.onKeyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: RetroDimensions.softKeysRowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SoftKeyButton(
            label: leftLabel,
            onTap: () => onKeyPressed?.call(leftLabel),
          ),
          _SoftKeyButton(
            label: rightLabel,
            onTap: () => onKeyPressed?.call(rightLabel),
          ),
        ],
      ),
    );
  }
}

class _SoftKeyButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _SoftKeyButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_SoftKeyButton> createState() => _SoftKeyButtonState();
}

class _SoftKeyButtonState extends State<_SoftKeyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final topOffset = _isPressed ? 1.5 : 0.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: RetroDimensions.softKeyWidth,
        height: RetroDimensions.softKeyHeight + 2.0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Dark base shadow
            Positioned(
              top: 2.0,
              left: 0.0,
              right: 0.0,
              height: RetroDimensions.softKeyHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: RetroColors.keyShadow,
                  borderRadius: BorderRadius.circular(
                    RetroDimensions.softKeyCornerRadius,
                  ),
                ),
              ),
            ),
            // Moving button capsule
            AnimatedPositioned(
              duration: RetroDimensions.keyPressDuration,
              curve: Curves.easeOutQuad,
              top: topOffset,
              left: 0.0,
              right: 0.0,
              height: RetroDimensions.softKeyHeight,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    RetroDimensions.softKeyCornerRadius,
                  ),
                  border: Border.all(
                    color: _isPressed
                        ? RetroColors.keyBorder
                        : RetroColors.keyHighlight,
                    width: 0.6,
                  ),
                  color: _isPressed
                      ? RetroColors.keyPressedSurface
                      : RetroColors.softKeySurface,
                  boxShadow: [
                    BoxShadow(
                      color: RetroColors.keyShadow,
                      offset: Offset(0.0, _isPressed ? 0.5 : 1.5),
                      blurRadius: _isPressed ? 0.5 : 1.5,
                    ),
                  ],
                ),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: RetroDimensions.softKeyFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: RetroColors.softKeyText,
                    height: 1.0,
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
