# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-08

### Added

- **Animation Controllers** for programmatic control of animations:
  - `SonicManiaSplashController` - Control SonicManiaSplash animations
  - `Persona5TitleController` - Control Persona5Title animations
  - `EvangelionTitleController` - Control EvangelionTitle animations
  - `MarioMakerTitleController` - Control MarioMakerTitle animations
  - Methods: `pause()`, `resume()`, `skipToEnd()`, `reset()`
  - Properties: `currentPhase`, `isPaused`, `isCompleted`
- **Theme System** for complete color customization:
  - `SonicManiaTheme` with `SonicManiaBarColors`, `SonicManiaCurtainColors`, `SonicManiaTextBarColors`
  - `Persona5Theme` with `Persona5CircleColors`, `Persona5TextColors`
  - `EvangelionTheme` with `EvangelionTextColors`, `EvangelionCurtainColors`
  - `MarioMakerTheme` with `MarioMakerBackgroundColors`
- Core infrastructure:
  - `FancyTitleController` base class with `ChangeNotifier`
  - `FancyTitleControllerScope` for propagating controller state
  - `PausableAnimationMixin` with `PausableTimer` for pause/resume support
  - Theme scope widgets for each module
- 150 new tests for controllers and themes (912 total tests)

### Changed

- All main widgets now accept optional `controller` parameter
- All main widgets now accept optional `theme` parameter
- Updated README.md with comprehensive Controllers and Themes documentation
- Internal widgets modified to support theme color resolution

### Performance

- No performance regressions; maintains <16ms frame times
- Controllers use efficient `ChangeNotifier` pattern
- Themes use `InheritedWidget` for optimal rebuilds

## [1.0.6] - 2026-01-08

### Added

- Path caching in 21 CustomPainters and CustomClippers to reduce jank frames
  - Evangelion: 11 painters (6 cross + 5 curtain) with static Path cache
  - SonicMania: 6 clippers (4 bar + 2 curtain) with static Path cache
  - SonicMania: 2 painters (LargeBGDraw + SmallBGDraw) with static Path cache
  - MarioMaker: CircleMaskClipper with static Path cache
- Pre-created static Paint objects in CirclePainter (Persona5)
- Static TweenSequence in ExpandingCircleMask (MarioMaker)
- Complete dartdoc documentation for 7 internal widgets

### Changed

- CirclePainter now uses drawOval instead of drawPath for better performance
- Updated README.md with callbacks section
- Reduced estimated allocations per frame from ~60 to ~5

### Performance

- Eliminated Path object creation in paint() and getClip() methods
- Reduced GC pressure during animations
- Frame times consistently under 16ms target for 60fps

## [1.0.5] - 2026-01-08

### Changed

- Migrated 17 hardcoded Duration instances to centralized constants
  - SonicMania: 14 instances (clipped_bar.dart, clipped_curtain.dart)
  - Evangelion: 1 instance (cached_blur_widget.dart)
  - MarioMaker: 2 instances (bouncing_circle.dart)
- Updated animation_timings.dart with 17 new constants:
  - SonicManiaTiming: clippedBar* and clippedCurtain* constants
  - EvangelionTiming: blurCacheDelay
  - MarioMakerTiming: bounceDurationDefault, imageScaleOutDuration
- Improved README.md with detailed examples and GIFs for all widgets
- Added 25 new tests for OPT-005 timing constants

### Fixed

- None (package in stable state)

## [1.0.4] - 2026-01-07

### Added

- Direct tests for all internal widgets (23/23)
- 739 tests with 97.8% coverage
- Golden tests for all 4 main widgets

### Changed

- Optimized shouldRepaint() in all painters
- Centralized animation timings (44 constants in 4 classes)

### Fixed

- Fixed 9 lint warnings
- Removed deprecated API usage

## [1.0.3] - 2026-01-06

### Added

- Comprehensive test suite (OPT-003)
- Tests for all painters, clippers, and widgets
- Edge case testing for animation phases

### Changed

- Improved test organization with dedicated folders per module

## [1.0.2] - 2026-01-05

### Added

- Initial golden tests for visual regression
- Widget tests for main splash screens
- Animation phase testing

### Changed

- Consolidated timing constants to core/animation_timings.dart

## [1.0.1] - 2026-01-04

### Added

- Cancelable timers mixin (CancelableTimers)
- Animation lifecycle callbacks (onAnimationStart, onAnimationComplete)
- API documentation for all public widgets

### Changed

- Unified directory structure across all modules
- Normalized naming conventions

### Fixed

- Memory leaks from uncanceled timers
- setState after dispose errors

## [1.0.0] - 2026-01-01

### Added

- Initial release with 4 splash screen widgets:
  - SonicManiaSplash - Inspired by Sonic Mania level cards
  - Persona5Title - Inspired by Persona 5 chapter titles
  - EvangelionTitle - Inspired by Neon Genesis Evangelion episode titles
  - MarioMakerTitle - Inspired by Super Mario Maker course reveals
- Custom fonts: ManiaZoneCard, Persona, EVAMatisseClassic
- Responsive design for portrait and landscape modes
- Example app demonstrating all widgets
