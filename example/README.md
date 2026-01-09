# Fancy Titles Example

Example app demonstrating all `fancy_titles` widgets.

## Running the Example

```bash
cd example
flutter run
```

## Integration Tests

Integration tests measure real-world performance on actual devices or emulators.
Unlike unit tests, these run the full animation cycle and capture frame timing data.

### Available Tests

| Test File | Widget | Description |
| --- | --- | --- |
| `evangelion_performance_test.dart` | EvangelionTitle | Frame timing, phases, text rendering |
| `sonic_mania_performance_test.dart` | SonicManiaSplash | Frame timing, phases, text variants |
| `persona_5_performance_test.dart` | Persona5Title | Frame timing, phases, image/blend modes |
| `mario_maker_performance_test.dart` | MarioMakerTitle | Frame timing, phases, iris-out effects |

### Running Integration Tests

**Prerequisites:** A connected device or running emulator.

```bash
# Navigate to example directory
cd example

# Run all integration tests
flutter test integration_test/

# Run a specific test
flutter test integration_test/sonic_mania_performance_test.dart

# Run on a specific device
flutter test integration_test/ -d <device_id>

# Run with performance profiling
flutter test integration_test/ --profile
```

### Test Coverage

Each integration test validates:

1. **Frame Timing** - Measures actual frame durations during animation
2. **Jank Detection** - Ensures less than 5% of frames exceed 16ms
3. **Animation Phases** - Verifies all phases (entering, active, exiting, completed)
4. **Text/Content Rendering** - Confirms content appears at the correct time
5. **Custom Parameters** - Tests widget configuration options

### Interpreting Results

Sample output:

```text
SonicManiaSplash Integration Performance:
  Total frames: 312
  Average frame time: 2345us (2.35ms)
  Jank frames: 3 (0.96%)
  Max frame time: 18ms
```

- **Total frames**: Number of frames rendered during the animation
- **Average frame time**: Should be well under 16ms (16666us) for 60fps
- **Jank frames**: Frames taking longer than 16ms (target: < 5%)
- **Max frame time**: Worst-case frame duration
