# Retro Stack — UI Design Specification

## 1. Product Vision

Retro Stack is a stacking game presented inside a fictional early-2000s keypad mobile phone.

The goal is not simply to make a game with a retro color palette.

The entire application should create the illusion that the user is interacting with an old feature phone.

The desired emotional response is:

> "This feels like one of those games I used to play on an old keypad phone."

The design should prioritize:

1. Nostalgia
2. Simplicity
3. Tactile interaction
4. Pixel-era visual language
5. Consistency between the phone shell and the game

The application must NOT look like a modern mobile game with a green filter applied to it.

---

# 2. Core Design Principle

The application consists of two visual layers.

```text
┌─────────────────────────────────┐
│                                 │
│          PHONE SHELL            │
│       Flutter UI layer          │
│                                 │
│   ┌─────────────────────────┐   │
│   │                         │   │
│   │       LCD SCREEN        │   │
│   │                         │   │
│   │       Flame Game        │   │
│   │                         │   │
│   └─────────────────────────┘   │
│                                 │
│           SOFT KEYS             │
│                                 │
│        VIRTUAL KEYPAD           │
│                                 │
└─────────────────────────────────┘
```

### Flutter layer

Responsible for:

* phone body
* speaker
* LCD bezel
* LCD visual effects
* keypad
* keypad animations
* soft keys
* menus
* status bar
* startup screen
* navigation

### Flame layer

Responsible for:

* stacking game
* blocks
* rope
* swinging movement
* physics
* collision
* score during gameplay
* game-specific effects

The Flame game must remain independent of the phone shell wherever practical.

The Flame game should not contain knowledge about the phone's physical body, keypad styling, or external UI.

---

# 3. Overall Visual Style

The visual language should resemble an early-2000s monochrome feature phone.

## Avoid

* Material Design
* Material 3 buttons
* modern cards
* glassmorphism
* gradients used purely for decoration
* excessive rounded corners
* neon colors
* modern navigation bars
* large modern typography
* modern game HUDs
* realistic 3D rendering
* excessive particles
* excessive animations

## Prefer

* hard-edged geometry
* subtle bevels
* physical-looking plastic
* monochrome LCD graphics
* pixel typography
* simple icons
* tiny animations
* tactile button feedback
* limited colors
* strong visual hierarchy
* deliberate pixelation

The interface should feel technologically limited.

That limitation is part of the aesthetic.

---

# 4. Phone Form Factor

The phone should visually resemble a classic candy-bar keypad phone.

It should be vertically oriented.

Recommended logical aspect ratio:

```text
Phone width : Phone height
≈ 0.48 : 1
```

A practical reference size is approximately:

```text
width  = 300 logical pixels
height = 625 logical pixels
```

These are design reference dimensions, not fixed device dimensions.

The phone must scale proportionally to fit different device sizes.

## Important

Never stretch the phone independently in the horizontal and vertical directions.

Maintain the phone's aspect ratio.

The phone should be centered on the available screen.

On very tall screens, leave empty space above and below rather than stretching the phone.

On smaller screens, scale the entire phone down uniformly.

---

# 5. Phone Body

The phone body should occupy approximately:

```text
92–96%
```

of the available phone-container width.

The body should have:

* slightly rounded outer corners
* subtle bevel
* thin darker outer edge
* slightly lighter inner surface
* no glossy modern smartphone appearance

The plastic should feel like molded early-2000s phone plastic.

## Corner radius

Reference:

```text
Outer corner radius: 24–30 px
```

at the reference phone size.

Internal elements should have smaller radii.

Avoid extremely rounded surfaces.

---

# 6. Phone Color

The default phone should use a muted dark gray / charcoal plastic.

Reference palette:

```text
Phone outer:
#303030

Phone main:
#3A3A3A

Phone highlight:
#4A4A4A

Phone shadow:
#202020

Deep black:
#111111
```

These are reference values rather than mandatory exact colors.

The final implementation should keep the palette centralized in a theme/constants file.

Do not scatter raw color values throughout widgets.

---

# 7. Phone Top Section

The top section contains:

1. speaker
2. optional fictional brand/logo
3. small decorative details

The speaker should consist of several small horizontal or circular openings.

Example:

```text
      • • • • • •
```

