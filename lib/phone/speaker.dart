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
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Recessed earpiece slot
        Container(
          width: RetroDimensions.speakerWidth,
          height: RetroDimensions.speakerHeight + 1.0,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: RetroColors.speakerHole,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: RetroColors.speakerHighlight,
              width: 0.8,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(0.0, 1.0),
                blurRadius: 1.0,
              ),
            ],
          ),
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
                    color: RetroColors.faceplateMid,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        // Subtle front sensor / camera dot
        Container(
          width: 5.0,
          height: 5.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: RetroColors.speakerSensor,
            border: Border.all(
              color: RetroColors.speakerHighlight.withValues(alpha: 0.6),
              width: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
