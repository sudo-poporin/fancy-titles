/// Integration test for SonicManiaSplash frame-by-frame performance.
///
/// This test runs on a real device or emulator to measure actual
/// frame timings during the animation.
///
/// Run with:
/// ```bash
/// flutter test integration_test/sonic_mania_performance_test.dart
/// ```
///
/// Or on a specific device:
/// ```bash
/// flutter test integration_test/sonic_mania_performance_test.dart -d <device_id>
/// ```
library;

import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SonicManiaSplash Integration Performance', () {
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
        MaterialApp(
          home: Scaffold(
            body: SonicManiaSplash(
              baseText: 'GREEN HILL',
              secondaryText: 'ZONE',
              lastText: 'ACT1',
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
        SonicManiaTiming.totalDuration + const Duration(seconds: 1),
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
SonicManiaSplash Integration Performance:
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
            MaterialApp(
              home: Scaffold(
                body: SonicManiaSplash(
                  baseText: 'STUDIOPOLIS',
                  secondaryText: 'ZONE',
                  lastText: 'ACT2',
                ),
              ),
            ),
          );

          // Run through the animation
          await tester.pumpAndSettle(
            const Duration(milliseconds: 16),
            EnginePhase.sendSemanticsUpdate,
            SonicManiaTiming.totalDuration + const Duration(seconds: 1),
          );
        },
        reportKey: 'sonic_mania_animation',
      );
    });

    testWidgets('animation phases complete correctly', (tester) async {
      var startCalled = false;
      var completeCalled = false;
      final phases = <AnimationPhase>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SonicManiaSplash(
              baseText: 'TEST',
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
        SonicManiaTiming.totalDuration + const Duration(seconds: 1),
      );

      expect(completeCalled, isTrue);
      expect(phases, contains(AnimationPhase.entering));
      expect(phases, contains(AnimationPhase.active));
      expect(phases, contains(AnimationPhase.exiting));
      expect(phases, contains(AnimationPhase.completed));

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('SonicManiaSplash Integration: Animation phases verified');
    });

    testWidgets('renders text correctly during animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SonicManiaSplash(
              baseText: 'CHEMICAL PLANT',
              secondaryText: 'ZONE',
              lastText: 'ACT1',
            ),
          ),
        ),
      );

      // Advance to when text is visible (after slide in)
      await tester.pump(SonicManiaTiming.slideIn);
      await tester.pump(const Duration(milliseconds: 100));

      // Verify text renders (uppercase for base/secondary, lowercase for last)
      expect(find.text('CHEMICAL PLANT'), findsOneWidget);
      expect(find.text('ZONE'), findsOneWidget);
      expect(find.text('act1'), findsOneWidget);

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('SonicManiaSplash Integration: Text renders correctly');
    });

    testWidgets('works with single text only', (tester) async {
      var completeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SonicManiaSplash(
              baseText: 'TITLE ONLY',
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        ),
      );

      // Let animation complete
      await tester.pumpAndSettle(
        const Duration(milliseconds: 16),
        EnginePhase.sendSemanticsUpdate,
        SonicManiaTiming.totalDuration + const Duration(seconds: 1),
      );

      expect(completeCalled, isTrue);

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('SonicManiaSplash Integration: Single text mode works');
    });
  });
}
