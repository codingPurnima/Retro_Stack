// Re-export the new PhoneShell implementation so existing imports
// of `lib/phone/phone_frame.dart` continue to work.
export 'phone_shell.dart';
import 'package:flutter/widgets.dart';
import 'package:retro_stack_frontend/phone/icons/retro_play_pause_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_power_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_sound_icon.dart';
import 'package:retro_stack_frontend/phone/frame/physical_button.dart';
import '../../theme/colors.dart';
import '../../theme/dimensions.dart';
import '../navigation_key.dart';
import '../lcd_screen.dart';
import '../speaker.dart';
import '../icons/retro_menu_icon.dart';

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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left Flanking Buttons: Menu (top) + Sound (bottom)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PhysicalButton(
                                      key: const Key('MENU'),
                                      label: 'MENU',
                                      icon: const RetroMenuIcon(),
                                      onTap: () => onKeyPressed?.call('MENU'),
                                    ),
                                    const SizedBox(height: 6.0),
                                    PhysicalButton(
                                      key: const Key('SOUND'),
                                      label: 'SOUND',
                                      icon: const RetroSoundIcon(),
                                      onTap: () => onKeyPressed?.call('SOUND'),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 10.0),

                                // Central D-pad
                                NavigationKey(
                                  onKeyPressed: onKeyPressed,
                                  highlightOk: highlightOk,
                                ),

                                const SizedBox(width: 10.0),

                                // Right Flanking Buttons: Pause/Resume (top) + End/Power (bottom)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PhysicalButton(
                                      key: const Key('PAUSE/RESUME'),
                                      label: 'PAUSE/RESUME',
                                      icon: const RetroPlayPauseIcon(),
                                      onTap: () =>
                                          onKeyPressed?.call('PAUSE/RESUME'),
                                    ),
                                    const SizedBox(height: 6.0),
                                    PhysicalButton(
                                      key: const Key('END'),
                                      label: 'END',
                                      icon: const RetroPowerIcon(),
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
