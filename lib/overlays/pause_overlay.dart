import 'package:flutter/widgets.dart';
import 'package:retro_stack_frontend/phone/icons/retro_play_pause_icon.dart';
import '../game/my_game.dart';
import '../theme/colors.dart';
import 'pause_overlay_resume_button.dart';

/// Retro Pause banner overlay.
///
/// Displayed when the player presses the physical PAUSE/RESUME key (⏯️)
/// or when gameplay is paused.
class PauseOverlay extends StatefulWidget {
  final MyGame game;

  const PauseOverlay({super.key, required this.game});

  @override
  State<PauseOverlay> createState() => _PauseOverlayState();
}

class _PauseOverlayState extends State<PauseOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: RetroColors.lcdDarkest.withValues(alpha: 0.45),
      alignment: Alignment.center,
      child: Container(
        width: 165.0,
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: RetroColors.lcdLight,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: RetroColors.lcdDarkest, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: RetroColors.lcdDarkest.withValues(alpha: 0.35),
              offset: const Offset(2.0, 2.0),
              blurRadius: 0.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Paused title
            const Text(
              'PAUSED',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: RetroColors.lcdDarkest,
                fontFamily: 'monospace',
                height: 1.0,
              ),
            ),
            const SizedBox(height: 6.0),

            // Pixel Divider
            Container(height: 1.5, width: 100.0, color: RetroColors.lcdDark),
            const SizedBox(height: 8.0),

            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Press '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: RetroPlayPauseIcon(
                      size: 10,
                      color: RetroColors.lcdDark,
                    ),
                  ),
                  TextSpan(text: '  to Resume'),
                ],
              ),
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: RetroColors.lcdDark,
                fontFamily: 'monospace',
                height: 1.0,
              ),
            ),
            const SizedBox(height: 12.0),

            // Resume button
            PauseOverlayResumeButton(onPressed: widget.game.resumeGame),
          ],
        ),
      ),
    );
  }
}
