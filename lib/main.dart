import 'package:flutter/material.dart';
import 'app/app.dart';
import 'audio/game_audio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GameAudio.initialize();
  runApp(const RetroStackApp());
}