It should not look like a modern smartphone earpiece.

Keep it understated.

---

# 8. LCD Screen

The LCD screen is the visual centerpiece.

The screen should look like an old monochrome LCD rather than a modern OLED display.

Structure:

```text
Phone body
    ↓
Dark screen bezel
    ↓
Inner LCD border
    ↓
LCD surface
    ↓
Game/UI content
```

## Screen proportions

Reference size:

```text
width  ≈ 220 px
height ≈ 185 px
```

at the 300 × 625 phone reference size.

The LCD should occupy approximately:

```text
70–75%
```

of the phone width.

---

# 9. LCD Colors

Use a muted green monochrome palette.

Reference palette:

```text
LCD darkest:
#0F380F

LCD dark:
#306230

LCD medium:
#6B8E23

LCD light/background:
#9BBC0F
```

The most important rule is that the LCD should have a **limited color palette**.

Do not use full-color game graphics inside the LCD.

All game elements should use colors from the LCD palette or very close variations.

---

# 10. LCD Pixel Appearance

The LCD should appear slightly pixelated.

The goal is not to make the game blurry.

Instead:

* use crisp shapes
* use pixel-oriented typography
* avoid anti-aliased decorative graphics where practical
* keep the pixel-art aesthetic consistent

If a shader or filter is used, it must be subtle.

Do not apply an aggressive CRT effect.

The user should still be able to comfortably read the screen.

---

# 11. LCD Scanlines

Optional subtle horizontal scanlines may be placed over the LCD.

Example:

```text
────────────────────
────────────────────
────────────────────
────────────────────
```

They should be extremely subtle.

The user should notice them only when looking closely.

Do not make the screen look like an old CRT television.

This is an LCD phone, not a CRT monitor.

---

# 12. LCD Reflection

A very subtle static highlight may be added to the LCD surface.

It should be almost invisible.

Avoid:

* large diagonal reflections
* glassmorphism
* glossy smartphone effects

The screen should remain readable.

---

# 13. Status Bar

The LCD may contain a tiny status bar when appropriate.

Example:

```text
▮▮▮        12:48       ▰▰▰
```

Possible elements:

### Signal

Use 3–4 tiny vertical bars.

Example:

```text
▮▮▮▮
```

### Battery

Use a tiny rectangular battery icon.

Example:

```text
[■■■□]
```

### Time

Use a small pixel font.

The status bar should occupy very little space.

During gameplay it may be hidden if screen space is required.

---

# 14. Pixel Typography

Typography is a major part of the retro appearance.

Use a bundled pixel-style font.

Possible candidates:

* Press Start 2P
* Pixelify Sans
* another appropriately licensed pixel font

The font must be included as an application asset rather than relying on the user's system fonts.

## Typography rules

Prefer:

```text
RETRO STACK
SCORE
HIGH SCORE
START
GAME OVER
PERFECT!
```

Avoid:

```text
Modern lowercase UI copy
Large paragraph text
Modern rounded typefaces
```

Text should generally be:

* uppercase for important labels
* compact
* pixel-oriented
* high contrast against the LCD background

---

# 15. Main Menu

The application should not immediately throw the user into the game.

The phone should have a simple startup/menu experience.

Example:

```text
┌──────────────────────┐
│ ▮▮▮       12:48    │
│                      │
│      RETRO STACK     │
│                      │
│      > PLAY          │
│        HIGH SCORE    │
│        HELP          │
│                      │
│ MENU           SELECT│
└──────────────────────┘
```

The menu should feel like navigating a feature phone.

Do not use a modern scrolling list.

---

# 16. Startup Screen

When the application starts, show a short startup sequence.

Example:

```text
┌──────────────────────┐
│                      │
│                      │
│        RETRO         │
│        STACK         │
│                      │
│      Loading...      │
│                      │
└──────────────────────┘
```

The startup sequence should be brief.

Target:

```text
500–1200 ms
```

It should not annoy the user after repeated launches.

A subtle pixel/fade transition is acceptable.

---

# 17. Soft Keys

Below the LCD should be a small soft-key region.

Reference:

```text
┌─────────────────────────┐
│                         │
│    MENU       SELECT    │
└─────────────────────────┘
```

Depending on the current screen, labels may change:

