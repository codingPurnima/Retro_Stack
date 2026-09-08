import 'package:flutter/widgets.dart';
import 'package:retro_stack_frontend/phone/icons/retro_play_pause_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_power_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_sound_icon.dart';
import 'package:retro_stack_frontend/phone/frame/physical_button.dart';
import 'package:retro_stack_frontend/theme/dimensions.dart';
import '../icons/retro_menu_icon.dart';
import '../navigation_key.dart';

class PhoneControls extends StatelessWidget {
  final ValueChanged<String>? onKeyPressed;
  final bool highlightOk;

  const PhoneControls({super.key, this.onKeyPressed, this.highlightOk = false});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: RetroDimensions.controlsScale,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
          NavigationKey(onKeyPressed: onKeyPressed, highlightOk: highlightOk),

          const SizedBox(width: 10.0),

          // Right Flanking Buttons: Pause/Resume (top) + End/Power (bottom)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PhysicalButton(
                key: const Key('PAUSE/RESUME'),
                label: 'PAUSE/RESUME',
                icon: const RetroPlayPauseIcon(),
                onTap: () => onKeyPressed?.call('PAUSE/RESUME'),
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
    );
  }
}
