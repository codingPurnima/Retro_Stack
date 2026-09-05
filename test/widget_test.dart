import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retro_stack_frontend/backgrounds/ambient_background.dart';
import 'package:retro_stack_frontend/app/app.dart';
import 'package:retro_stack_frontend/game/my_game.dart';
import 'package:retro_stack_frontend/overlays/game_menu.dart';
import 'package:retro_stack_frontend/overlays/game_over.dart';
import 'package:retro_stack_frontend/overlays/pause_overlay.dart';
import 'package:retro_stack_frontend/overlays/start_screen.dart';
import 'package:retro_stack_frontend/phone/lcd_screen.dart';
import 'package:retro_stack_frontend/phone/navigation_key.dart';
import 'package:retro_stack_frontend/phone/frame/phone_frame.dart';
import 'package:retro_stack_frontend/phone/icons/retro_menu_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_sound_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_play_pause_icon.dart';
import 'package:retro_stack_frontend/phone/icons/retro_power_icon.dart';
import 'package:retro_stack_frontend/phone/speaker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets(
    'RetroStackApp renders phone shell with embedded Flame game and ambient backdrop',
    (WidgetTester tester) async {
      await tester.pumpWidget(const RetroStackApp());
      await tester.pump(const Duration(milliseconds: 100));

      // Verify AmbientBackground surrounds the phone
      expect(find.byType(AmbientBackground), findsOneWidget);

      // Verify PhoneShell and primary sections are present
      expect(find.byType(PhoneShell), findsOneWidget);
      expect(find.byType(PhoneSpeaker), findsOneWidget);
      expect(find.byType(LcdScreen), findsOneWidget);

      // Verify LCD renders the embedded GameWidget
      expect(find.byType(GameWidget<MyGame>), findsOneWidget);

      // Verify physical buttons and retro vector icons (NO emojis)
      expect(find.byKey(const Key('MENU')), findsOneWidget);
      expect(find.byKey(const Key('SOUND')), findsOneWidget);
      expect(find.byKey(const Key('PAUSE/RESUME')), findsOneWidget);
      expect(find.byKey(const Key('END')), findsOneWidget);

      expect(find.byType(RetroMenuIcon), findsOneWidget);
      expect(find.byType(RetroSoundIcon), findsOneWidget);
      expect(find.byType(RetroPlayPauseIcon), findsOneWidget);
      expect(find.byType(RetroPowerIcon), findsOneWidget);

      // Verify center navigation key
      expect(find.byType(NavigationKey), findsOneWidget);
      expect(find.text('▲'), findsOneWidget);
      expect(find.text('▼'), findsOneWidget);
      expect(find.text('◀'), findsOneWidget);
      expect(find.text('▶'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // Numeric keypad was removed in Stage 1 redesign; ensure numeric labels are not present
      expect(find.text('1'), findsNothing);
      expect(find.text('5'), findsNothing);
      expect(find.text('9'), findsNothing);
    },
  );

  testWidgets(
    'PhoneShell scales responsively across various viewport sizes without overflow',
    (WidgetTester tester) async {
      final viewports = [
        const Size(360, 640), // Standard small phone
        const Size(412, 915), // Tall modern phone
        const Size(768, 1024), // Tablet portrait
        const Size(1024, 768), // Tablet landscape
      ];

      for (final size in viewports) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(const RetroStackApp());
        await tester.pump(const Duration(milliseconds: 50));

        expect(
          tester.takeException(),
          isNull,
          reason: 'Failed layout at size $size',
        );
        expect(find.byType(PhoneShell), findsOneWidget);
        expect(find.byType(LcdScreen), findsOneWidget);
      }

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    },
  );

  testWidgets('PhoneShell button callbacks dispatch correctly', (
    WidgetTester tester,
  ) async {
    final pressedKeys = <String>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: PhoneShell(onKeyPressed: (key) => pressedKeys.add(key)),
      ),
    );
    await tester.pump();

    // Tap MENU, SOUND, PAUSE/RESUME, END using keys
    await tester.tap(find.byKey(const Key('MENU')));
    await tester.pump();
    expect(pressedKeys, contains('MENU'));

    await tester.tap(find.byKey(const Key('SOUND')));
    await tester.pump();
    expect(pressedKeys, contains('SOUND'));

    await tester.tap(find.byKey(const Key('PAUSE/RESUME')));
    await tester.pump();
    expect(pressedKeys, contains('PAUSE/RESUME'));

    await tester.tap(find.byKey(const Key('END')));
    await tester.pump();
    expect(pressedKeys, contains('END'));

    // Tap Navigation keys
    await tester.tap(find.text('▲'));
    await tester.pump();
    expect(pressedKeys, contains('UP'));

    await tester.tap(find.text('▼'));
    await tester.pump();
    expect(pressedKeys, contains('DOWN'));

    await tester.tap(find.text('◀'));
    await tester.pump();
    expect(pressedKeys, contains('LEFT'));

    await tester.tap(find.text('▶'));
    await tester.pump();
    expect(pressedKeys, contains('RIGHT'));

    await tester.tap(find.text('OK'));
    await tester.pump();
    expect(pressedKeys, contains('OK'));
  });

  testWidgets('GameOver overlay renders properly inside LCD constraints', (
    WidgetTester tester,
  ) async {
    final game = MyGame();
    await game.onLoad();
    game.score = 12;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 214.0,
          height: 334.0,
          child: GameOver(game: game),
        ),
      ),
    );
    await tester.pump();

    // Verify 'Game Over!', score, and restart button
    expect(find.text('Game Over!'), findsOneWidget);
    expect(find.text('Score: 12'), findsOneWidget);
    expect(find.text('Restart'), findsOneWidget);

    // Verify tapping restart button triggers restart
    await tester.tap(find.text('Restart'));
    await tester.pump();
  });

  testWidgets('Physical SOUND button toggles global sound preference', (
    WidgetTester tester,
  ) async {
    final game = MyGame();
    await game.onLoad();

    final initialSound = game.soundEnabled;
    game.handlePhysicalKey('SOUND');
    expect(game.soundEnabled, !initialSound);
    expect(game.soundEnabledNotifier.value, !initialSound);

    game.handlePhysicalKey('SOUND');
    expect(game.soundEnabled, initialSound);
    expect(game.soundEnabledNotifier.value, initialSound);
  });

  testWidgets('Physical PAUSE/RESUME button pauses and resumes game engine', (
    WidgetTester tester,
  ) async {
    final game = MyGame();
    await game.onLoad();

    expect(game.paused, isFalse);
    game.handlePhysicalKey('PAUSE/RESUME');
    expect(game.paused, isTrue);
    expect(game.overlays.isActive('Pause'), isTrue);

    game.handlePhysicalKey('PAUSE/RESUME');
    expect(game.paused, isFalse);
    expect(game.overlays.isActive('Pause'), isFalse);
  });

  testWidgets('Physical END button returns game to StartScreen', (
    WidgetTester tester,
  ) async {
    final game = MyGame();
    await game.onLoad();

    game.handlePhysicalKey('END');
    expect(game.overlays.isActive('StartScreen'), isTrue);
    expect(game.paused, isTrue);
  });

  // =========================================================================
  // SECTION 4: VERIFY ALL OK INPUT PATHS (A through F)
  // =========================================================================

  testWidgets(
    'Path A: Start screen - Physical OK starts game and first box remains swinging (does NOT drop)',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.overlays.add('StartScreen');

      expect(game.playState, GamePlayState.startScreen);
      expect(game.currentBox.isAttached, isTrue);
      expect(game.currentBox.isDropping, isFalse);

      // Press physical OK to start game
      game.handlePhysicalKey('OK');

      // StartScreen must be dismissed and game transitioned to playing
      expect(game.overlays.isActive('StartScreen'), isFalse);
      expect(game.playState, GamePlayState.playing);

      // CRITICAL REQUIREMENT: First box MUST remain swinging, NOT dropped!
      expect(game.currentBox.isAttached, isTrue);
      expect(game.currentBox.isDropping, isFalse);
      expect(game.hasPerformedFirstDrop, isFalse);
      expect(game.showDropHintNotifier.value, isTrue);
    },
  );

  testWidgets(
    'Path B: Start screen - Click/tap PRESS OK TO PLAY starts game and first box remains swinging',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.overlays.add('StartScreen');

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 214.0,
            height: 334.0,
            child: StartScreen(game: game),
          ),
        ),
      );
      await tester.pump();

      // Tap on-screen button
      await tester.tap(find.text('PRESS OK TO PLAY'));
      await tester.pump();

      expect(game.overlays.isActive('StartScreen'), isFalse);
      expect(game.playState, GamePlayState.playing);
      expect(game.currentBox.isAttached, isTrue);
      expect(game.currentBox.isDropping, isFalse);
    },
  );

  testWidgets('Path C: Gameplay - Physical OK drops current swinging box', (
    WidgetTester tester,
  ) async {
    final game = MyGame();
    await game.onLoad();
    game.startGame();

    expect(game.playState, GamePlayState.playing);
    expect(game.currentBox.isAttached, isTrue);
    expect(game.currentBox.isDropping, isFalse);

    // Physical OK during gameplay triggers drop
    game.handlePhysicalKey('OK');

    expect(game.currentBox.isAttached, isFalse);
    expect(game.currentBox.isDropping, isTrue);
  });

  testWidgets(
    'Path D: Gameplay - Tapping anywhere in LCD does NOT drop the box',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.startGame();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 214.0,
            height: 334.0,
            child: GameWidget(game: game),
          ),
        ),
      );
      await tester.pump();

      // Tap center of LCD canvas
      await tester.tapAt(const Offset(107.0, 167.0));
      await tester.pump();

      // Box must remain swinging attached
      expect(game.currentBox.isAttached, isTrue);
      expect(game.currentBox.isDropping, isFalse);
    },
  );

  testWidgets('Path E: After first drop - PRESS OK TO DROP hint disappears', (
    WidgetTester tester,
  ) async {
    final game = MyGame();
    await game.onLoad();
    game.startGame();

    expect(game.hasPerformedFirstDrop, isFalse);
    expect(game.showDropHintNotifier.value, isTrue);

    // First physical drop
    game.handlePhysicalKey('OK');

    // After first drop, hint is dismissed
    expect(game.hasPerformedFirstDrop, isTrue);
    expect(game.showDropHintNotifier.value, isFalse);
  });

  testWidgets('Path F: Pause screen - Physical OK does NOT drop the box', (
    WidgetTester tester,
  ) async {
    final game = MyGame();
    await game.onLoad();
    game.startGame();

    // Pause the game
    game.handlePhysicalKey('PAUSE/RESUME');
    expect(game.playState, GamePlayState.paused);
    expect(game.currentBox.isAttached, isTrue);
    expect(game.currentBox.isDropping, isFalse);

    // Press OK while paused (resumes game)
    game.handlePhysicalKey('OK');
    expect(game.playState, GamePlayState.playing);

    // Box MUST NOT have dropped
    expect(game.currentBox.isAttached, isTrue);
    expect(game.currentBox.isDropping, isFalse);
  });

  testWidgets(
    'StartScreen and GameMenu overlays render properly with physical key support',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();

      // Verify StartScreen
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 214.0,
            height: 334.0,
            child: StartScreen(game: game),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('RETRO STACK'), findsOneWidget);
      expect(find.text('PRESS OK TO PLAY'), findsOneWidget);

      // Verify GameMenu
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 214.0,
            height: 334.0,
            child: GameMenu(game: game),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('OPTIONS'), findsOneWidget);
      expect(find.text('Sound'), findsOneWidget);
      expect(find.text('Difficulty'), findsOneWidget);
      expect(find.text('NORMAL'), findsOneWidget);
      expect(find.text('High Score'), findsOneWidget);
      expect(find.text('BACK'), findsOneWidget);

      // Verify PauseOverlay
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 214.0,
            height: 334.0,
            child: PauseOverlay(game: game),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('PAUSED'), findsOneWidget);
      expect(find.text('RESUME'), findsOneWidget);
    },
  );

  testWidgets(
    'StartScreen overlay lifecycle: 1 press starts game and drop does NOT re-show start screen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const RetroStackApp());
      await tester.pump(const Duration(milliseconds: 100));

      // 1. Initially StartScreen overlay is displayed
      expect(find.byType(StartScreen), findsOneWidget);
      expect(find.text('PRESS OK TO PLAY'), findsOneWidget);

      // 2. Exactly ONE press on physical OK must start the game
      await tester.tap(find.text('OK'));
      await tester.pump();

      // StartScreen must be gone immediately after first press
      expect(find.byType(StartScreen), findsNothing);

      // 3. Press physical OK again to drop the first swinging box
      await tester.tap(find.text('OK'));
      await tester.pump();

      // StartScreen MUST NOT reappear after drop!
      expect(find.byType(StartScreen), findsNothing);

      // 4. Press physical END button to return to StartScreen
      await tester.tap(find.byKey(const Key('END')));
      await tester.pump();

      // StartScreen reappears cleanly upon END key
      expect(find.byType(StartScreen), findsOneWidget);
    },
  );
}
