import 'package:flutter/material.dart';

import '../game/my_game.dart';

class GameOver extends StatelessWidget {
  final MyGame game;

  const GameOver({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Score: ${game.score}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: game.restartGame,
                child: const Text('Restart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}