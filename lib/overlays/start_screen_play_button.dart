import 'package:flutter/widgets.dart';

import '../theme/colors.dart';

/// Tactile play button for the start screen.
class StartScreenPlayButton extends StatefulWidget {
  final VoidCallback onPressed;

  const StartScreenPlayButton({super.key, required this.onPressed});

  @override
  State<StartScreenPlayButton> createState() => _StartScreenPlayButtonState();
}

class _StartScreenPlayButtonState extends State<StartScreenPlayButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 7.0),
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
            'PRESS OK TO PLAY',
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
    );
  }
}