```text
MENU          SELECT
BACK          OK
OPTIONS       SELECT
```

The labels should be small.

They should look like printed phone labels rather than modern buttons.

---

# 18. Navigation Key

The phone should have a central navigation/select control.

Possible structure:

```text
       ▲
    ◀  ●  ▶
       ▼
```

or a simplified classic keypad navigation button.

It should visually resemble a physical directional pad.

The center button can act as:

```text
SELECT
```

The navigation control should have tactile press feedback.

---

# 19. Numeric Keypad

The keypad is one of the most important nostalgic elements.

Layout:

```text
┌─────────┬─────────┬─────────┐
│    1    │    2    │    3    │
│         │ ABC     │ DEF     │
├─────────┼─────────┼─────────┤
│    4    │    5    │    6    │
│ GHI     │ JKL     │ MNO     │
├─────────┼─────────┼─────────┤
│    7    │    8    │    9    │
│ PQRS    │ TUV     │ WXYZ    │
├─────────┼─────────┼─────────┤
│    *    │    0    │    #    │
└─────────┴─────────┴─────────┘
```

The alphabet labels are optional but strongly recommended because they increase authenticity.

---

# 20. Key Shape

Keys should NOT be standard Flutter `ElevatedButton`s.

Create a reusable custom widget:

```text
RetroKey
```

Each key should have:

* physical-looking surface
* slightly rounded corners
* subtle shadow
* slightly darker lower edge
* number
* optional letters
* press animation

Keys should appear raised above the phone body.

---

# 21. Key Press Animation

When a key is pressed:

### Before

```text
████████
```

### Pressed

```text
  ██████
```

Visually, the key should move down approximately:

```text
2–4 logical pixels
```

The shadow should reduce correspondingly.

Animation duration:

```text
50–100 ms
```

Release should be slightly faster or approximately equal.

The interaction should feel tactile.

---

# 22. Key Press Sound

Optional short click sound.

The sound should be:

* very short
* dry
* low-volume
* electronic/mechanical

Avoid modern UI sounds.

The sound should never become irritating during repeated gameplay.

---

# 23. Game Screen

When the user starts the game, the LCD should show only the information necessary for gameplay.

Example:

```text
┌──────────────────────┐
│ SCORE 024     ▮▮▮  │
│                      │
│          │           │
│          │           │
│        █████         │
│          │           │
│                      │
│     ██████████       │
│     ██████████       │
│                      │
└──────────────────────┘
```

The game should use most of the available LCD area.

Avoid putting large UI elements over the game.

---

# 24. Score Display

Score should be small and unobtrusive.

Example:

```text
SCORE 024
```

Prefer fixed-width numbers where possible.

Avoid:

```text
Your Score: 24
```

The interface should feel constrained by an old phone display.

---

# 25. Gameplay Instructions

Do not permanently display instructions.

At the beginning of a game, a short instruction may appear:

```text
PRESS 5
TO DROP
```

Then disappear.

The keypad itself should communicate the interaction.

---

# 26. The "Cut Rope" Interaction

The central gameplay interaction is the numeric keypad.

The key assigned to cutting the rope should have a clear relationship with the action.

Recommended:

```text
5 = DROP / CUT
```

When the player presses `5`:

1. Key visually depresses.
2. Short click sound plays.
3. Flame game receives the input.
4. Rope is cut.
5. Block begins falling.
6. Key returns to normal state.

The Flutter keypad should not directly manipulate physics.

Instead, communicate an input event to the game layer.

Example conceptual architecture:

```text
RetroKey(5)
      ↓
Input Controller
      ↓
RetroStackGame
      ↓
Game Mechanics
```

---

# 27. Game Over Screen

The game-over screen should remain inside the LCD.

Example:

```text
┌──────────────────────┐
│                      │
│      GAME OVER       │
│                      │
│      SCORE  128      │
│                      │
│      BEST   342      │
│                      │
│    PRESS 5 TO RETRY  │
│                      │
└──────────────────────┘
```

Do not use a large modern "PLAY AGAIN" button.

Use keypad language.

---

# 28. Perfect Landing

A perfect landing should have a small visual reward.

Example:

```text
      PERFECT!
```

The effect should:

* appear briefly
* use a brighter LCD color
* possibly blink once
* disappear quickly

