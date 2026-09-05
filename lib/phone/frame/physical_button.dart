import 'package:flutter/material.dart';
import 'package:retro_stack_frontend/theme/colors.dart';
import 'package:retro_stack_frontend/theme/dimensions.dart';

class PhysicalButton extends StatefulWidget {
  final String label;
  final Widget? icon;
  final String? symbol;
  final Color? accent;
  final double? symbolFontSize;
  final VoidCallback? onTap;

  const PhysicalButton({
    super.key,
    required this.label,
    this.icon,
    this.symbol,
    this.accent,
    this.symbolFontSize,
    this.onTap,
  });

  @override
  State<PhysicalButton> createState() => PhysicalButtonState();
}

class PhysicalButtonState extends State<PhysicalButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final topOffset = _isPressed ? 1.5 : 0.0;
    const double btnWidth = 44.0;
    const double btnHeight = 20.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: btnWidth,
        height: btnHeight + 4.0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 2.0,
              left: 0.0,
              right: 0.0,
              height: btnHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: RetroColors.keyShadow,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: RetroDimensions.keyPressDuration,
              curve: Curves.easeOutQuad,
              top: topOffset,
              left: 0.0,
              right: 0.0,
              height: btnHeight,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: _isPressed
                        ? RetroColors.buttonBorder
                        : RetroColors.buttonHighlight,
                    width: 0.8,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _isPressed
                        ? [
                            RetroColors.keyPressedSurface,
                            RetroColors.keyShadow,
                          ]
                        : [
                            RetroColors.keySurfaceTop,
                            RetroColors.buttonSurface,
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: RetroColors.keyShadow,
                      offset: Offset(0.0, _isPressed ? 0.5 : 1.5),
                      blurRadius: _isPressed ? 0.5 : 2.0,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Invisible text for label match / accessibility
                    Opacity(
                      opacity: 0.0,
                      child: Text(
                        widget.label,
                        style: const TextStyle(fontSize: 1.0),
                      ),
                    ),
                    // Prominent retro symbol or icon
                    if (widget.icon != null)
                      widget.icon!
                    else if (widget.symbol != null)
                      Text(
                        widget.symbol!,
                        style: TextStyle(
                          fontSize: widget.symbolFontSize ?? 13.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: widget.accent ?? RetroColors.keyText,
                          height: 1.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
