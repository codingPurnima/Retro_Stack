import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';

class MyGame extends FlameGame with KeyboardEvents, TapCallbacks {
  late Player player;
  double floorY = 700;

  @override
  Future<void> onLoad() async {
    player = Player(gameSize: size, floorY: floorY);
    add(player);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    player.handleInput(keysPressed);
    return KeyEventResult.handled;
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.drop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (player.hasLanded) {
      floorY = player.position.y;

      player = Player(floorY: floorY, gameSize: size);

      add(player);
    }
  }
}
