/// Integration test for Persona5Title frame-by-frame performance.
///
/// This test runs on a real device or emulator to measure actual
/// frame timings during the animation.
///
/// Run with:
/// ```bash
/// flutter test integration_test/persona_5_performance_test.dart
/// ```
///
/// Or on a specific device:
/// ```bash
/// flutter test integration_test/persona_5_performance_test.dart -d <device_id>
/// ```
library;

import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Persona5Title Integration Performance', () {
    testWidgets('full animation frame timing', (tester) async {
      final frameTimings = <Duration>[];
      Duration? lastFrameTimestamp;

      // Record frame timings using scheduler callback
      void frameCallback(Duration timestamp) {
        if (lastFrameTimestamp != null) {
          final frameDuration = timestamp - lastFrameTimestamp!;
          frameTimings.add(frameDuration);
        }
        lastFrameTimestamp = timestamp;
        SchedulerBinding.instance.scheduleFrameCallback(frameCallback);
      }

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Persona5Title(
              text: 'TAKE YOUR TIME',
            ),
          ),
        ),
      );

      // Start frame timing
      SchedulerBinding.instance.scheduleFrameCallback(frameCallback);

      // Run animation for full duration
      await tester.pumpAndSettle(
        const Duration(milliseconds: 16),
        EnginePhase.sendSemanticsUpdate,
        Persona5Timing.totalDuration + const Duration(seconds: 1),
      );

      // Calculate metrics
      if (frameTimings.isNotEmpty) {
        final avgFrameTime = frameTimings.fold<int>(
              0,
              (sum, d) => sum + d.inMicroseconds,
            ) ~/
            frameTimings.length;

        final jankFrames = frameTimings.where(
          (d) => d.inMilliseconds > 16,
        );

        final jankPercentage = frameTimings.isEmpty
            ? 0.0
            : (jankFrames.length / frameTimings.length) * 100;

        final maxFrameTime = frameTimings.reduce(
          (a, b) => a > b ? a : b,
        );

        // Output is intentional for benchmark results reporting.
        // ignore: avoid_print
        print('''
Persona5Title Integration Performance:
  Total frames: ${frameTimings.length}
  Average frame time: ${avgFrameTime}us (${(avgFrameTime / 1000).toStringAsFixed(2)}ms)
  Jank frames: ${jankFrames.length} (${jankPercentage.toStringAsFixed(2)}%)
  Max frame time: ${maxFrameTime.inMilliseconds}ms
''');

        // Assertions
        expect(
          jankPercentage,
          lessThan(5.0),
          reason: 'Jank percentage should be less than 5%',
        );
      }
    });

    testWidgets('measures frame build time', (tester) async {
      await binding.traceAction(
        () async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: Persona5Title(
                  text: 'LOOKING COOL JOKER',
                ),
              ),
            ),
          );

          // Run through the animation
          await tester.pumpAndSettle(
            const Duration(milliseconds: 16),
            EnginePhase.sendSemanticsUpdate,
            Persona5Timing.totalDuration + const Duration(seconds: 1),
          );
        },
        reportKey: 'persona_5_animation',
      );
    });

    testWidgets('animation phases complete correctly', (tester) async {
      var startCalled = false;
      var completeCalled = false;
      final phases = <AnimationPhase>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Persona5Title(
              text: 'ALL OUT ATTACK',
              onAnimationStart: () => startCalled = true,
              onAnimationComplete: () => completeCalled = true,
              onPhaseChange: phases.add,
            ),
          ),
        ),
      );

      expect(startCalled, isTrue);

      // Let animation complete
      await tester.pumpAndSettle(
        const Duration(milliseconds: 16),
        EnginePhase.sendSemanticsUpdate,
        Persona5Timing.totalDuration + const Duration(seconds: 1),
      );

      expect(completeCalled, isTrue);
      expect(phases, contains(AnimationPhase.entering));
      expect(phases, contains(AnimationPhase.active));
      expect(phases, contains(AnimationPhase.exiting));
      expect(phases, contains(AnimationPhase.completed));

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('Persona5Title Integration: Animation phases verified');
    });

    testWidgets('renders with image correctly', (tester) async {
      var completeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Persona5Title(
              text: 'SHOW TIME',
              imagePath: 'assets/persona-5.png',
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        ),
      );

      // Advance to when content is visible
      await tester.pump(Persona5Timing.textAppearDelay);
      await tester.pump(const Duration(milliseconds: 100));

      // Let animation complete
      await tester.pumpAndSettle(
        const Duration(milliseconds: 16),
        EnginePhase.sendSemanticsUpdate,
        Persona5Timing.totalDuration + const Duration(seconds: 1),
      );

      expect(completeCalled, isTrue);

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('Persona5Title Integration: Image mode works');
    });

    testWidgets('custom duration works correctly', (tester) async {
      const customDuration = Duration(seconds: 2);
      var completeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Persona5Title(
              text: 'FAST MODE',
              duration: customDuration,
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        ),
      );

      // Wait less than custom duration - should not be complete
      await tester.pump(const Duration(seconds: 1));
      expect(completeCalled, isFalse);

      // Let animation complete (total = delay + duration + fade)
      await tester.pumpAndSettle(
        const Duration(milliseconds: 16),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );

      expect(completeCalled, isTrue);

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('Persona5Title Integration: Custom duration works');
    });

    testWidgets('with blend mode performs well', (tester) async {
      final frameTimings = <Duration>[];
      Duration? lastFrameTimestamp;

      void frameCallback(Duration timestamp) {
        if (lastFrameTimestamp != null) {
          final frameDuration = timestamp - lastFrameTimestamp!;
          frameTimings.add(frameDuration);
        }
        lastFrameTimestamp = timestamp;
        SchedulerBinding.instance.scheduleFrameCallback(frameCallback);
      }

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Persona5Title(
              text: 'BLEND MODE TEST',
              imagePath: 'assets/persona-5.png',
              withImageBlendMode: true,
            ),
          ),
        ),
      );

      SchedulerBinding.instance.scheduleFrameCallback(frameCallback);

      await tester.pumpAndSettle(
        const Duration(milliseconds: 16),
        EnginePhase.sendSemanticsUpdate,
        Persona5Timing.totalDuration + const Duration(seconds: 1),
      );

      if (frameTimings.isNotEmpty) {
        final jankFrames = frameTimings.where(
          (d) => d.inMilliseconds > 16,
        );
        final jankPercentage =
            (jankFrames.length / frameTimings.length) * 100;

        expect(
          jankPercentage,
          lessThan(5.0),
          reason: 'Jank with blend mode should be less than 5%',
        );

        // Output is intentional for benchmark results reporting.
        // ignore: avoid_print
        print(
          'Persona5Title Integration: '
          'Blend mode jank ${jankPercentage.toStringAsFixed(2)}%',
        );
      }
    });
  });
}