Target duration:

```text
300–700 ms
```

Do not use large particle explosions.

The reward should feel like an old phone game.

---

# 29. Game Feedback

Keep feedback simple.

Possible effects:

### Normal landing

Tiny screen flash.

### Perfect landing

Short:

```text
PERFECT!
```

### Failed landing

Subtle screen shake or flash.

### Game over

Short visual transition.

Avoid modern game effects such as:

* explosions
* glowing particles
* camera zoom
* chromatic aberration
* elaborate transitions

---

# 30. Phone Navigation

The phone shell should eventually support a simple state hierarchy:

```text
STARTUP
   ↓
HOME / MAIN MENU
   ↓
GAMES
   ↓
RETRO STACK
   ↓
GAME
   ↓
GAME OVER
```

However, the first UI implementation does not need all of these states.

Build incrementally.

---

# 31. Responsive Layout

The phone must work across:

* small Android phones
* large Android phones
* tablets
* desktop Flutter development
* emulator windows with unusual aspect ratios

The phone should:

1. calculate available space
2. determine the maximum size that preserves its aspect ratio
3. center itself
4. scale uniformly

Never hard-code the phone to the physical screen dimensions.

Reference design dimensions can be used for internal layout calculations.

---

# 32. Coordinate System

The phone UI should preferably use a fixed logical design coordinate system internally.

Reference design:

```text
300 × 625
```

Widgets should be laid out relative to this reference size and scaled uniformly.

This makes visual tuning much easier.

Avoid scattering calculations such as:

```dart
MediaQuery.of(context).size.width * 0.37
```

throughout individual widgets.

Centralize dimensions where possible.

---

# 33. Design Constants

Create a central location for UI constants.

For example:

```text
lib/theme/
    retro_colors.dart
    retro_dimensions.dart
    retro_text_styles.dart
```

These should contain:

* phone colors
* LCD colors
* key sizes
* spacing
* corner radii
* reference dimensions
* animation durations
* typography sizes

Avoid magic numbers in UI widgets.

---

# 34. Component Structure

Recommended Flutter structure:

```text
lib/

  phone/

    phone_shell.dart

    phone_body.dart

    speaker.dart

    lcd/
      lcd_frame.dart
      lcd_surface.dart
      lcd_effects.dart

    keypad/
      keypad.dart
      retro_key.dart
      navigation_key.dart
      soft_keys.dart
```

The exact structure may change as the project evolves.

Do not create unnecessary abstractions merely for the sake of abstraction.

---

# 35. Flame Integration

The Flame game should appear inside:

```text
LCDSurface
    ↓
GameWidget
    ↓
RetroStackGame
```

Conceptually:

```dart
LcdSurface(
  child: GameWidget(
    game: retroStackGame,
  ),
)
```

The Flame game should not draw:

* phone body
* keypad
* phone speaker
* physical buttons
* phone shell

Those belong to Flutter.

---

# 36. Input Architecture

The keypad should send semantic input events rather than manipulating individual game components.

Example:

```text
5
↓
GameInput.drop()
↓
RetroStackGame.handleInput()
↓
CurrentBlock.cutRope()
```

This allows the same game to potentially support:

* physical keyboard input during development
* touch keypad input
* external controllers later

The Flame mechanics should remain independent of the visual keypad.

---

# 37. Accessibility

The retro appearance should not prevent basic usability.

Provide:

* sufficient contrast
* readable text
* reasonable touch targets
* semantic labels for important controls

The keypad can look small while its actual Flutter hit area is slightly larger.

For example:

```text
Visual key:
50 × 35

Actual hit area:
60 × 45
```

Do not make the user fight the UI to hit a key.

---

# 38. Animation Philosophy

Animations should be:

* short
* mechanical
* subtle
* purposeful

Recommended durations:

```text
Key press:        50–100 ms
Menu transition:  100–200 ms
Startup:          500–1200 ms
Perfect message:  300–700 ms
Screen feedback:  <300 ms
```

Avoid long modern animations.

Old phones were fast in concept but visually simple.

---

# 39. Audio Philosophy

Audio should reinforce the illusion.

Use a very small sound vocabulary:

```text
key_press
menu_select
game_start
block_drop
landing
perfect
game_over
```

