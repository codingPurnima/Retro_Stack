import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';

/// Navigation D-Pad widget for the feature phone shell (Section 18).
///
/// Features directional controls (UP, DOWN, LEFT, RIGHT) and a center SELECT key.
class NavigationKey extends StatefulWidget {
  /// Callback invoked when any direction or the center button is pressed.
  final ValueChanged<String>? onKeyPressed;

  /// Whether the center OK button should display a subtle instructional emphasis.
  final bool highlightOk;

  const NavigationKey({
    super.key,
    this.onKeyPressed,
    this.highlightOk = false,
  });

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
            child: _NavDirectionTouch(
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
            child: _NavDirectionTouch(
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
            child: _NavDirectionTouch(
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
            child: _NavDirectionTouch(
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
          _CenterSelectButton(
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

class _NavDirectionTouch extends StatelessWidget {
  final String label;
  final bool isPressed;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final Widget child;

  const _NavDirectionTouch({
    required this.label,
    required this.isPressed,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapCancel,
      child: AnimatedScale(
        duration: RetroDimensions.keyPressDuration,
        scale: isPressed ? 0.85 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: child,
        ),
      ),
    );
  }
}

class _CenterSelectButton extends StatefulWidget {
  final bool isPressed;
  final bool isHighlighted;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;

  const _CenterSelectButton({
    required this.isPressed,
    this.isHighlighted = false,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
  });

  @override
  State<_CenterSelectButton> createState() => _CenterSelectButtonState();
}

class _CenterSelectButtonState extends State<_CenterSelectButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.isHighlighted) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _CenterSelectButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted != oldWidget.isHighlighted) {
      if (widget.isHighlighted) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topOffset = widget.isPressed ? 1.5 : 0.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => widget.onTapDown(),
      onTapUp: (_) => widget.onTapUp(),
      onTapCancel: widget.onTapCancel,
      child: SizedBox(
        width: RetroDimensions.navCenterButtonSize,
        height: RetroDimensions.navCenterButtonSize + 2.0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shadow
            Positioned(
              top: 2.0,
              child: Container(
                width: RetroDimensions.navCenterButtonSize,
                height: RetroDimensions.navCenterButtonSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: RetroColors.keyShadow,
                ),
              ),
            ),
            // Button surface
            AnimatedPositioned(
              duration: RetroDimensions.keyPressDuration,
              curve: Curves.easeOutQuad,
              top: topOffset,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, _) {
                  final Color borderColor;
                  if (widget.isPressed) {
                    borderColor = RetroColors.chromeShadow;
                  } else if (widget.isHighlighted) {
                    borderColor = Color.lerp(
                      RetroColors.chromeHighlight,
                      RetroColors.buttonIconRed,
                      _pulseAnimation.value,
                    )!;
                  } else {
                    borderColor = RetroColors.chromeHighlight;
                  }

                  return Container(
                    width: RetroDimensions.navCenterButtonSize,
                    height: RetroDimensions.navCenterButtonSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(
                        color: borderColor,
                        width: widget.isHighlighted ? 1.4 : 1.0,
                      ),
                      gradient: RadialGradient(
                        center: const Alignment(-0.2, -0.3),
                        radius: 0.8,
                        colors: widget.isPressed
                            ? [
                                RetroColors.keyPressedSurface,
                                RetroColors.keyShadow,
                              ]
                            : [
                                RetroColors.phoneBodyLight,
                                RetroColors.phoneBodyMid,
                                RetroColors.phoneBodyDark,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.isHighlighted
                              ? RetroColors.buttonIconRed.withValues(
                                  alpha: 0.3 * _pulseAnimation.value,
                                )
                              : RetroColors.keyShadow,
                          offset: Offset(0.0, widget.isPressed ? 0.5 : 1.8),
                          blurRadius: widget.isHighlighted
                              ? 3.0 * _pulseAnimation.value + 1.0
                              : (widget.isPressed ? 0.5 : 2.0),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 8.0,
                          color: RetroColors.navArrowColor,
                          height: 1.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
