import 'package:flutter/widgets.dart';

import '../../theme/dimensions.dart';
import '../../theme/colors.dart';

class PhoneChin extends StatelessWidget {
  const PhoneChin({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      height: RetroDimensions.sliderChinHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Subtle slider seam / grip lip
          Container(
            width: 54.0,
            height: 3.0,
            decoration: BoxDecoration(
              color: RetroColors.phoneBodyDark,
              borderRadius: BorderRadius.circular(1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x44FFFFFF),
                  offset: Offset(0.0, 1.0),
                  blurRadius: 0.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
