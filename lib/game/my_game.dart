import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';

class MyGame extends FlameGame with KeyboardEvents, TapCallbacks {
  late Player player;

  @override
  Future<void> onLoad() async {
    player = Player(gameSize: size, floorY: 700);
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
}
