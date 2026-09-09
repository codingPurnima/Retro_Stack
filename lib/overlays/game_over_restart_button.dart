import 'package:flutter/widgets.dart';

import '../theme/colors.dart';

/// Tactile restart button used on the game-over overlay.
class GameOverRestartButton extends StatefulWidget {
  final VoidCallback onPressed;

  const GameOverRestartButton({super.key, required this.onPressed});

  @override
  State<GameOverRestartButton> createState() => _GameOverRestartButtonState();
}

class _GameOverRestartButtonState extends State<GameOverRestartButton> {
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
            border: Border.all(color: RetroColors.lcdDarkest, width: 1.5),
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
