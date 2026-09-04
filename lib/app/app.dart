import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/my_game.dart';
import '../overlays/game_over.dart';
import '../phone/phone_frame.dart';
import '../theme/colors.dart';

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

  @override
  void initState() {
    super.initState();
    _game = MyGame();
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
        body: SafeArea(
          child: PhoneShell(
            lcdChild: GameWidget(
              game: _game,
              overlayBuilderMap: {
                'GameOver': (context, game) {
                  return GameOver(game: game as MyGame);
                },
              },
            ),
          ),
        ),
      ),
    );
  }
}

