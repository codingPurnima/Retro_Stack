import 'package:flutter/widgets.dart';
import 'package:retro_stack_frontend/phone/frame/phone_control_column.dart';
import 'package:retro_stack_frontend/phone/navigation_key.dart';
import 'package:retro_stack_frontend/theme/dimensions.dart';

class PhoneControls extends StatelessWidget {
  final ValueChanged<String>? onKeyPressed;
  final bool highlightOk;

  const PhoneControls({super.key, this.onKeyPressed, this.highlightOk = false});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: RetroDimensions.controlsScale,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Flanking Buttons: Menu (top) + Sound (bottom)
            PhoneControlColumn(isLeftSide: true, onKeyPressed: onKeyPressed),

            const SizedBox(width: 10.0),

            // Central D-pad
            NavigationKey(onKeyPressed: onKeyPressed, highlightOk: highlightOk),

            const SizedBox(width: 10.0),

            // Right Flanking Buttons: Pause/Resume (top) + End/Power (bottom)
            PhoneControlColumn(isLeftSide: false, onKeyPressed: onKeyPressed),
          ],
        ),
      ),
    );
  }
}
