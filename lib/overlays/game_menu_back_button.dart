import 'package:flutter/widgets.dart';

import '../theme/colors.dart';

/// Back button for the retro options menu.
class GameMenuBackButton extends StatelessWidget {
  final int selectedIndex;
  final int index;
  final VoidCallback onTap;

  const GameMenuBackButton({
    super.key,
    required this.selectedIndex,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? RetroColors.lcdDarkest : const Color(0x00000000),
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(color: RetroColors.lcdDarkest, width: 1.5),
        ),
        child: Text(
          'BACK',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
            color: isSelected ? RetroColors.lcdLight : RetroColors.lcdDarkest,
            fontFamily: 'monospace',
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
