import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/box.dart';

class MyGame extends FlameGame with KeyboardEvents, TapCallbacks {
  late Box box;
  double floorY = 700;

  @override
  Future<void> onLoad() async {
    box = Box(gameSize: size, floorY: floorY);
    add(box);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    box.handleInput(keysPressed);
    return KeyEventResult.handled;
  }

  @override
  void onTapDown(TapDownEvent event) {
    box.drop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (box.hasLanded) {
      floorY = box.position.y;

      box = Box(floorY: floorY, gameSize: size);

      add(box);
    }
  }
}
