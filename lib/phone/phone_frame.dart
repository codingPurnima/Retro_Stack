import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import 'navigation_key.dart';
import 'lcd_screen.dart';
import 'speaker.dart';

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

  const PhoneShell({super.key, this.lcdChild, this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  color: RetroColors.phoneOuter,
                  width: RetroDimensions.phoneBorderWidth,
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    RetroColors.phoneGradientLight,
                    RetroColors.phoneMain,
                    RetroColors.phoneGradientDark,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: RetroColors.phoneShadow,
                    offset: Offset(0.0, RetroDimensions.phoneShadowOffsetY),
                    blurRadius: RetroDimensions.phoneShadowBlur,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: RetroDimensions.phoneTopPadding),

                  // Speaker grille (Section 7)
                  const PhoneSpeaker(),
                  const SizedBox(height: RetroDimensions.speakerMarginBottom),

                  // LCD Screen & Bezel (Section 8)
                  LcdScreen(child: lcdChild),
                  const SizedBox(height: RetroDimensions.lcdMarginBottom),

                  // Physical button row + Navigation D-pad (replacing the 3x4 keypad)
                  SizedBox(
                    width: RetroDimensions.keypadWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Physical left / right / end buttons flanking the nav pad
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _PhysicalButton(
                              label: 'MENU',
                              onTap: () => onKeyPressed?.call('MENU'),
                            ),
                            _PhysicalButton(
                              label: 'BACK',
                              onTap: () => onKeyPressed?.call('BACK'),
                            ),
                            _PhysicalButton(
                              label: 'END',
                              accent: RetroColors.redAccent,
                              onTap: () => onKeyPressed?.call('END'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: RetroDimensions.softKeyMarginBottom,
                        ),

                        // Center Navigation D-pad
                        NavigationKey(onKeyPressed: onKeyPressed),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhysicalButton extends StatefulWidget {
  final String label;
  final Color? accent;
  final VoidCallback? onTap;

  const _PhysicalButton({required this.label, this.accent, this.onTap});

  @override
  State<_PhysicalButton> createState() => _PhysicalButtonState();
}

class _PhysicalButtonState extends State<_PhysicalButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final topOffset = _isPressed ? 1.5 : 0.0;
    final baseColor = widget.accent ?? RetroColors.softKeySurface;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: RetroDimensions.softKeyWidth,
        height: RetroDimensions.softKeyHeight + 4.0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
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
                  color: baseColor,
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
                  style: TextStyle(
                    fontSize: RetroDimensions.softKeyFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: widget.accent != null
                        ? Color(0xFFFFFFFF)
                        : RetroColors.softKeyText,
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
