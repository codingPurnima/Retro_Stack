# Retro Stack 🎮

A retro-inspired mobile stacking game built with **Flutter, Dart, and the Flame game engine**.

Retro Stack recreates the feel of classic keypad-phone games: a simple mechanic, minimal controls, pixel-inspired visuals, and a gradually challenging physics system.

The objective is simple — release each swinging box at the right moment and build the tallest stable tower you can.

---

## 🎮 Gameplay

A box continuously swings from a pendulum above the tower.

The player decides when to release it.

If the box lands with sufficient overlap on the previous box, it becomes part of the stack. As the tower grows, its physics become increasingly important and the camera follows the tower upward.

A poorly placed box can make the tower lean and eventually collapse.

**How high can you stack?**

---

## ✨ Features

### Core Gameplay

* Physics-based pendulum movement
* Player-controlled box release
* Gradual rotational movement of the stacked tower
* Center-of-mass based tower physics
* Dynamic tower leaning
* Configurable landing overlap tolerance
* Falling/collapse mechanics
* Progressive pendulum speed
* Automatic camera movement as the tower grows
* Game Over state and restart flow

### Scoring

* Score increases with every successfully landed box
* Persistent high score
* High score displayed on the Game Over screen
* New high-score feedback
* High score survives game restarts

### Controls

* Tap / action input for releasing the current box
* Retro phone-style D-pad navigation
* Menu options can be selected using both direct interaction and D-pad controls
* Pause and resume functionality

### Audio

* Retro-style box release sound
* Stone-like landing sound
* Game Over sound
* New high-score fanfare
* Looping background music
* Global sound ON/OFF control
* Persistent audio state between sessions

### Visual Design

* Custom retro phone interface
* LCD-inspired game display
* Retro colour palette
* Custom D-pad and phone controls
* Animated camera movement
* Minimal UI designed around the constraints of an old-school mobile game

---

# 🧠 Technical Overview

Retro Stack is built around a custom physics system rather than relying on a complete physics simulation engine.

The project uses **Flame** for the game loop, rendering, components, camera, effects, and input handling, while the gameplay-specific physics are implemented manually.

The main gameplay systems are separated into components such as:

```text
MyGame
│
├── GameStack
│   ├── Center of Mass
│   ├── Moment of Inertia
│   ├── Angular Velocity
│   ├── Stack Rotation
│   └── Connection / Overlap Detection
│
├── Box
│   ├── Pendulum Attachment
│   ├── Release
│   ├── Falling
│   └── Landing
│
├── Pendulum
│   ├── Angular Position
│   ├── Angular Velocity
│   ├── Gravity
│   ├── Damping
│   └── Release Velocity
│
├── Camera
│   └── Dynamic Vertical Movement
│
└── Audio
    ├── SFX
    ├── BGM
    └── Sound Preferences
```

---

# ⚙️ Physics System

One of the main technical challenges of Retro Stack was making the tower feel physically convincing without making the game unnecessarily difficult.

## Pendulum

The falling box is controlled by a simplified physical pendulum.

Angular acceleration is calculated using the pendulum equation:

```text
θ'' = -(g / L) sin(θ)
```

with damping applied to control energy loss.

The resulting angular velocity is converted into linear velocity when the player releases the box.

This allows the release position and release timing to affect where the box lands.

---

## Tower Rotation

Once a box becomes part of the stack, the entire tower is treated as a rotational system.

The tower calculates its horizontal center of mass and determines whether the stack is sufficiently balanced around its base.

The gravitational torque is approximately modeled as:

```text
τ = r × F
```

where the horizontal center-of-mass displacement produces the rotational tendency of the tower.

The tower's moment of inertia is calculated from the positions of the boxes:

```text
I = Σ mr²
```

Angular acceleration is then obtained from:

```text
α = τ / I
```

The simulation uses semi-implicit Euler integration to update angular velocity and angle gradually rather than instantly rotating the tower.

This was important for keeping the tower's movement smooth and avoiding sudden snapping.

---

## Landing Detection

A box does not need to be perfectly centered to land successfully.

The game calculates horizontal overlap between the current box and the box beneath it.

The overlap is compared against a configurable minimum ratio:

```text
required overlap = box width × minimum overlap ratio
```

This gives the player some tolerance while still making inaccurate placements risky.

---

## Progressive Difficulty

The pendulum becomes faster as the player successfully stacks more boxes.

The speed multiplier increases at regular score intervals rather than continuously.

This creates progressively harder gameplay while keeping the early game approachable.

---

# 📱 Responsive Game Layout

The game uses a virtual resolution:

```text
480 × 750
```

The retro phone frame and its controls are scaled responsively so that the game can adapt to different physical screen sizes while preserving the original proportions.

The gameplay itself remains based on the virtual game coordinate system, separating gameplay mechanics from the physical display size.

---

# 🔊 Audio System

Retro Stack uses `flame_audio` for sound effects and background music.

