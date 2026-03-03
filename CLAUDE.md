# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`fancy_titles` is a Flutter package providing animated splash screens and title screens inspired by video games and anime: Sonic Mania, Persona 5, Neon Genesis Evangelion, and Super Mario Maker. Pure Flutter with zero external dependencies.

## Commands

```bash
# Install dependencies
flutter pub get

# Run all tests (~780+ tests)
flutter test

# Run a single test file
flutter test test/sonic_mania/sonic_mania_splash_test.dart

# Run tests with coverage
flutter test --coverage

# Run performance/allocation tests only
flutter test test/performance/

# Run benchmark suite
flutter test benchmark/run_benchmarks.dart

# Save new performance baseline
SAVE_BASELINE=true flutter test benchmark/run_benchmarks.dart

# Lint
dart analyze

# Run example app
cd example && flutter run

# Integration tests (require a device)
cd example && flutter test integration_test/evangelion_performance_test.dart -d <device_id>
```

## Architecture

### Core (`lib/core/`)

- **`BaseTitleWidget`** - Abstract base class all 4 title widgets extend. Defines lifecycle callbacks: `onAnimationStart`, `onAnimationComplete`, `onPhaseChange`.
- **`AnimationPhaseMixin`** - Manages animation lifecycle: `idle` → `entering` → `active` → `exiting` → `completed`. Auto-triggers start/complete callbacks on phase transitions.
- **`CancelableTimersMixin`** - Replaces `Future.delayed` with `delayed()` and `delayedChain()` that auto-cancel on dispose (prevents timer leaks in tests).
- **`AnimationTimings`** - Centralized timing constants per widget (`SonicManiaTiming`, `Persona5Timing`, `EvangelionTiming`, `MarioMakerTiming`).

### Widget Modules

Each widget follows the same internal structure:

```
lib/<widget_name>/
├── <widget_name>_title.dart   # Main public widget (extends BaseTitleWidget)
├── constants/                 # Colors, sizes, timing references
├── painters/                  # CustomPainters for visual effects
├── clippers/                  # CustomClippers for shape masking
└── widgets/                   # Private sub-widgets + barrel file
```

The 4 widgets: `SonicManiaSplash`, `Persona5Title`, `EvangelionTitle`, `MarioMakerTitle`.

### Key Patterns

- **Static Path/Paint caching** in CustomPainters and CustomClippers - paths are created once in static fields, not on every `paint()`/`getClip()` call. This is critical for performance.
- **Barrel files** in every `widgets/` and `clippers/` folder.
- **`CancelableTimersMixin`** used instead of raw `Future.delayed` everywhere - all timer-based animations go through `delayed()` or `delayedChain()`.
- **Image precaching** in `didChangeDependencies` for widgets that use images (Persona 5, Mario Maker).
- **`CachedBlurWidget`** in Evangelion uses `RenderRepaintBoundary` to capture and cache blurred renders.

### Test Structure

Tests mirror `lib/` structure. Categories:
- **Widget tests** (`test/<widget>/`) - pump widgets, advance timers with `tester.pump(duration)`, verify phases and visual state
- **Performance tests** (`test/performance/`) - allocation tracking for painters/clippers, jank detection
- **Benchmarks** (`benchmark/`) - frame timing, baseline comparison with `baseline.json`
- **Integration tests** (`example/integration_test/`) - real device performance validation

### Fonts

4 custom TTF fonts bundled in `lib/fonts/`, declared as package fonts in `pubspec.yaml` with families: `ManiaZoneCard`, `EVAMatisseClassic`, `Persona`, `BouCollege`.

## Linting

Uses `very_good_analysis` with no custom overrides. The parent project CLAUDE.md allows lines over 80 chars - follow that convention here too.
