import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';

/// Speaker grille widget for the feature phone shell (Section 7).
///
/// Understated horizontal row of recessed circular openings.
/// Responsible only for the physical speaker grille per requirements.
class PhoneSpeaker extends StatelessWidget {
  const PhoneSpeaker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: RetroDimensions.speakerWidth,
      height: RetroDimensions.speakerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          RetroDimensions.speakerHoleCount,
          (index) {
            final isLast = index == RetroDimensions.speakerHoleCount - 1;
            return Container(
              margin: EdgeInsets.only(
                right: isLast ? 0.0 : RetroDimensions.speakerHoleSpacing,
              ),
              width: RetroDimensions.speakerHoleRadius * 2,
              height: RetroDimensions.speakerHoleRadius * 2,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: RetroColors.speakerHole,
                boxShadow: [
                  BoxShadow(
                    color: RetroColors.speakerHighlight,
                    offset: Offset(0.0, 0.5),
                    blurRadius: 0.5,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
