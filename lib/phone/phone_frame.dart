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

                  // Glossy Dark Faceplate framing speaker, LCD, and controls
                  Positioned(
                    top: RetroDimensions.faceplateMarginTop,
                    left: RetroDimensions.faceplateMarginHorizontal,
                    right: RetroDimensions.faceplateMarginHorizontal,
                    bottom: RetroDimensions.sliderChinHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(22.0),
                          topRight: Radius.circular(22.0),
                          bottomLeft: Radius.circular(28.0),
                          bottomRight: Radius.circular(28.0),
                        ),
                        border: Border.all(
                          color: RetroColors.faceplateBevel,
                          width: 1.2,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            RetroColors.faceplateMid,
                            RetroColors.faceplateDark,
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x88000000),
                            offset: Offset(0.0, 2.0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 6.0),

                          // Speaker grille & sensor (Section 7)
                          const PhoneSpeaker(),
                          const SizedBox(height: 6.0),

                          // LCD Screen & Bezel (Section 8)
                          LcdScreen(child: lcdChild),
                          const SizedBox(height: 8.0),

                          // Control Section: Flanking button columns + Center D-pad
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left Flanking Buttons: Menu (top) + Call (bottom)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _PhysicalButton(
                                      key: const Key('MENU'),
                                      label: 'MENU',
                                      symbol: '≡',
                                      accent: RetroColors.buttonIconRed,
                                      symbolFontSize: 16.0,
                                      onTap: () => onKeyPressed?.call('MENU'),
                                    ),
                                    const SizedBox(height: 6.0),
                                    _PhysicalButton(
                                      key: const Key('CALL'),
                                      label: 'CALL',
                                      symbol: '📞',
                                      accent: RetroColors.buttonIconSilver,
                                      symbolFontSize: 11.5,
                                      onTap: () => onKeyPressed?.call('CALL'),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 10.0),

                                // Central D-pad
                                NavigationKey(onKeyPressed: onKeyPressed),

                                const SizedBox(width: 10.0),

                                // Right Flanking Buttons: Back (top) + End/Power (bottom)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _PhysicalButton(
                                      key: const Key('BACK'),
                                      label: 'BACK',
                                      symbol: '↩',
                                      accent: RetroColors.buttonIconRed,
                                      symbolFontSize: 14.0,
                                      onTap: () => onKeyPressed?.call('BACK'),
                                    ),
                                    const SizedBox(height: 6.0),
                                    _PhysicalButton(
                                      key: const Key('END'),
                                      label: 'END',
                                      symbol: '⏻',
                                      accent: RetroColors.buttonIconRed,
                                      symbolFontSize: 14.0,
                                      onTap: () => onKeyPressed?.call('END'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Exposed Slider Chin details at the bottom
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    height: RetroDimensions.sliderChinHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Subtle slider seam / grip lip
                        Container(
                          width: 54.0,
                          height: 3.0,
                          decoration: BoxDecoration(
                            color: RetroColors.phoneBodyDark,
                            borderRadius: BorderRadius.circular(1.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x44FFFFFF),
                                offset: Offset(0.0, 1.0),
                                blurRadius: 0.5,
                              ),
                            ],
                          ),
                        ),
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
  final String symbol;
  final Color? accent;
  final double? symbolFontSize;
  final VoidCallback? onTap;

  const _PhysicalButton({
    super.key,
    required this.label,
    required this.symbol,
    this.accent,
    this.symbolFontSize,
    this.onTap,
  });

  @override
  State<_PhysicalButton> createState() => _PhysicalButtonState();
}

class _PhysicalButtonState extends State<_PhysicalButton> {
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
                    // Prominent inspiration symbol
                    Text(
                      widget.symbol,
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
