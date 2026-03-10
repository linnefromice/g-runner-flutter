# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Project G-Runner (Flutter Edition)** — a 2D vertical-scrolling SF gate runner game built with Flutter + Flame engine.
Port of the React Native version (`../../g-runner-rn/`).

## Tech Stack

- **Framework:** Flutter (Dart)
- **Game Engine:** Flame (`^1.36.0`) — component-based 2D game engine
- **Rendering:** Flame's built-in Canvas rendering (CustomPainter-based)
- **Collision:** Custom AABB (manual `Rect.overlaps()`)
- **State:** Flame's component tree + callback-based UI updates
- **Flutter Version:** Managed via FVM (see `.fvmrc`)

## Platform Support

**Mobile (iOS / Android) + Web.** All platforms supported via Flutter's multi-platform rendering.

## Commands

```bash
# Development
flutter run                     # Run on connected device/emulator
flutter run -d chrome           # Run on Chrome (web)
flutter run -d ios              # Run on iOS simulator

# Analysis & Testing
flutter analyze                 # Dart static analysis
flutter test                    # Run tests

# Build
flutter build apk               # Android APK
flutter build ios                # iOS build
flutter build web                # Web build
```

### FVM Usage

```bash
fvm use                         # Use version specified in .fvmrc
fvm flutter run                 # Run via FVM-managed Flutter
fvm flutter test                # Test via FVM-managed Flutter
```

## Architecture

### Project Structure

```
lib/
├── main.dart                   # App entry point + MaterialApp routing
├── game/
│   ├── g_runner_game.dart      # Core Flame game (state, spawning, collision, input)
│   ├── components/             # Flame Components (Player, Enemy, Bullet, Gate, etc.)
│   ├── data/                   # Constants + stage timeline definitions
│   ├── systems/                # (Reserved for extracted systems)
│   └── ui/                     # In-game HUD overlay
└── screens/                    # Flutter Widget screens (Title, Game, Result)
```

### Key Design Decisions

1. **Flame Component System** — Each game entity (Player, Enemy, Bullet, Gate) is a `PositionComponent`. Flame manages the update/render lifecycle.
2. **Logical Coordinate System** — Fixed `logicalWidth = 320`. Height is dynamic based on aspect ratio. Camera viewfinder handles scaling.
3. **Input Handling** — GestureDetector in `GameScreen` widget → calls `game.handlePanUpdate()` / `game.handleTapUp()`. Input is processed in logical coordinates via `screenWidth / 320` scale.
4. **Collision** — Manual AABB in `GRunnerGame._checkCollisions()`. No Flame collision system used.
5. **Screen Navigation** — Standard Flutter `Navigator.pushReplacement()`. Game ↔ UI bridge via `onGameEnd` callback.

### Key Files

| File | Purpose |
|------|---------|
| `lib/game/g_runner_game.dart` | Core game: state management, spawn events, collision, input |
| `lib/game/components/player.dart` | Player: movement, auto-fire, i-frame, HP |
| `lib/game/components/enemy.dart` | Enemy: 2 types (stationary/patrol), shooting, depth scale |
| `lib/game/components/bullet.dart` | PlayerBullet / EnemyBullet |
| `lib/game/components/gate.dart` | Power-up gates (ATK add / speed multiply) |
| `lib/game/components/background.dart` | 3-layer parallax starfield + scanlines |
| `lib/game/components/particle.dart` | Kill effect particles |
| `lib/game/data/constants.dart` | All game balance values |
| `lib/game/data/stage_data.dart` | Stage timeline definitions + enums |
| `lib/game/ui/hud.dart` | HP bar + score display overlay |
| `lib/screens/title_screen.dart` | Main menu |
| `lib/screens/game_screen.dart` | Game container (hosts Flame GameWidget) |
| `lib/screens/result_screen.dart` | Game over / stage clear screen |

### Coordinate System

- Logical: X `0–320` (fixed width), Y `0–logicalHeight` (dynamic)
- Scale: `screenWidth / 320`
- Player hitbox (16×16) is smaller than visual (32×40)
- Enemies spawn at Y=-20, scroll down at `baseScrollSpeed` (80 u/s)

### Game State Flow

```
TitleScreen → GameScreen (GRunnerGame) → ResultScreen
                  ↓                          ↓
             GameState.playing          Retry → GameScreen
             GameState.gameOver         Title → TitleScreen
             GameState.stageClear
```

## Game-Specific Conventions

- **Stages** are data-driven: `StageData` with timeline of `SpawnEvent`s
- **Enemy types** defined in `EnemyType` enum, stats in `constants.dart`
- **Gate effects** defined in `GateEffectType` enum, applied in `_applyGateEffect()`
- **2.5D depth**: Enemy scale/opacity varies with Y position (far = small, near = full)
- **I-frame**: 1.2s invincibility after player hit, with 0.1s blink interval
- **Auto-fire**: Player shoots every 0.2s automatically
- **Scoring**: Enemy kill = 100pts, Gate pass = 150pts

## Reference

- RN版 (機能完全版): `../../g-runner-rn/`
- 実装プラン: `IMPLEMENTATION_PLAN.md`