Audio is preloaded during initialization to reduce playback latency during gameplay.

The audio system provides:

* Box release SFX
* Box landing SFX
* Game Over SFX
* High-score SFX
* Looping background music
* Persistent sound preference

Sound playback is kept separate from the gameplay components through a dedicated `GameAudio` class.

---

# 💾 Persistent Data

The game stores player-specific settings and progression locally.

Currently persisted data includes:

* High score
* Sound preference

`shared_preferences` is used for local persistence.

No account or server is required to play the game.

---

# 🛠️ Tech Stack

| Technology             | Purpose                  |
| ---------------------- | ------------------------ |
| **Flutter**            | Application framework    |
| **Dart**               | Programming language     |
| **Flame**              | 2D game engine           |
| **flame_audio**        | SFX and background music |
| **shared_preferences** | Local persistence        |
| **Android**            | Primary release platform |

---

# 📂 Project Structure

A simplified structure of the project:

```text
lib/
├── game/
│   ├── components/
│   │   ├── game_stack_components/
│   │   ├── box.dart
│   │   ├── game_stack.dart
│   │   ├── pedestal_platform.dart
│   │   └── pendulum.dart
│   │
│   ├── my_game.dart
│   └── my_world.dart
│
├── backgrounds/
│   ├── ambient_background_painter.dart
│   ├── ambient_background.dart
│   ├── game_background.dart
│   └── pixel_background_elements.dart
│
├── phone/
│   ├── frame/
│   └── icons/
│
├── overlays/
│   ├── game_menu_back_button.dart
│   ├── game_menu_item.dart
│   ├── game_menu.dart
│   ├── game_over_restart_button.dart
│   ├── game_over.dart
│   ├── pause_overlay_resume_button.dart
│   ├── pause_overlay.dart
│   ├── start_screen_play_button.dart
│   └── start_screen.dart
│
├── theme/
│   ├── colors.dart
│   └── dimensions.dart
│
└── main.dart

assets/
├── images/
│   └── launcher.png
├── sounds/
│   ├── box_land.wav
│   ├── box_release.wav
│   ├── cheerful_bgm.wav  
│   ├── game_over.wav 
│   └── high_score.wav   
```

The exact structure may evolve as the project is maintained.

---

# 🚀 Running the Project

## Prerequisites

Make sure you have:

* Flutter SDK
* Dart SDK
* Android Studio / Android SDK
* A connected Android device or emulator

Check your Flutter installation with:

```bash
flutter doctor
```

---

## Installation

Clone the repository:

```bash
git clone <repository-url>
```

Navigate into the project:

```bash
cd retro-stack
```

Install dependencies:

```bash
flutter pub get
```

Run the game:

```bash
flutter run
```

For a connected Android device:

```bash
flutter devices
```

Then:

```bash
flutter run
```

---

# 📦 Building for Android

To generate a release APK:

```bash
flutter build apk --release
```

To generate an Android App Bundle for Google Play:

```bash
flutter build appbundle --release
```

The generated AAB can be found under:

```text
build/app/outputs/bundle/release/
```

---

# 🧪 Testing

Before creating a release build, the project can be checked with:

```bash
flutter analyze
```

and:

```bash
flutter test
```

Physical-device testing is particularly important for:

* Touch controls
* D-pad interaction
* Audio playback
* Responsive phone scaling
* Performance
* Game Over → Restart behavior

---

# 🔐 Release Signing

Android release builds require a release/upload keystore.

The signing configuration uses a local `key.properties` file and should **not** be committed to the repository.

Sensitive files should remain excluded through `.gitignore`, for example:

```gitignore
android/key.properties
*.jks
*.keystore
```

For Google Play distribution, the release is uploaded as an Android App Bundle (`.aab`) and can use Google Play App Signing.

---

# 🗺️ Version 1

Retro Stack V1 focuses on the core experience:

* Retro phone interface
* Physics-based stacking
* Progressive difficulty
* Scoring
* Persistent high score
* Audio
* Pause/resume
* D-pad navigation
* Responsive controls
* Android release support

Some menu options and larger gameplay features may be expanded in future versions.

---

# 🔮 Possible Future Improvements

Potential future additions include:

* More difficulty modes
* Improved first-launch experience
* Additional visual themes
* More gameplay feedback
* Additional sound/music options
* Expanded statistics
* Additional gameplay modes

These are intentionally outside the scope of the initial V1 release.

---

# 🎯 Why I Built This

Retro Stack started with a simple idea:

**What if I rebuilt the kind of small game that could keep someone occupied on an old keypad phone?**

The project became an opportunity to explore game development, custom physics, responsive mobile UI, audio systems, state management, persistence, and the process of taking a project all the way from an idea to a release-ready Android application.

The goal wasn't to build a large game.

It was to build a **small game that feels complete.**

---

## 📱 Platform

**Android**

Future platform support may be considered separately.

---

## 👤 Author

**Purnima Pandey**

Built with Flutter and Flame.

---
