import 'package:flutter/material.dart';
import '../phone/phone_frame.dart';
import '../theme/colors.dart';

/// Top-level application widget for Retro Stack.
///
/// Renders the [PhoneShell] centered on a minimal ambient backdrop.
class RetroStackApp extends StatelessWidget {
  const RetroStackApp({super.key});

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
      home: const Scaffold(
        backgroundColor: RetroColors.deepBlack,
        body: SafeArea(
          child: PhoneShell(),
        ),
      ),
    );
  }
}
