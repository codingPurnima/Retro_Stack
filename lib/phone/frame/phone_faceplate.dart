import 'package:flutter/widgets.dart';

import '../../theme/colors.dart';
import '../../theme/dimensions.dart';
import '../lcd_screen.dart';
import '../speaker.dart';
import 'phone_controls.dart';

class PhoneFaceplate extends StatelessWidget {
  final Widget? lcdChild;
  final ValueChanged<String>? onKeyPressed;
  final bool highlightOk;

  const PhoneFaceplate({
    super.key,
    this.lcdChild,
    this.onKeyPressed,
    this.highlightOk = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: RetroDimensions.faceplateMarginTop,
      left: RetroDimensions.faceplateMarginHorizontal,
      right: RetroDimensions.faceplateMarginHorizontal,
      bottom: RetroDimensions.sliderChinHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22.0),
            topRight: Radius.circular(22.0),
            bottomLeft: Radius.circular(28.0),
            bottomRight: Radius.circular(28.0),
          ),
          border: Border.all(color: RetroColors.faceplateBevel, width: 1.2),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [RetroColors.faceplateMid, RetroColors.faceplateDark],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x88000000),
              offset: Offset(0.0, 2.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 6.0),

            // Speaker grille & sensor (Section 7)
            const PhoneSpeaker(),
            const SizedBox(height: 6.0),

            // LCD Screen & Bezel (Section 8)
            LcdScreen(child: lcdChild),
            const SizedBox(height: 8.0),

            // Control Section: Flanking button columns + Center D-pad
            PhoneControls(onKeyPressed: onKeyPressed, highlightOk: highlightOk),
          ],
        ),
      ),
    );
  }
}
