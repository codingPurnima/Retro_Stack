/// Centralized geometric dimensions and layout metrics for Retro Stack.
///
/// Values adhere strictly to Section 4, 5, 8, 19, 31, and 32 of `docs/design.md`.
abstract final class RetroDimensions {
  // ---------------------------------------------------------------------------
  // Reference Design Space (Section 4, 32)
  // ---------------------------------------------------------------------------

  /// Logical design width in logical pixels matching phone body width.
  static const double designWidth = 292.0;

  /// Logical design height in logical pixels matching phone body height.
  static const double designHeight = 540.0;

  /// Logical aspect ratio of the phone shell (~0.54:1).
  static const double aspectRatio = designWidth / designHeight;

  /// Tunable scale factor determining the fraction of available vertical space
  /// that the complete phone frame should occupy (default: 0.94 = 94%).
  /// Leaves balanced top/bottom spacing while maximizing physical screen usage.
  static const double phoneScaleFactor = 0.87;

  // ---------------------------------------------------------------------------
  // Phone Body (Section 5)
  // ---------------------------------------------------------------------------

  /// Width of the physical phone body.
  static const double phoneBodyWidth = 292.0;

  /// Height of the physical phone body.
  static const double phoneBodyHeight = 540.0;

  /// Outer corner radius of the molded phone body.
  static const double phoneCornerRadius = 28.0;

  /// Outer border bevel width of the phone body.
  static const double phoneBorderWidth = 2.0;

  /// Ambient drop shadow blur radius under the phone.
  static const double phoneShadowBlur = 18.0;

  /// Ambient drop shadow vertical offset.
  static const double phoneShadowOffsetY = 6.0;

  /// Width of the chrome specular rim around the phone body.
  static const double phoneChromeRimWidth = 2.5;

  /// Corner radius of the dark front faceplate panel.
  static const double faceplateCornerRadius = 22.0;

  /// Horizontal inset padding for the glossy dark faceplate.
  static const double faceplateMarginHorizontal = 10.0;

  /// Top margin inset for the dark faceplate.
  static const double faceplateMarginTop = 8.0;

  /// Exposed bottom slider chin height.
  static const double sliderChinHeight = 48.0;

  // ---------------------------------------------------------------------------
  // Speaker Section (Section 7)
  // ---------------------------------------------------------------------------

  /// Top padding from phone top edge to speaker.
  static const double phoneTopPadding = 14.0;

  /// Width of the speaker grille area.
  static const double speakerWidth = 52.0;

  /// Height of the speaker grille area.
  static const double speakerHeight = 6.0;

  /// Radius of each speaker hole.
  static const double speakerHoleRadius = 1.8;

  /// Number of speaker grille openings.
  static const int speakerHoleCount = 6;

  /// Spacing between speaker grille openings.
  static const double speakerHoleSpacing = 4.0;

  /// Margin between speaker and LCD frame.
  static const double speakerMarginBottom = 12.0;

  // ---------------------------------------------------------------------------
  // LCD Screen & Bezel Frame (Section 8)
  // ---------------------------------------------------------------------------

  /// Overall outer width of the dark LCD bezel frame (~73% of phone width).
  static const double lcdFrameWidth = 230.0;

  /// Overall outer height of the dark LCD bezel frame.
  static const double lcdFrameHeight = 350.0;

  /// Outer corner radius of the screen bezel.
  static const double lcdBezelCornerRadius = 8.0;

  /// Inset padding inside the bezel framing the inner LCD glass.
  static const double lcdBezelPadding = 4.0;

  /// Inner corner radius of the LCD glass display.
  static const double lcdInnerCornerRadius = 4.0;

  /// Inner border thickness outlining the active LCD screen.
  static const double lcdInnerBorderWidth = 1.5;

  /// Space below LCD frame before soft keys row.
  static const double lcdMarginBottom = 12.0;

  // ---------------------------------------------------------------------------
  // Soft Keys (Section 17)
  // ---------------------------------------------------------------------------

  /// Width of the soft keys row matching LCD width.
  static const double softKeysRowWidth = 220.0;

  /// Width of an individual soft key capsule.
  static const double softKeyWidth = 52.0;

  /// Height of an individual soft key capsule.
  static const double softKeyHeight = 16.0;

  /// Corner radius of soft key capsule.
  static const double softKeyCornerRadius = 8.0;

  /// Font size for printed soft key labels.
  static const double softKeyFontSize = 8.0;

  /// Margin below soft keys row before navigation D-pad.
  static const double softKeyMarginBottom = 10.0;

  // ---------------------------------------------------------------------------
  // Navigation D-Pad Control (Section 18)
  // ---------------------------------------------------------------------------

  /// Diameter/size of the navigation control circle.
  static const double navPadSize = 64.0;

  /// Diameter of the center action button.
  static const double navCenterButtonSize = 24.0;

  /// Corner radius of the circular nav pad.
  static const double navPadCornerRadius = 32.0;

  /// Margin below navigation control before numeric keypad.
  static const double navPadMarginBottom = 10.0;

  /// Size of directional arrows in navigation control.
  static const double navArrowSize = 10.0;

  /// Scale factor for the physical phone controls / keypad region (Section 18).
  /// Defaults to 1.0 (original 1:1 design proportions) since the complete phone frame
  /// is now scaled up to occupy the available vertical space.
  static const double controlsScale = 1.0;

  // ---------------------------------------------------------------------------
  // Numeric Keypad & Keys (Sections 19, 20, 21)
  // ---------------------------------------------------------------------------

  /// Overall width of the 3x4 numeric keypad.
  static const double keypadWidth = 224.0;

  /// Width of each physical numeric key.
  static const double keyWidth = 64.0;

  /// Height of each physical numeric key.
  static const double keyHeight = 32.0;

  /// Corner radius of each physical key.
  static const double keyCornerRadius = 7.0;

  /// Horizontal spacing between keys in a row.
  static const double keySpacingHorizontal = 10.0;

  /// Vertical spacing between key rows.
  static const double keySpacingVertical = 6.0;

  /// Physical 3D raised depth of unpressed keys.
  static const double keyRaisedDepth = 3.0;

  /// Downward vertical translation when key is pressed.
  static const double keyPressedTranslation = 2.0;

  /// Primary numeric label font size.
  static const double keyNumberFontSize = 14.5;

  /// Secondary alphanumeric label font size.
  static const double keySubLabelFontSize = 7.5;

  /// Hit-test touch target expansion padding around keys.
  static const double keyHitPadding = 4.0;

  /// Key press/release tactile animation duration (Section 21).
  static const Duration keyPressDuration = Duration(milliseconds: 70);

  // ---------------------------------------------------------------------------
  // LCD Standby / Preview Typography & Metrics
  // ---------------------------------------------------------------------------

  /// Font size for LCD standby title.
  static const double lcdPlaceholderTitleSize = 13.0;

  /// Font size for LCD standby subtitle/status.
  static const double lcdPlaceholderSubSize = 8.5;

  /// Font size for LCD status bar symbols.
  static const double lcdStatusBarFontSize = 7.5;
}
