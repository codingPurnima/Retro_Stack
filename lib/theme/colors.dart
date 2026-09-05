import 'package:flutter/painting.dart';

/// Centralized color palette for the Retro Stack slider phone, LCD screen, and ambient backdrop.
abstract final class RetroColors {
  // ---------------------------------------------------------------------------
  // Ambient Backdrop Palette
  // ---------------------------------------------------------------------------

  /// Deep fallback black background.
  static const Color deepBlack = Color(0xFF111111);

  /// Top color of the ambient atmospheric sky gradient.
  static const Color ambientSkyTop = Color(0xFF98B8D8);

  /// Bottom color of the ambient atmospheric sky gradient (warm pastel horizon).
  static const Color ambientSkyBottom = Color(0xFFE2DDD4);

  /// Distant low-contrast pixel-art tower silhouettes (farthest layer).
  static const Color ambientTowerFar = Color(0x558296AF);

  /// Mid-distance low-contrast pixel-art tower silhouettes.
  static const Color ambientTowerNear = Color(0x77647D96);

  /// Gentle ambient pixel clouds.
  static const Color ambientCloud = Color(0x88FFFFFF);

  /// Soft ground / table surface plane beneath the phone.
  static const Color ambientGround = Color(0xFFA6B4C0);

  /// Subtle soft ambient shadow beneath the phone on the table.
  static const Color ambientGroundShadow = Color(0x40000000);

  // ---------------------------------------------------------------------------
  // Slider Phone Body — Satin Blue-Silver Palette
  // ---------------------------------------------------------------------------

  /// Light specular reflection on the blue-silver molded phone body.
  static const Color phoneBodyLight = Color(0xFF9CB8CF);

  /// Satin metallic blue-silver midtone for the phone shell.
  static const Color phoneBodyMid = Color(0xFF769AB3);

  /// Deep edge shading on the blue-silver molded phone body.
  static const Color phoneBodyDark = Color(0xFF52748D);

  /// Top specular edge highlight of the molded outer body.
  static const Color phoneBodyBevel = Color(0xFFD4E6F2);

  // ---------------------------------------------------------------------------
  // Chrome Edge & Highlight Palette
  // ---------------------------------------------------------------------------

  /// Bright specular reflection along outer phone rim and D-pad ring.
  static const Color chromeHighlight = Color(0xFFEAF2F8);

  /// Metallic chrome midtone.
  static const Color chromeMid = Color(0xFFADC2D1);

  /// Shadow bevel of the chrome edge rim.
  static const Color chromeShadow = Color(0xFF435D70);

  // ---------------------------------------------------------------------------
  // Glossy Dark Faceplate Palette (Frames Screen & Controls)
  // ---------------------------------------------------------------------------

  /// Deep black-charcoal faceplate base.
  static const Color faceplateDark = Color(0xFF121316);

  /// Subtle vertical gradient midtone for the glossy faceplate.
  static const Color faceplateMid = Color(0xFF1C1E22);

  /// Outer border highlight of the dark faceplate.
  static const Color faceplateBevel = Color(0xFF2E3238);

  /// Recessed seam separating faceplate from outer body.
  static const Color faceplateBorder = Color(0xFF0A0B0D);

  // ---------------------------------------------------------------------------
  // Legacy / Direct Phone Body Aliases (Maintains Backwards Compatibility)
  // ---------------------------------------------------------------------------

  /// Outer perimeter border of the phone body.
  static const Color phoneOuter = chromeShadow;

  /// Main surface of the phone body.
  static const Color phoneMain = phoneBodyMid;

  /// Highlight bevel on the molded phone body.
  static const Color phoneHighlight = phoneBodyBevel;

  /// Ambient phone drop shadow.
  static const Color phoneShadow = Color(0x550A141E);

  /// Top-to-bottom plastic gradient accents.
  static const Color phoneGradientLight = phoneBodyLight;
  static const Color phoneGradientDark = phoneBodyDark;

  // ---------------------------------------------------------------------------
  // Speaker & Sensor Palette
  // ---------------------------------------------------------------------------

  /// Recessed speaker slot interior mesh color.
  static const Color speakerHole = Color(0xFF0D0E10);

  /// Inset highlight on the edge of speaker opening.
  static const Color speakerHighlight = Color(0xFF383C42);

  /// Subtle front proximity sensor / camera dot.
  static const Color speakerSensor = Color(0xFF1B2228);

  // ---------------------------------------------------------------------------
  // LCD Screen Bezel Palette
  // ---------------------------------------------------------------------------

  /// Outer dark plastic bezel surrounding the LCD display.
  static const Color bezelOuter = Color(0xFF16181A);

  /// Highlight line on the inner bezel edges.
  static const Color bezelHighlight = Color(0xFF2A2D30);

  /// Deep inner recessed rim immediately holding the LCD glass.
  static const Color bezelInner = Color(0xFF0E1011);

  /// Faint glare / reflection sheen across the LCD lens.
  static const Color lcdGlare = Color(0x0CFFFFFF);

  // ---------------------------------------------------------------------------
  // LCD Screen Palette
  // ---------------------------------------------------------------------------

  /// Active "dark" pixels on the LCD screen (muted washed-out palette).
  static const Color lcdDarkest = Color(0xFF1E3C48);

  /// Dark shaded pixels on the LCD screen.
  static const Color lcdDark = Color(0xFF436E7D);

  /// Mid-tone pixels on the LCD screen.
  static const Color lcdMedium = Color(0xFF7FA8B8);

