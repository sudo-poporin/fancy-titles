/// Integration test for MarioMakerTitle frame-by-frame performance.
///
/// This test runs on a real device or emulator to measure actual
/// frame timings during the animation.
///
/// Run with:
/// ```bash
/// flutter test integration_test/mario_maker_performance_test.dart
/// ```
///
/// Or on a specific device:
/// ```bash
/// flutter test integration_test/mario_maker_performance_test.dart -d <device_id>
/// ```
library;

import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MarioMakerTitle Integration Performance', () {
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
            body: MarioMakerTitle(
              title: 'WORLD 1-1',
              imagePath: 'assets/luigi.png',
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
        MarioMakerTiming.defaultTotalDuration + const Duration(seconds: 1),
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
MarioMakerTitle Integration Performance:
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
                body: MarioMakerTitle(
                  title: 'BOSS STAGE',
                  imagePath: 'assets/luigi.png',
                ),
              ),
            ),
          );

          // Run through the animation
          await tester.pumpAndSettle(
            const Duration(milliseconds: 16),
            EnginePhase.sendSemanticsUpdate,
            MarioMakerTiming.defaultTotalDuration + const Duration(seconds: 1),
          );
        },
        reportKey: 'mario_maker_animation',
      );
    });

    testWidgets('animation phases complete correctly', (tester) async {
      var startCalled = false;
      var completeCalled = false;
      final phases = <AnimationPhase>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarioMakerTitle(
              title: 'TEST LEVEL',
              imagePath: 'assets/luigi.png',
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
        MarioMakerTiming.defaultTotalDuration + const Duration(seconds: 1),
      );

      expect(completeCalled, isTrue);
      expect(phases, contains(AnimationPhase.entering));
      expect(phases, contains(AnimationPhase.active));
      expect(phases, contains(AnimationPhase.exiting));
      expect(phases, contains(AnimationPhase.completed));

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('MarioMakerTitle Integration: Animation phases verified');
    });

    testWidgets('renders title correctly during animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MarioMakerTitle(
              title: 'SECRET EXIT',
              imagePath: 'assets/luigi.png',
            ),
          ),
        ),
      );

      // Advance to when title is visible (after title entry delay)
      await tester.pump(MarioMakerTiming.titleEntryDelay);
      await tester.pump(const Duration(milliseconds: 600));

      // Verify title renders
      expect(find.text('SECRET EXIT'), findsOneWidget);

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('MarioMakerTitle Integration: Title renders correctly');
    });

    testWidgets('custom iris-out alignment works', (tester) async {
      var completeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarioMakerTitle(
              title: 'CORNER EXIT',
              imagePath: 'assets/luigi.png',
              irisOutAlignment: Alignment.bottomRight,
              irisOutEdgePadding: 80,
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        ),
      );

      // Let animation complete
      await tester.pumpAndSettle(
        const Duration(milliseconds: 16),
        EnginePhase.sendSemanticsUpdate,
        MarioMakerTiming.defaultTotalDuration + const Duration(seconds: 1),
      );

      expect(completeCalled, isTrue);

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('MarioMakerTitle Integration: Custom iris-out alignment works');
    });

    testWidgets('custom duration works correctly', (tester) async {
      const customDuration = Duration(seconds: 2);
      var completeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarioMakerTitle(
              title: 'QUICK LEVEL',
              imagePath: 'assets/luigi.png',
              duration: customDuration,
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        ),
      );

      // Wait less than custom duration - should not be complete
      await tester.pump(const Duration(milliseconds: 1500));
      expect(completeCalled, isFalse);

      // Let animation complete
      await tester.pumpAndSettle(
        const Duration(milliseconds: 16),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 3),
      );

      expect(completeCalled, isTrue);

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('MarioMakerTitle Integration: Custom duration works');
    });

    testWidgets('bouncing circle performs well', (tester) async {
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
            body: MarioMakerTitle(
              title: 'BOUNCE TEST',
              imagePath: 'assets/luigi.png',
              circleRadius: 120,
            ),
          ),
        ),
      );

      SchedulerBinding.instance.scheduleFrameCallback(frameCallback);

      // Focus on bounce phase (first 1.2 seconds)
      await tester.pump(MarioMakerTiming.bounceDuration);

      if (frameTimings.isNotEmpty) {
        final jankFrames = frameTimings.where(
          (d) => d.inMilliseconds > 16,
        );
        final jankPercentage =
            (jankFrames.length / frameTimings.length) * 100;

        expect(
          jankPercentage,
          lessThan(5.0),
          reason: 'Bounce phase jank should be less than 5%',
        );

        // Output is intentional for benchmark results reporting.
        // ignore: avoid_print
        print(
          'MarioMakerTitle Integration: '
          'Bounce phase jank ${jankPercentage.toStringAsFixed(2)}%',
        );
      }
    });
  });
}
