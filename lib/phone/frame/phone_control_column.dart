import 'package:flutter/widgets.dart';
import 'package:retro_stack_frontend/phone/frame/physical_button.dart';
import 'package:retro_stack_frontend/phone/icons/retro_menu_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_play_pause_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_power_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_sound_icon.dart';

/// Reusable left/right control column for the phone faceplate.
class PhoneControlColumn extends StatelessWidget {
  final bool isLeftSide;
  final ValueChanged<String>? onKeyPressed;

  const PhoneControlColumn({
    super.key,
    required this.isLeftSide,
    this.onKeyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final topKey = isLeftSide ? 'MENU' : 'PAUSE/RESUME';
    final bottomKey = isLeftSide ? 'SOUND' : 'END';
    final topIcon = isLeftSide
        ? const RetroMenuIcon()
        : const RetroPlayPauseIcon();
    final bottomIcon = isLeftSide
        ? const RetroSoundIcon()
        : const RetroPowerIcon();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhysicalButton(
          key: Key(topKey),
          label: topKey,
          icon: topIcon,
          onTap: () => onKeyPressed?.call(topKey),
        ),
        const SizedBox(height: 6.0),
        PhysicalButton(
          key: Key(bottomKey),
          label: bottomKey,
          icon: bottomIcon,
          onTap: () => onKeyPressed?.call(bottomKey),
        ),
      ],
    );
  }
}
