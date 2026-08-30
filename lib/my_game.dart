import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'player.dart';

class MyGame extends FlameGame with KeyboardEvents, TapCallbacks {
  late Player player;

  @override
  Future<void> onLoad() async {
    player = Player(gameSize: size);
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

/*
  @override
  void onTapDown(TapDownEvent event) {
    if (event.localPosition.x < size.x / 2) {
      player.moveLeft();
    } else {
      player.moveRight();
    }
  }
  */

  @override
  void onTapDown(TapDownEvent event) {
    player.drop();
  }

  // without this, the player keeps moving in the same direction, even when you stop touching the screen.
  /*@override
  void onTapUp(TapUpEvent event) {
    player.stop();
  }*/
}

/*
// HANDLE COMPONENT MOVEMENT THROUGH KEYBOARD ACTION

  // @override
  // KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  //   if (event is KeyDownEvent) {
  //     if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
  //       player.position.x += 10;
  //     }

  //     if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
  //       player.position.x -= 10;
  //     }
  //   }

  //   return KeyEventResult.handled;
  // }


// ********* ANOTHER WAY OF CREATING THE SQUARE AND MOVING IT ALONG AXES **********

// class Square extends PositionComponent {
//   Square() : super(size: Vector2.all(50));

//   @override
//   void render(Canvas canvas) {
//     final paint = Paint()..color = Colors.blue;
//     canvas.drawRect(size.toRect(), paint);
//   }

//   @override
//   void update(double dt) {
//     position.y += 100 * dt;
//     // position.x += 100 * dt;

//     if (position.y > 700) {
//       position.y = 0;
//     }
//     // if (position.x > 400) {
//     //   position.x = 0;
//     // }
//   }
// }
 */
