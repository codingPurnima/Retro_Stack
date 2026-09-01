import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:retro_stack_frontend/game/my_game.dart';
import 'package:retro_stack_frontend/overlays/game_over.dart';

void main() {
  final game = MyGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        'GameOver': (context, game) {
          return GameOver(game: game as MyGame);
        },
      },
    ),
  );
}
