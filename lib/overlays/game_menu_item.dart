import 'package:flutter/widgets.dart';

import '../theme/colors.dart';

/// A single row in the retro game options menu.
class GameMenuItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback onTap;

  const GameMenuItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.label,
    required this.value,
    this.valueColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? RetroColors.lcdDarkest : const Color(0x00000000),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: isSelected
                      ? RetroColors.lcdLight
                      : RetroColors.lcdDarkest,
                  fontFamily: 'monospace',
                  height: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 6.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                color:
                    valueColor ??
                    (isSelected
                        ? RetroColors.lcdLight
                        : RetroColors.lcdDarkest),
                fontFamily: 'monospace',
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
