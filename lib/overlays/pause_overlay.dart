import 'package:flutter/widgets.dart';
import '../game/my_game.dart';
import '../theme/colors.dart';

/// Retro Pause banner overlay.
///
/// Displayed when the player presses the physical PAUSE/RESUME key (⏯️)
/// or when gameplay is paused.
class PauseOverlay extends StatefulWidget {
  final MyGame game;

  const PauseOverlay({
    super.key,
    required this.game,
  });

  @override
  State<PauseOverlay> createState() => _PauseOverlayState();
}

class _PauseOverlayState extends State<PauseOverlay> {
  bool _isPressed = false;

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
          border: Border.all(
            color: RetroColors.lcdDarkest,
            width: 2.0,
          ),
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
            Container(
              height: 1.5,
              width: 100.0,
              color: RetroColors.lcdDark,
            ),
            const SizedBox(height: 8.0),

            const Text(
              'Press ⏯️ to Resume',
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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) {
                setState(() => _isPressed = false);
                widget.game.resumeGame();
              },
              onTapCancel: () => setState(() => _isPressed = false),
              child: Transform.translate(
                offset: Offset(0.0, _isPressed ? 1.5 : 0.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: _isPressed ? RetroColors.lcdDark : RetroColors.lcdDarkest,
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      color: RetroColors.lcdDarkest,
                      width: 1.5,
                    ),
                    boxShadow: _isPressed
                        ? []
                        : [
                            BoxShadow(
                              color: RetroColors.lcdDarkest.withValues(alpha: 0.4),
                              offset: const Offset(0.0, 1.5),
                              blurRadius: 0.0,
                            ),
                          ],
                  ),
                  child: const Text(
                    'RESUME',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      color: RetroColors.lcdLight,
                      fontFamily: 'monospace',
                      height: 1.0,
                    ),
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