  /// LCD light reflective background surface (soft cyan-gray mobile LCD tone).
  static const Color lcdLight = Color(0xFFC8DFE8);

  /// Very faint scanline tint.
  static const Color lcdScanline = Color(0x10000000);

  // ---------------------------------------------------------------------------
  // Accents (Power / End button)
  // ---------------------------------------------------------------------------

  /// Iconic red accent used for end/power button indicators.
  static const Color redAccent = Color(0xFFD32F2F);

  // ---------------------------------------------------------------------------
  // Controls & Physical Keys Palette
  // ---------------------------------------------------------------------------

  /// Physical button surface base color.
  static const Color buttonSurface = Color(0xFF24262A);

  /// Physical button top bevel highlight.
  static const Color buttonHighlight = Color(0xFF3B3F45);

  /// Physical button border rim.
  static const Color buttonBorder = Color(0xFF141618);

  /// Key top gradient start.
  static const Color keySurfaceTop = Color(0xFF32353A);

  /// Key top gradient end.
  static const Color keySurfaceBottom = Color(0xFF202225);

  /// Depressed key surface.
  static const Color keyPressedSurface = Color(0xFF181A1C);

  /// Outer rim of each raised physical key.
  static const Color keyBorder = buttonBorder;

  /// Raised top bevel highlight on unpressed keys.
  static const Color keyHighlight = buttonHighlight;

  /// Bottom drop/bevel shadow providing tactile 3D height.
  static const Color keyShadow = Color(0xFF0E1012);

  /// Primary button label color.
  static const Color keyText = Color(0xFFD6DDE4);

  /// Secondary button label color.
  static const Color keySubText = Color(0xFF8E99A4);

  /// Label color when key is pressed.
  static const Color keyTextPressed = Color(0xFFA0AAB4);

  // ---------------------------------------------------------------------------
  // Soft Keys & Navigation Pad Palette
  // ---------------------------------------------------------------------------

  /// Soft key surface color.
  static const Color softKeySurface = buttonSurface;

  /// Soft key printed label color.
  static const Color softKeyText = Color(0xFFB8C2CC);

  /// Directional pad ring surface.
  static const Color navPadSurface = Color(0xFF1E2024);

  /// Directional pad outer rim (chrome metallic).
  static const Color navPadBorder = chromeMid;

  /// Center action/select button surface.
  static const Color navCenterSurface = Color(0xFF2E3238);

  /// Navigation arrow/indicator icon color.
  static const Color navArrowColor = Color(0xFFBAC7D4);

  // ---------------------------------------------------------------------------
  // Button Icon Accent Colors (from Inspiration Slider Phone)
  // ---------------------------------------------------------------------------

  /// Coral/salmon red used for Menu (≡), Back (↩), and Power (⏻) icons.
  static const Color buttonIconRed = Color(0xFFE55858);

  /// Metallic silver/white used for Call phone receiver icon (📞).
  static const Color buttonIconSilver = Color(0xFFCAD8E2);

  // ---------------------------------------------------------------------------
  // Stone Block Palette (from Inspiration Tower Blocks)
  // ---------------------------------------------------------------------------

  /// Main stone masonry face color.
  static const Color stoneBlockMain = Color(0xFF7E929E);

  /// Top and left highlight bevel for stone blocks.
  static const Color stoneBlockHighlight = Color(0xFFA5B8C4);

  /// Bottom and right shadow bevel for stone blocks.
  static const Color stoneBlockShadow = Color(0xFF556773);

  /// Dark outline border framing each stone block.
  static const Color stoneBlockBorder = Color(0xFF2C3942);

  /// Subtle stone mortar joint / fissure accent.
  static const Color stoneBlockDetail = Color(0xFF6A7C88);

  // ---------------------------------------------------------------------------
  // Game Pedestal & Crane Palette
  // ---------------------------------------------------------------------------

  /// Top masonry slab of the stack pedestal.
  static const Color pedestalTop = Color(0xFF748590);

  /// Masonry brick body of the stack pedestal.
  static const Color pedestalBody = Color(0xFF4E5D66);

  /// Dark outline for the stack pedestal.
  static const Color pedestalBorder = Color(0xFF26333B);

  /// Metallic crane girder structure at screen top.
  static const Color craneGirder = Color(0xFF4C6A7B);

  /// Crane girder highlight edge.
  static const Color craneGirderLight = Color(0xFF6F92A4);

  /// Crane girder deep shadow / rivet holes.
  static const Color craneGirderDark = Color(0xFF2E4653);

  /// Crane cable / chain links.
  static const Color craneChain = Color(0xFF243038);

  // ---------------------------------------------------------------------------
  // In-Game LCD Pixel Art World Palette
  // ---------------------------------------------------------------------------

  /// Game sky top cyan-blue.
  static const Color gameSkyTop = Color(0xFF88AEC6);

  /// Game sky horizon warm pastel cream.
  static const Color gameSkyBottom = Color(0xFFE4DFD6);

  /// Distant pixel-art towers (far layer).
  static const Color gameTowerFar = Color(0xFF6E99B0);

  /// Distant pixel-art towers (near layer with battlements).
  static const Color gameTowerNear = Color(0xFF527E95);

  /// In-game soft pixel clouds.
  static const Color gameCloud = Color(0xDDFFFFFF);

  /// In-game HUD score and signal text.
  static const Color hudText = Color(0xFF1B2A31);

  /// In-game bottom drop prompt banner background.
  static const Color hudPromptBg = Color(0xBB183238);

  /// In-game bottom drop prompt banner text.
  static const Color hudPromptText = Color(0xFF98CED4);
}
