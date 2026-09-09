import 'package:flutter/widgets.dart';

import '../theme/colors.dart';

/// Tactile resume button used in the pause overlay.
class PauseOverlayResumeButton extends StatefulWidget {
  final VoidCallback onPressed;

  const PauseOverlayResumeButton({super.key, required this.onPressed});

  @override
  State<PauseOverlayResumeButton> createState() =>
      _PauseOverlayResumeButtonState();
}

class _PauseOverlayResumeButtonState extends State<PauseOverlayResumeButton> {
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
    );
  }
}
