import 'package:flutter/widgets.dart';
import '../game/my_game.dart';
import '../theme/colors.dart';

/// Retro-styled Game Over overlay rendered directly inside the LCD screen.
///
/// Scaled to fit comfortably within the LCD viewport (~214 px width) without
/// overflowing, featuring an authentic monochrome LCD palette and retro tactile button.
class GameOver extends StatelessWidget {
  final MyGame game;

  const GameOver({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RetroColors.lcdDarkest.withValues(alpha: 0.45),
      alignment: Alignment.center,
      child: Container(
        width: 175.0,
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
            // Title
            const Text(
              'Game Over!',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: RetroColors.lcdDarkest,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 6.0),

            // Pixel divider line
            Container(
              height: 1.5,
              width: 110.0,
              color: RetroColors.lcdDark,
            ),
            const SizedBox(height: 10.0),

            // Score display
            Text(
              'Score: ${game.score}',
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: RetroColors.lcdDarkest,
                height: 1.0,
              ),
            ),

            if (game.isNewHighScore) ...[
              const SizedBox(height: 8.0),

              const Text(
                'HIGH SCORE!',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: RetroColors.lcdDarkest,
                  height: 1.0,
                ),
              ),

              const SizedBox(height: 3.0),

              Text(
                '${game.highScore}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: RetroColors.lcdDarkest,
                  height: 1.0,
                ),
              ),
            ],

            const SizedBox(height: 14.0),

            // Retro restart button
            _RetroRestartButton(
              onPressed: game.restartGame,
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom retro-styled tactile button for the LCD interface.
class _RetroRestartButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _RetroRestartButton({
    required this.onPressed,
  });

  @override
  State<_RetroRestartButton> createState() => _RetroRestartButtonState();
}

class _RetroRestartButtonState extends State<_RetroRestartButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
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
            'Restart',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: RetroColors.lcdLight,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}