Sounds should be short and slightly primitive.

No cinematic music.

Optional background music should resemble simple early mobile-game/chiptune audio.

---

# 40. Asset Philosophy

Use assets only when they improve authenticity.

Prefer Flutter drawing/custom painting for:

* phone body
* buttons
* LCD frame
* simple icons
* signal indicator
* battery
* navigation controls

Use image assets for:

* logos
* textures
* complex decorative details
* optional noise texture

Do not fill the project with unnecessary PNG assets.

---

# 41. Visual Hierarchy

The visual hierarchy should always be:

```text
1. LCD / Game
2. Phone identity
3. Keypad
4. Decorative details
```

The phone body should frame the experience rather than compete with it.

---

# 42. What "Good" Looks Like

A successful implementation should make the user think:

> "I'm looking at an old feature phone."

Then:

> "Oh, there's a game on it."

Then:

> "I actually have to press the keypad."

The UI should feel like a physical object rather than a collection of Flutter widgets.

---

# 43. What "Bad" Looks Like

Avoid an implementation that looks like:

```text
Modern Flutter App
      +
Green background
      +
Pixel font
      +
Rounded buttons
```

That is not sufficient.

The nostalgia must come from:

* proportions
* spacing
* physical button design
* LCD treatment
* typography
* interaction
* sound
* restrained animation
* overall composition

---

# 44. Implementation Constraints for AI Agents

When using an AI coding agent such as Antigravity:

## Before modifying code

The agent must inspect:

* existing Flutter architecture
* existing Flame architecture
* existing game components
* current input handling
* current game state management

Do not modify existing game mechanics unless explicitly requested.

## Before each major UI implementation

The agent should:

1. explain its proposed implementation
2. identify files it intends to modify
3. preserve existing game logic
4. implement one UI subsystem at a time
5. run static analysis
6. run tests if available
7. verify the application visually

---

# 45. AI Agent Priority

If there is a conflict between:

* modern Flutter conventions
* visual authenticity

prioritize visual authenticity, provided the resulting architecture remains maintainable.

If there is a conflict between:

* changing existing game mechanics
* making UI integration easier

do not change the game mechanics.

Adapt the UI integration instead.

---

# 46. Development Order

Implement the UI in this exact order:

### Stage 1 — Phone shell

```text
Phone body
Speaker
LCD frame
Keypad
```

### Stage 2 — LCD

```text
LCD surface
LCD colors
Pixel font
Status bar
```

### Stage 3 — Static screen

```text
RETRO STACK
PLAY
HIGH SCORE
```

### Stage 4 — Interactive keypad

```text
Key press animation
Key input
Soft keys
Navigation
```

### Stage 5 — Flame integration

```text
LCD
 ↓
GameWidget
 ↓
Existing game
```

### Stage 6 — Gameplay UI

```text
Score
Perfect
Game Over
```

### Stage 7 — Audio

```text
Key clicks
Game sounds
```

### Stage 8 — Polish

```text
LCD effects
Transitions
Micro-interactions
Spacing
Typography
```

---

# 47. Definition of Done — UI v1

UI v1 is complete when:

* [ ] Phone is centered and responsive
* [ ] Phone maintains its aspect ratio
* [ ] Phone body looks physically believable
* [ ] Speaker is present
* [ ] LCD bezel is present
* [ ] LCD uses monochrome green palette
* [ ] Pixel font is working
* [ ] Keypad resembles a classic feature phone
* [ ] Keys have tactile press animation
* [ ] Soft keys exist
* [ ] Navigation control exists
* [ ] Existing Flame game appears inside LCD
* [ ] Keypad input reaches the existing game
* [ ] Pressing 5 performs the game's drop/cut action
* [ ] Score appears inside LCD
* [ ] Game-over screen exists
* [ ] Basic startup/menu screen exists
* [ ] No Material-style UI is visible
* [ ] UI works on different screen sizes
* [ ] `flutter analyze` passes
* [ ] Existing game mechanics remain intact

---

# 48. Final Design Statement

Retro Stack should feel less like:

> "A Flutter game with a retro theme"

and more like:

> "A forgotten game that somehow escaped from an old keypad phone and appeared on my smartphone."

Every visual and interaction decision should reinforce that illusion.
