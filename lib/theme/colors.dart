import 'package:flutter/painting.dart';

/// Centralized color palette for the Retro Stack feature phone and LCD screen.
///
/// Values adhere strictly to Section 6 and Section 9 of `docs/design.md`.
abstract final class RetroColors {
  // ---------------------------------------------------------------------------
  // Ambient & Phone Body Palette (Section 6)
  // ---------------------------------------------------------------------------

  /// Deep black background for the surrounding ambient space.
  static const Color deepBlack = Color(0xFF111111);

  /// Dark outer perimeter border of the phone body.
  static const Color phoneOuter = Color(0xFF303030);

  /// Main matte plastic surface of the phone body.
  static const Color phoneMain = Color(0xFF3A3A3A);

  /// Top/left highlight bevel on the molded phone body.
  static const Color phoneHighlight = Color(0xFF4A4A4A);

  /// Bottom/right shadow bevel and ambient phone drop shadow.
  static const Color phoneShadow = Color(0xFF202020);

  /// Subtle top-to-bottom plastic gradient accent.
  static const Color phoneGradientLight = Color(0xFF424242);
  static const Color phoneGradientDark = Color(0xFF323232);

  // ---------------------------------------------------------------------------
  // Speaker Palette
  // ---------------------------------------------------------------------------

  /// Recessed speaker slot interior color.
  static const Color speakerHole = Color(0xFF161616);

  /// Inset highlight on the bottom edge of speaker openings.
  static const Color speakerHighlight = Color(0xFF454545);

  // ---------------------------------------------------------------------------
  // LCD Screen Bezel Palette (Section 8)
  // ---------------------------------------------------------------------------

  /// Outer dark plastic bezel surrounding the LCD display.
  static const Color bezelOuter = Color(0xFF222422);

  /// Highlight line on the upper and left inner bezel edges.
  static const Color bezelHighlight = Color(0xFF383C38);

  /// Deep inner recessed rim immediately holding the LCD glass.
  static const Color bezelInner = Color(0xFF161816);

  /// Faint glare / reflection sheen across the LCD lens.
  static const Color lcdGlare = Color(0x08FFFFFF);

  // ---------------------------------------------------------------------------
  // LCD Monochrome Palette (Section 9)
  // ---------------------------------------------------------------------------

  /// Active "black" pixels on the LCD screen.
  /// Active "dark" pixels on the LCD screen (muted washed-out palette).
  static const Color lcdDarkest = Color(0xFF254B52);

  /// Dark shaded pixels on the LCD screen.
  static const Color lcdDark = Color(0xFF5B9AA2);

  /// Mid-tone pixels on the LCD screen.
  static const Color lcdMedium = Color(0xFF9ACBD6);

  /// LCD light reflective background surface (muted/pale cyan-gray).
  static const Color lcdLight = Color(0xFFDCEFF2);

  /// Very faint scanline tint.
  static const Color lcdScanline = Color(0x14000000);

  // ---------------------------------------------------------------------------
  // Accents (power / end button)
  // ---------------------------------------------------------------------------

  /// Subtle red accent used for end/power button indicators.
  static const Color redAccent = Color(0xFFB31B1B);

  // ---------------------------------------------------------------------------
  // Keypad & Physical Keys Palette (Sections 19, 20)
  // ---------------------------------------------------------------------------

  /// Key top gradient start.
  static const Color keySurfaceTop = Color(0xFF3D3D3D);

  /// Key top gradient end.
  static const Color keySurfaceBottom = Color(0xFF2C2C2C);

  /// Depressed key surface.
  static const Color keyPressedSurface = Color(0xFF222222);

  /// Outer rim of each raised physical key.
  static const Color keyBorder = Color(0xFF1F1F1F);

  /// Raised top bevel highlight on unpressed keys.
  static const Color keyHighlight = Color(0xFF555555);

  /// Bottom drop/bevel shadow providing tactile 3D height.
  static const Color keyShadow = Color(0xFF151515);

  /// Primary numeric label color.
  static const Color keyText = Color(0xFFD6D6D6);

  /// Secondary alphanumeric label color (ABC, DEF, etc.).
  static const Color keySubText = Color(0xFF8E8E8E);

  /// Label color when key is pressed.
  static const Color keyTextPressed = Color(0xFFAAAAAA);

  // ---------------------------------------------------------------------------
  // Soft Keys & Navigation Pad Palette (Sections 17, 18)
  // ---------------------------------------------------------------------------

  /// Soft key surface color.
  static const Color softKeySurface = Color(0xFF333333);

  /// Soft key printed label color.
  static const Color softKeyText = Color(0xFF9A9A9A);

  /// Directional pad ring surface.
  static const Color navPadSurface = Color(0xFF2E2E2E);

  /// Directional pad outer rim.
  static const Color navPadBorder = Color(0xFF1D1D1D);

  /// Center action/select button surface.
  static const Color navCenterSurface = Color(0xFF262626);

  /// Navigation arrow/indicator icon color.
  static const Color navArrowColor = Color(0xFF7A7A7A);
}
