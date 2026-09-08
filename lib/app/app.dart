import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../audio/game_audio.dart';
import '../game/my_game.dart';
import '../overlays/game_menu.dart';
import '../overlays/game_over.dart';
import '../overlays/pause_overlay.dart';
import '../overlays/start_screen.dart';
import '../phone/frame/phone_frame.dart';
import '../theme/colors.dart';
import '../backgrounds/ambient_background.dart';

/// Top-level application widget for Retro Stack.
///
/// Renders the [PhoneShell] centered on a minimal ambient backdrop.
class RetroStackApp extends StatefulWidget {
  const RetroStackApp({super.key});

  @override
  State<RetroStackApp> createState() => _RetroStackAppState();
}

class _RetroStackAppState extends State<RetroStackApp> {
  late final MyGame _game;
  late final Widget _lcdWidget;

  @override
  void initState() {
    super.initState();
    _game = MyGame();
    _lcdWidget = GameWidget(
      game: _game,
      overlayBuilderMap: {
        'StartScreen': (context, game) {
          return StartScreen(game: game as MyGame);
        },
        'Menu': (context, game) {
          return GameMenu(game: game as MyGame);
        },
        'Pause': (context, game) {
          return PauseOverlay(game: game as MyGame);
        },
        'GameOver': (context, game) {
          return GameOver(game: game as MyGame);
        },
      },
    );
    // Initially activate StartScreen overlay and pause engine on application start.
    // We avoid passing initialActiveOverlays to GameWidget because Flame's GameWidget constructor
    // synchronously re-adds initialActiveOverlays if GameWidget is ever rebuilt.
    _game.overlays.add('StartScreen');
    _game.pauseEngine();
  }

  @override
  void dispose() {
    GameAudio.stopBgm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Stack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: RetroColors.deepBlack,
        useMaterial3: false,
      ),
      home: Scaffold(
        backgroundColor: RetroColors.deepBlack,
        body: AmbientBackground(
          child: SafeArea(
            child: ValueListenableBuilder<bool>(
              valueListenable: _game.showDropHintNotifier,
              builder: (context, showDropHint, _) {
                return PhoneShell(
                  highlightOk: showDropHint,
                  onKeyPressed: _game.handlePhysicalKey,
                  lcdChild: _lcdWidget,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

