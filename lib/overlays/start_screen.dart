import 'package:flutter/widgets.dart';
import '../game/my_game.dart';
import '../theme/colors.dart';
import 'start_screen_play_button.dart';

/// Retro Title / Start Screen overlay.
///
/// Displayed upon launching the application or whenever the player presses the
/// physical END / Power key to exit gameplay back to the Home / Title screen.
///
/// Prominently features:
/// - Game Title: RETRO STACK
/// - High Score reading
/// - Tactile prompt: "PRESS OK TO PLAY" / Play button
class StartScreen extends StatefulWidget {
  final MyGame game;

  const StartScreen({super.key, required this.game});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: RetroColors.lcdDarkest.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: Container(
        width: 185.0,
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
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
            // Game Title
            const Text(
              'RETRO STACK',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: RetroColors.lcdDarkest,
                fontFamily: 'monospace',
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4.0),

            const Text(
              '★ TOWER BUILDER ★',
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: RetroColors.lcdDark,
                fontFamily: 'monospace',
                height: 1.0,
              ),
            ),
            const SizedBox(height: 8.0),

            // Pixel Divider
            Container(height: 1.5, width: 120.0, color: RetroColors.lcdDark),
            const SizedBox(height: 10.0),

            // High Score Banner
            const Text(
              'HIGH SCORE',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: RetroColors.lcdDark,
                fontFamily: 'monospace',
                height: 1.0,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              '${widget.game.highScore}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: RetroColors.lcdDarkest,
                fontFamily: 'monospace',
                height: 1.0,
              ),
            ),
            const SizedBox(height: 14.0),

            // Play / Start Action Button
            StartScreenPlayButton(onPressed: widget.game.startGame),
          ],
        ),
      ),
    );
  }
}
