import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'player.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    add(Player());
  }
}

