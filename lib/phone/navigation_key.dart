import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import 'center_select_button.dart';
import 'nav_direction_touch.dart';

/// Navigation D-Pad widget for the feature phone shell (Section 18).
///
/// Features directional controls (UP, DOWN, LEFT, RIGHT) and a center SELECT key.
class NavigationKey extends StatefulWidget {
  /// Callback invoked when any direction or the center button is pressed.
  final ValueChanged<String>? onKeyPressed;

  /// Whether the center OK button should display a subtle instructional emphasis.
  final bool highlightOk;

  const NavigationKey({super.key, this.onKeyPressed, this.highlightOk = false});

  @override
  State<NavigationKey> createState() => _NavigationKeyState();
}

class _NavigationKeyState extends State<NavigationKey> {
  String? _activeKey;

  void _handleTapDown(String key) {
    setState(() => _activeKey = key);
  }

  void _handleTapUp(String key) {
    if (_activeKey == key) {
      setState(() => _activeKey = null);
      widget.onKeyPressed?.call(key);
    }
  }

  void _handleTapCancel() {
    if (_activeKey != null) {
      setState(() => _activeKey = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: RetroDimensions.navPadSize,
      height: RetroDimensions.navPadSize + 3.0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Base shadow rim
          Positioned(
            top: 2.5,
            child: Container(
              width: RetroDimensions.navPadSize,
              height: RetroDimensions.navPadSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: RetroColors.keyShadow,
              ),
            ),
          ),
          // Directional squircle body with chrome metallic bevel
          Positioned(
            top: 0.0,
            child: Container(
              width: RetroDimensions.navPadSize,
              height: RetroDimensions.navPadSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                border: Border.all(
                  color: RetroColors.chromeHighlight,
                  width: 1.8,
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    RetroColors.chromeHighlight,
                    RetroColors.chromeMid,
                    RetroColors.chromeShadow,
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: RetroColors.keyShadow,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(2.2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: RetroColors.navPadSurface,
                  gradient: const RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      RetroColors.buttonHighlight,
                      RetroColors.navPadSurface,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Directional arrows
          // UP
          Positioned(
            top: 4.0,
            child: NavDirectionTouch(
              label: 'UP',
              isPressed: _activeKey == 'UP',
              onTapDown: () => _handleTapDown('UP'),
              onTapUp: () => _handleTapUp('UP'),
              onTapCancel: _handleTapCancel,
              child: const Text(
                '▲',
                style: TextStyle(
                  fontSize: RetroDimensions.navArrowSize,
                  color: RetroColors.navArrowColor,
                  height: 1.0,
                ),
              ),
            ),
          ),
          // DOWN
          Positioned(
            bottom: 6.0,
            child: NavDirectionTouch(
              label: 'DOWN',
              isPressed: _activeKey == 'DOWN',
              onTapDown: () => _handleTapDown('DOWN'),
              onTapUp: () => _handleTapUp('DOWN'),
              onTapCancel: _handleTapCancel,
              child: const Text(
                '▼',
                style: TextStyle(
                  fontSize: RetroDimensions.navArrowSize,
                  color: RetroColors.navArrowColor,
                  height: 1.0,
                ),
              ),
            ),
          ),
          // LEFT
          Positioned(
            left: 5.0,
            child: NavDirectionTouch(
              label: 'LEFT',
              isPressed: _activeKey == 'LEFT',
              onTapDown: () => _handleTapDown('LEFT'),
              onTapUp: () => _handleTapUp('LEFT'),
              onTapCancel: _handleTapCancel,
              child: const Text(
                '◀',
                style: TextStyle(
                  fontSize: RetroDimensions.navArrowSize,
                  color: RetroColors.navArrowColor,
                  height: 1.0,
                ),
              ),
            ),
          ),
          // RIGHT
          Positioned(
            right: 5.0,
            child: NavDirectionTouch(
              label: 'RIGHT',
              isPressed: _activeKey == 'RIGHT',
              onTapDown: () => _handleTapDown('RIGHT'),
              onTapUp: () => _handleTapUp('RIGHT'),
              onTapCancel: _handleTapCancel,
              child: const Text(
                '▶',
                style: TextStyle(
                  fontSize: RetroDimensions.navArrowSize,
                  color: RetroColors.navArrowColor,
                  height: 1.0,
                ),
              ),
            ),
          ),
          // CENTER Select / Action Button
          CenterSelectButton(
            isPressed: _activeKey == 'OK',
            isHighlighted: widget.highlightOk,
            onTapDown: () => _handleTapDown('OK'),
            onTapUp: () => _handleTapUp('OK'),
            onTapCancel: _handleTapCancel,
          ),
        ],
      ),
    );
  }
}
