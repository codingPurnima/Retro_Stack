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
import 'package:retro_stack_frontend/game/components/box.dart';
import 'package:retro_stack_frontend/audio/game_audio.dart';
import 'package:retro_stack_frontend/theme/colors.dart';
import 'package:retro_stack_frontend/theme/dimensions.dart';
import 'package:retro_stack_frontend/phone/frame/phone_controls.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    GameAudio.soundEnabled = true;
    GameAudio.resetMetrics();
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
      expect(game.currentBox, isNull);

      // Press physical OK to start game
      game.handlePhysicalKey('OK');

      // StartScreen must be dismissed and game transitioned to playing
      expect(game.overlays.isActive('StartScreen'), isFalse);
      expect(game.playState, GamePlayState.playing);

      // CRITICAL REQUIREMENT: First box MUST remain swinging, NOT dropped!
      expect(game.currentBox, isNotNull);
      expect(game.currentBox!.isAttached, isTrue);
      expect(game.currentBox!.isDropping, isFalse);
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

      expect(game.currentBox, isNull);

      // Tap on-screen button
      await tester.tap(find.text('PRESS OK TO PLAY'));
      await tester.pump();

      expect(game.overlays.isActive('StartScreen'), isFalse);
      expect(game.playState, GamePlayState.playing);
      expect(game.currentBox, isNotNull);
      expect(game.currentBox!.isAttached, isTrue);
      expect(game.currentBox!.isDropping, isFalse);
    },
  );

  testWidgets('Path C: Gameplay - Physical OK drops current swinging box', (
    WidgetTester tester,
  ) async {
    final game = MyGame();
    await game.onLoad();
    game.startGame();

    expect(game.playState, GamePlayState.playing);
    expect(game.currentBox!.isAttached, isTrue);
    expect(game.currentBox!.isDropping, isFalse);

    // Physical OK during gameplay triggers drop
    game.handlePhysicalKey('OK');

    expect(game.currentBox!.isAttached, isFalse);
    expect(game.currentBox!.isDropping, isTrue);
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
      expect(game.currentBox!.isAttached, isTrue);
      expect(game.currentBox!.isDropping, isFalse);
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
    expect(game.currentBox!.isAttached, isTrue);
    expect(game.currentBox!.isDropping, isFalse);

    // Press OK while paused (resumes game)
    game.handlePhysicalKey('OK');
    expect(game.playState, GamePlayState.playing);

    // Box MUST NOT have dropped
    expect(game.currentBox!.isAttached, isTrue);
    expect(game.currentBox!.isDropping, isFalse);
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

  testWidgets(
    'FLOW B: Power key returns to StartScreen with ZERO active boxes and restart spawns exactly ONE box',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();

      // 1. Start fresh game (FLOW A)
      game.startGame();
      expect(game.playState, GamePlayState.playing);
      expect(game.world.children.whereType<Box>().length, 1);
      expect(game.currentBox, isNotNull);
      expect(game.currentBox!.isAttached, isTrue);

      // 2. Drop the first box so it is in world and next box is spawned
      game.dropBox();
      expect(game.currentBox!.isDropping, isTrue);

      // 3. Press physical POWER ('END') during playing
      game.handlePhysicalKey('END');
      expect(game.playState, GamePlayState.startScreen);
      expect(game.paused, isTrue);

      // CRITICAL: Ensure there are ZERO active Box or GameStack components from previous run
      expect(game.world.children.whereType<Box>(), isEmpty);
      expect(game.currentBox, isNull);
      expect(game.lastBox, isNull);

      // 4. Press physical OK to start game again (FLOW B)
      game.handlePhysicalKey('OK');
      expect(game.playState, GamePlayState.playing);
      expect(game.paused, isFalse);

      // CRITICAL: Exactly ONE swinging box and ONE GameStack must exist
      expect(game.world.children.whereType<Box>().length, 1);
      expect(game.currentBox, isNotNull);
      expect(game.currentBox!.isAttached, isTrue);
      expect(game.currentBox!.isDropping, isFalse);
    },
  );

  testWidgets(
    'Multiple POWER -> START -> PLAY cycles produce no duplicate boxes or pendulums',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();

      for (int i = 0; i < 4; i++) {
        // Start game
        game.startGame();
        expect(game.world.children.whereType<Box>().length, 1,
            reason: 'Cycle $i: expected exactly 1 box on start');
        expect(game.currentBox!.isAttached, isTrue);

        // Press POWER
        game.handlePhysicalKey('END');
        expect(game.playState, GamePlayState.startScreen);
        expect(game.world.children.whereType<Box>(), isEmpty,
            reason: 'Cycle $i: expected 0 boxes on start screen');
        expect(game.currentBox, isNull);
      }
    },
  );

  testWidgets(
    'Normal GAME OVER -> RESTART preserves single active box and stack',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();

      game.startGame();
      expect(game.world.children.whereType<Box>().length, 1);

      // Trigger Game Over
      game.endGame();
      expect(game.gameOver, isTrue);

      // Restart
      game.restartGame();
      expect(game.gameOver, isFalse);
      expect(game.playState, GamePlayState.playing);
      expect(game.world.children.whereType<Box>().length, 1);
      expect(game.currentBox!.isAttached, isTrue);
    },
  );

  // =========================================================================
  // SECTION 5: RETRO MENU D-PAD NAVIGATION & SELECTION TESTS
  // =========================================================================

  testWidgets(
    'Menu navigation: UP and DOWN keys cycle through options with wrap-around',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.overlays.add('Menu');

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

      // Initially index 0 ('Sound') is selected (lcdLight text, lcdDarkest background)
      expect(tester.widget<Text>(find.text('Sound')).style?.color, RetroColors.lcdLight);
      expect(tester.widget<Text>(find.text('Difficulty')).style?.color, RetroColors.lcdDarkest);
      expect(tester.widget<Text>(find.text('High Score')).style?.color, RetroColors.lcdDarkest);
      expect(tester.widget<Text>(find.text('BACK')).style?.color, RetroColors.lcdDarkest);

      // DOWN -> Option 1: Difficulty
      game.handlePhysicalKey('DOWN');
      await tester.pump();
      expect(tester.widget<Text>(find.text('Sound')).style?.color, RetroColors.lcdDarkest);
      expect(tester.widget<Text>(find.text('Difficulty')).style?.color, RetroColors.lcdLight);

      // DOWN -> Option 2: High Score
      game.handlePhysicalKey('DOWN');
      await tester.pump();
      expect(tester.widget<Text>(find.text('Difficulty')).style?.color, RetroColors.lcdDarkest);
      expect(tester.widget<Text>(find.text('High Score')).style?.color, RetroColors.lcdLight);

      // DOWN -> Option 3: BACK
      game.handlePhysicalKey('DOWN');
      await tester.pump();
      expect(tester.widget<Text>(find.text('High Score')).style?.color, RetroColors.lcdDarkest);
      expect(tester.widget<Text>(find.text('BACK')).style?.color, RetroColors.lcdLight);

      // DOWN -> Wrap around to Option 0: Sound
      game.handlePhysicalKey('DOWN');
      await tester.pump();
      expect(tester.widget<Text>(find.text('BACK')).style?.color, RetroColors.lcdDarkest);
      expect(tester.widget<Text>(find.text('Sound')).style?.color, RetroColors.lcdLight);

      // UP -> Wrap around backwards to Option 3: BACK
      game.handlePhysicalKey('UP');
      await tester.pump();
      expect(tester.widget<Text>(find.text('Sound')).style?.color, RetroColors.lcdDarkest);
      expect(tester.widget<Text>(find.text('BACK')).style?.color, RetroColors.lcdLight);

      // UP -> Option 2: High Score
      game.handlePhysicalKey('UP');
      await tester.pump();
      expect(tester.widget<Text>(find.text('BACK')).style?.color, RetroColors.lcdDarkest);
      expect(tester.widget<Text>(find.text('High Score')).style?.color, RetroColors.lcdLight);

      // UP -> Option 1: Difficulty
      game.handlePhysicalKey('UP');
      await tester.pump();
      expect(tester.widget<Text>(find.text('Difficulty')).style?.color, RetroColors.lcdLight);

      // UP -> Option 0: Sound
      game.handlePhysicalKey('UP');
      await tester.pump();
      expect(tester.widget<Text>(find.text('Sound')).style?.color, RetroColors.lcdLight);
    },
  );

  testWidgets(
    'Menu navigation: Tapping an option selects it immediately and D-pad continues from there',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.overlays.add('Menu');

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

      // Tap Option 1: Difficulty
      await tester.tap(find.text('Difficulty'));
      await tester.pump();
      expect(tester.widget<Text>(find.text('Difficulty')).style?.color, RetroColors.lcdLight);
      expect(tester.widget<Text>(find.text('Sound')).style?.color, RetroColors.lcdDarkest);

      // Subsequent DOWN key must move to Option 2: High Score
      game.handlePhysicalKey('DOWN');
      await tester.pump();
      expect(tester.widget<Text>(find.text('Difficulty')).style?.color, RetroColors.lcdDarkest);
      expect(tester.widget<Text>(find.text('High Score')).style?.color, RetroColors.lcdLight);

      // Tap Option 1 again
      await tester.tap(find.text('Difficulty'));
      await tester.pump();
      expect(tester.widget<Text>(find.text('Difficulty')).style?.color, RetroColors.lcdLight);

      // Subsequent UP key must move to Option 0: Sound
      game.handlePhysicalKey('UP');
      await tester.pump();
      expect(tester.widget<Text>(find.text('Sound')).style?.color, RetroColors.lcdLight);
    },
  );

  testWidgets(
    'Menu activation: OK key toggles sound when Sound selected and closes menu when BACK selected',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.overlays.add('Menu');

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

      expect(game.soundEnabled, isTrue);
      expect(find.text('ON'), findsOneWidget);

      // OK with index 0 (Sound) selected toggles sound OFF
      game.handlePhysicalKey('OK');
      await tester.pump();
      expect(game.soundEnabled, isFalse);
      expect(find.text('OFF'), findsOneWidget);

      // OK again toggles sound ON
      game.handlePhysicalKey('OK');
      await tester.pump();
      expect(game.soundEnabled, isTrue);
      expect(find.text('ON'), findsOneWidget);

      // Navigate UP to Option 3: BACK
      game.handlePhysicalKey('UP');
      await tester.pump();
      expect(tester.widget<Text>(find.text('BACK')).style?.color, RetroColors.lcdLight);

      // OK with BACK selected closes menu
      game.handlePhysicalKey('OK');
      await tester.pump();
      expect(game.overlays.isActive('Menu'), isFalse);
    },
  );

  testWidgets(
    'Menu input isolation: Directional keys behave correctly when menu is closed vs open',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.startGame();

      expect(game.playState, GamePlayState.playing);
      expect(game.keyEventNotifier.value, isNull);

      // When menu is closed, UP and DOWN do not dispatch to keyEventNotifier
      game.handlePhysicalKey('UP');
      expect(game.keyEventNotifier.value, isNull);

      game.handlePhysicalKey('DOWN');
      expect(game.keyEventNotifier.value, isNull);

      game.handlePhysicalKey('LEFT');
      expect(game.keyEventNotifier.value, isNull);

      game.handlePhysicalKey('RIGHT');
      expect(game.keyEventNotifier.value, isNull);

      // Now open Menu
      game.toggleMenu();
      expect(game.playState, GamePlayState.menu);

      // LEFT and RIGHT remain unassigned and ignored even in menu
      game.handlePhysicalKey('LEFT');
      expect(game.keyEventNotifier.value, isNull);

      game.handlePhysicalKey('RIGHT');
      expect(game.keyEventNotifier.value, isNull);

      // UP and DOWN dispatch to menu
      game.handlePhysicalKey('DOWN');
      expect(game.keyEventNotifier.value, 'DOWN');

      game.handlePhysicalKey('UP');
      expect(game.keyEventNotifier.value, 'UP');
    },
  );

  testWidgets(
    'End-to-End: Physical D-pad navigates menu in RetroStackApp',
    (WidgetTester tester) async {
      await tester.pumpWidget(const RetroStackApp());
      await tester.pump(const Duration(milliseconds: 100));

      // Open menu via physical MENU button
      await tester.tap(find.byKey(const Key('MENU')));
      await tester.pump();

      expect(find.text('OPTIONS'), findsOneWidget);
      expect(tester.widget<Text>(find.text('Sound')).style?.color, RetroColors.lcdLight);

      // Press D-pad DOWN ('▼')
      await tester.tap(find.text('▼'));
      await tester.pump();
      expect(tester.widget<Text>(find.text('Difficulty')).style?.color, RetroColors.lcdLight);

      // Press D-pad DOWN again ('▼') -> High Score
      await tester.tap(find.text('▼'));
      await tester.pump();
      expect(tester.widget<Text>(find.text('High Score')).style?.color, RetroColors.lcdLight);

      // Press D-pad DOWN again ('▼') -> BACK
      await tester.tap(find.text('▼'));
      await tester.pump();
      expect(tester.widget<Text>(find.text('BACK')).style?.color, RetroColors.lcdLight);

      // Press D-pad OK -> Closes menu
      await tester.tap(find.text('OK'));
      await tester.pump();
      expect(find.text('OPTIONS'), findsNothing);
    },
  );

  // =========================================================================
  // SECTION 6: SFX INTEGRATION & AUDIO ARCHITECTURE TESTS
  // =========================================================================

  testWidgets(
    'SFX: box_release.wav plays exactly once when swinging box is released',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.startGame();

      GameAudio.resetMetrics();
      expect(game.currentBox, isNotNull);

      // Drop the swinging box via physical OK
      game.handlePhysicalKey('OK');

      expect(GameAudio.lastPlayedSound, GameAudio.boxRelease);
      expect(
        GameAudio.playHistory.where((s) => s == GameAudio.boxRelease).length,
        1,
      );

      // Attempting to call drop again on already dropping box must not replay sound
      game.currentBox!.drop();
      expect(
        GameAudio.playHistory.where((s) => s == GameAudio.boxRelease).length,
        1,
      );

      // Attempting to press OK again while box is already dropping must NOT replay sound
      game.handlePhysicalKey('OK');
      expect(
        GameAudio.playHistory.where((s) => s == GameAudio.boxRelease).length,
        1,
      );
    },
  );

  testWidgets(
    'SFX: OK key does NOT trigger box_release.wav on StartScreen, Menu, Pause, or GameOver',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.overlays.add('StartScreen');
      game.pauseEngine();

      GameAudio.resetMetrics();

      // 1. StartScreen: OK starts game, must NOT play box_release.wav
      expect(game.playState, GamePlayState.startScreen);
      game.handlePhysicalKey('OK');
      expect(game.playState, GamePlayState.playing);
      expect(GameAudio.playHistory, isNot(contains(GameAudio.boxRelease)));

      // 2. Pause: OK resumes game, must NOT play box_release.wav
      game.handlePhysicalKey('PAUSE/RESUME');
      expect(game.playState, GamePlayState.paused);
      game.handlePhysicalKey('OK');
      expect(game.playState, GamePlayState.playing);
      expect(GameAudio.playHistory, isNot(contains(GameAudio.boxRelease)));

      // 3. Menu: OK interacts with menu, must NOT play box_release.wav
      game.handlePhysicalKey('MENU');
      expect(game.playState, GamePlayState.menu);
      game.handlePhysicalKey('OK');
      expect(GameAudio.playHistory, isNot(contains(GameAudio.boxRelease)));
      game.handlePhysicalKey('MENU'); // Close menu

      // 4. GameOver: OK restarts game, must NOT play box_release.wav
      game.endGame();
      expect(game.playState, GamePlayState.gameOver);
      GameAudio.resetMetrics(); // clear game over sound
      game.handlePhysicalKey('OK');
      expect(game.playState, GamePlayState.playing);
      expect(GameAudio.playHistory, isNot(contains(GameAudio.boxRelease)));
    },
  );

  testWidgets(
    'SFX: box_land.wav plays exactly once when box lands and is guarded against duplicate triggers',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.startGame();

      GameAudio.resetMetrics();
      final box = game.currentBox!;

      // Simulate landing
      box.isDropping = false;
      box.hasLanded = true;
      game.boxLanded();

      expect(GameAudio.lastPlayedSound, GameAudio.boxLand);
      expect(
        GameAudio.playHistory.where((s) => s == GameAudio.boxLand).length,
        1,
      );

      // Subsequent duplicate callback for the same box must NOT play landing sound again
      game.boxLanded();
      expect(
        GameAudio.playHistory.where((s) => s == GameAudio.boxLand).length,
        1,
      );
    },
  );

  testWidgets(
    'SFX: game_over.wav plays on Game Over and cannot trigger multiple times',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.highScore = 10;
      game.score = 3; // Not a new high score
      game.startGame();

      GameAudio.resetMetrics();

      // Trigger Game Over
      game.endGame();

      expect(game.gameOver, isTrue);
      expect(game.isNewHighScore, isFalse);
      expect(GameAudio.playHistory, contains(GameAudio.gameOver));
      expect(GameAudio.playHistory, isNot(contains(GameAudio.highScore)));
      expect(
        GameAudio.playHistory.where((s) => s == GameAudio.gameOver).length,
        1,
      );

      // Second endGame call must be guarded by if (gameOver) return;
      game.endGame();
      expect(
        GameAudio.playHistory.where((s) => s == GameAudio.gameOver).length,
        1,
      );
    },
  );

  testWidgets(
    'SFX: high_score.wav plays only when score actually achieves a new high score',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.highScore = 2;
      game.score = 5; // Beat high score!
      game.startGame();
      game.score = 5; // Ensure score after startGame reset

      GameAudio.resetMetrics();

      game.endGame();

      expect(game.gameOver, isTrue);
      expect(game.isNewHighScore, isTrue);
      expect(GameAudio.playHistory, contains(GameAudio.highScore));
      expect(GameAudio.playHistory, contains(GameAudio.gameOver));
      expect(
        GameAudio.playHistory.where((s) => s == GameAudio.highScore).length,
        1,
      );
    },
  );

  testWidgets(
    'SFX: None of the SFX play when soundEnabled is OFF',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.startGame();

      // Toggle sound OFF
      await game.toggleSound();
      expect(game.soundEnabled, isFalse);
      expect(GameAudio.soundEnabled, isFalse);

      GameAudio.resetMetrics();

      // Try triggering all 4 sound events
      GameAudio.playBoxRelease();
      GameAudio.playBoxLand();
      GameAudio.playGameOver();
      GameAudio.playHighScore();

      expect(GameAudio.playCount, 0);
      expect(GameAudio.playHistory, isEmpty);
      expect(GameAudio.lastPlayedSound, isNull);
    },
  );

  testWidgets(
    'SFX: Restarting the game does not accidentally trigger any SFX',
    (WidgetTester tester) async {
      final game = MyGame();
      await game.onLoad();
      game.startGame();

      GameAudio.resetMetrics();

      // Restart game
      game.restartGame();
      expect(GameAudio.playCount, 0);

      // Power key to start screen
      game.handlePhysicalKey('END');
      expect(GameAudio.playCount, 0);

      // Start game from start screen
      game.handlePhysicalKey('OK');
      expect(GameAudio.playCount, 0);
      expect(GameAudio.playHistory, isEmpty);
    },
  );

  testWidgets(
    'BGM: starts on game start, stops on Game Over, restarts on new game, respects toggle',
    (WidgetTester tester) async {
      GameAudio.stopBgm();
      GameAudio.soundEnabled = true;

      final game = MyGame();
      await game.onLoad();

      // 1. Must NOT play on StartScreen / initial load
      expect(GameAudio.isBgmPlaying, isFalse);

      // 2. Starts when game session begins
      game.startGame();
      expect(game.playState, GamePlayState.playing);
      expect(GameAudio.isBgmPlaying, isTrue);

      // 3. Toggling sound OFF while playing stops BGM
      await game.toggleSound();
      expect(game.soundEnabled, isFalse);
      expect(GameAudio.isBgmPlaying, isFalse);

      // 4. Toggling sound back ON while playing resumes BGM
      await game.toggleSound();
      expect(game.soundEnabled, isTrue);
      expect(GameAudio.isBgmPlaying, isTrue);

      // 5. Game Over immediately stops BGM
      game.endGame();
      expect(game.gameOver, isTrue);
      expect(GameAudio.isBgmPlaying, isFalse);

      // 6. Toggling sound ON while in Game Over must NOT play BGM
      await game.toggleSound(); // OFF
      await game.toggleSound(); // ON
      expect(game.soundEnabled, isTrue);
      expect(GameAudio.isBgmPlaying, isFalse);

      // 7. Restarting game starts BGM again
      game.restartGame();
      expect(game.playState, GamePlayState.playing);
      expect(GameAudio.isBgmPlaying, isTrue);

      // 8. Returning to StartScreen stops BGM
      game.resetToStartScreen();
      expect(game.playState, GamePlayState.startScreen);
      expect(GameAudio.isBgmPlaying, isFalse);

      // 9. Removing/disposing component ensures BGM is stopped
      game.onRemove();
      expect(GameAudio.isBgmPlaying, isFalse);
    },
  );

  testWidgets(
    'BGM: Does not play when game session starts with sound preference disabled',
    (WidgetTester tester) async {
      GameAudio.stopBgm();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sound_enabled', false);

      final game = MyGame();
      await game.onLoad();

      // Start game while sound is disabled
      game.startGame();
      expect(game.soundEnabled, isFalse);
      expect(GameAudio.isBgmPlaying, isFalse);

      // Restore setting for other tests
      await prefs.setBool('sound_enabled', true);
      GameAudio.soundEnabled = true;
    },
  );

  testWidgets(
    'BGM: starts immediately on the VERY FIRST launch when starting game from StartScreen',
    (WidgetTester tester) async {
      GameAudio.stopBgm();
      GameAudio.soundEnabled = true;

      await tester.pumpWidget(const RetroStackApp());
      await tester.pump(const Duration(milliseconds: 100));

      // Initially on StartScreen: BGM must NOT play
      expect(find.byType(StartScreen), findsOneWidget);
      expect(GameAudio.isBgmPlaying, isFalse);

      // Tap physical OK to start the very first game
      await tester.tap(find.text('OK'));
      await tester.pump();

      // StartScreen dismissed and BGM starts immediately on the very first start
      expect(find.byType(StartScreen), findsNothing);
      expect(GameAudio.isBgmPlaying, isTrue);
    },
  );

  testWidgets(
    'SFX: Play events continue working reliably across multiple Game Over -> Restart cycles',
    (WidgetTester tester) async {
      GameAudio.resetMetrics();
      GameAudio.soundEnabled = true;

      final game = MyGame();
      await game.onLoad();

      // Cycle 1: Start Game -> Drop -> Land -> Game Over
      game.startGame();
      expect(game.currentBox, isNotNull);
      game.handlePhysicalKey('OK'); // Drop
      expect(GameAudio.lastPlayedSound, GameAudio.boxRelease);

      GameAudio.playBoxLand();
      expect(GameAudio.lastPlayedSound, GameAudio.boxLand);

      game.endGame();
      expect(GameAudio.lastPlayedSound, GameAudio.gameOver);
      expect(game.gameOver, isTrue);

      // Cycle 2: Restart Game -> Drop -> Land -> Game Over
      game.restartGame();
      expect(game.gameOver, isFalse);
      expect(game.currentBox, isNotNull);

      game.handlePhysicalKey('OK'); // Drop in Game 2
      expect(GameAudio.lastPlayedSound, GameAudio.boxRelease);

      GameAudio.playBoxLand();
      expect(GameAudio.lastPlayedSound, GameAudio.boxLand);

      game.endGame();
      expect(GameAudio.lastPlayedSound, GameAudio.gameOver);

      // Cycle 3: Restart Game again -> Drop -> Land
      game.restartGame();
      expect(game.gameOver, isFalse);
      expect(game.currentBox, isNotNull);

      game.handlePhysicalKey('OK'); // Drop in Game 3
      expect(GameAudio.lastPlayedSound, GameAudio.boxRelease);

      GameAudio.playBoxLand();
      expect(GameAudio.lastPlayedSound, GameAudio.boxLand);

      // Verify all sounds across all 3 cycles played without disruption
      final releaseEvents = GameAudio.playHistory.where((s) => s == GameAudio.boxRelease).length;
      final landEvents = GameAudio.playHistory.where((s) => s == GameAudio.boxLand).length;
      final gameOverEvents = GameAudio.playHistory.where((s) => s == GameAudio.gameOver).length;

      expect(releaseEvents, 3);
      expect(landEvents, 3);
      expect(gameOverEvents, 2);
    },
  );

  testWidgets(
    'PhoneControls: Scales uniformly with RetroDimensions.controlsScale and dispatches input callbacks',
    (WidgetTester tester) async {
      final pressedKeys = <String>[];

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: PhoneControls(
            onKeyPressed: (key) => pressedKeys.add(key),
            highlightOk: false,
          ),
        ),
      );
      await tester.pump();

      // 1. Verify PhoneControls is rendered
      expect(find.byType(PhoneControls), findsOneWidget);

      // 2. Verify Transform.scale is configured with RetroDimensions.controlsScale
      final transformFinder = find.descendant(
        of: find.byType(PhoneControls),
        matching: find.byType(Transform),
      );
      expect(transformFinder, findsWidgets);
      final transformWidget = tester.widget<Transform>(transformFinder.first);
      expect(transformWidget.transform.getMaxScaleOnAxis(), closeTo(RetroDimensions.controlsScale, 0.001));

      // 3. Verify physical keys inside scaled PhoneControls respond to taps
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

      await tester.tap(find.text('OK'));
      await tester.pump();
      expect(pressedKeys, contains('OK'));
    },
  );

  testWidgets(
    'PhoneShell scales to fill vertical space proportionally maintaining exact aspect ratio',
    (WidgetTester tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Test 1: On a tall screen (Size(600, 1000)), height reaches full phoneScaleFactor (94%)
      // and width is scaled proportionally by aspectRatio.
      tester.view.physicalSize = const Size(600, 1000);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: PhoneShell(),
        ),
      );
      await tester.pump();

      final tallSizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(PhoneShell),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(tallSizedBox.height, closeTo(1000.0 * RetroDimensions.phoneScaleFactor, 0.01));
      expect(tallSizedBox.width, closeTo(1000.0 * RetroDimensions.phoneScaleFactor * RetroDimensions.aspectRatio, 0.01));
      expect(tallSizedBox.width! / tallSizedBox.height!, closeTo(RetroDimensions.aspectRatio, 0.001));

      // Test 2: On an ultra-narrow screen (Size(320, 800)), width clamp activates
      // (w > availableWidth * 0.94) to prevent horizontal overflow while preserving exact aspect ratio.
      tester.view.physicalSize = const Size(320, 800);

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: PhoneShell(),
        ),
      );
      await tester.pump();

      final narrowSizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(PhoneShell),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(narrowSizedBox.width, closeTo(320.0 * RetroDimensions.phoneScaleFactor, 0.01));
      expect(narrowSizedBox.width! / narrowSizedBox.height!, closeTo(RetroDimensions.aspectRatio, 0.001));
      expect(narrowSizedBox.height, closeTo((320.0 * RetroDimensions.phoneScaleFactor) / RetroDimensions.aspectRatio, 0.01));
    },
  );
}

