import 'package:flutter/widgets.dart';

import '../theme/colors.dart';

/// Subtle dotted pixel divider.
class PixelDivider extends StatelessWidget {
  const PixelDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: 120.0, height: 2.0, color: RetroColors.lcdDark);
  }
}
