import 'package:flutter/widgets.dart';
import '../game/my_game.dart';
import '../theme/colors.dart';
import 'game_menu_back_button.dart';
import 'game_menu_item.dart';

/// Retro late-2000s feature phone popup options menu overlay.
///
/// Displayed inside the LCD viewport, presenting:
/// - Sound: ON / OFF (interactive toggle, synced with global state)
/// - Difficulty: NORMAL
/// - High Score: read directly from [MyGame.highScore]
/// - Close / Resume action
///
/// Supports navigation via physical D-pad (`UP`, `DOWN`, `OK`) and direct touch.
class GameMenu extends StatefulWidget {
  final MyGame game;

  const GameMenu({super.key, required this.game});

  @override
  State<GameMenu> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  int _selectedIndex = 0;
  static const int _itemCount = 4;

  @override
  void initState() {
    super.initState();
    widget.game.keyEventNotifier.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    widget.game.keyEventNotifier.removeListener(_handleKeyEvent);
    super.dispose();
  }

  void _handleKeyEvent() {
    final key = widget.game.keyEventNotifier.value;
    if (!mounted || key == null) return;

    if (key == 'UP') {
      setState(() {
        _selectedIndex = (_selectedIndex - 1 + _itemCount) % _itemCount;
      });
    } else if (key == 'DOWN') {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % _itemCount;
      });
    } else if (key == 'OK') {
      _activateCurrentItem();
    } else if (key == 'MENU' || key == 'PAUSE/RESUME') {
      widget.game.toggleMenu();
    }
  }

  void _activateCurrentItem() {
    switch (_selectedIndex) {
      case 0:
        widget.game.toggleSound();
        break;
      case 1:
        // Difficulty is display-only for now
        break;
      case 2:
        // High score is display-only
        break;
      case 3:
        widget.game.toggleMenu();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RetroColors.lcdDarkest.withValues(alpha: 0.50),
      alignment: Alignment.center,
      child: Container(
        width: 180.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: RetroColors.lcdLight,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: RetroColors.lcdDarkest, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: RetroColors.lcdDarkest.withValues(alpha: 0.35),
              offset: const Offset(2.0, 2.0),
              blurRadius: 0.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Menu Title Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'OPTIONS',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: RetroColors.lcdDarkest,
                    fontFamily: 'monospace',
                    height: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6.0),

            // Pixel Divider
            Container(height: 1.5, color: RetroColors.lcdDark),
            const SizedBox(height: 8.0),

            // Item 0: Sound Toggle
            ValueListenableBuilder<bool>(
              valueListenable: widget.game.soundEnabledNotifier,
              builder: (context, soundEnabled, _) {
                return GameMenuItem(
                  index: 0,
                  selectedIndex: _selectedIndex,
                  label: 'Sound',
                  value: soundEnabled ? 'ON' : 'OFF',
                  valueColor: soundEnabled
                      ? (_selectedIndex == 0
                            ? RetroColors.lcdLight
                            : RetroColors.lcdDarkest)
                      : (_selectedIndex == 0
                            ? const Color(0xFFFF8A80)
                            : const Color(0xFFC62828)),
                  onTap: () {
                    setState(() => _selectedIndex = 0);
                    widget.game.toggleSound();
                  },
                );
              },
            ),
            const SizedBox(height: 4.0),

            // Item 1: Difficulty
            GameMenuItem(
              index: 1,
              selectedIndex: _selectedIndex,
              label: 'Difficulty',
              value: 'NORMAL',
              onTap: () {
                setState(() => _selectedIndex = 1);
              },
            ),
            const SizedBox(height: 4.0),

            // Item 2: High Score
            GameMenuItem(
              index: 2,
              selectedIndex: _selectedIndex,
              label: 'High Score',
              value: '${widget.game.highScore}',
              onTap: () {
                setState(() => _selectedIndex = 2);
              },
            ),
            const SizedBox(height: 10.0),

            // Item 3: Close / Back Button
            GameMenuBackButton(
              selectedIndex: _selectedIndex,
              index: 3,
              onTap: () {
                setState(() => _selectedIndex = 3);
                widget.game.toggleMenu();
              },
            ),
          ],
        ),
      ),
    );
  }
}
