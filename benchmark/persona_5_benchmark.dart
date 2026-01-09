/// Performance benchmark tests for Persona5Title widget.
///
/// These tests measure frame timing, jank percentage, and initial render
/// performance to validate the optimizations from OPT-006.
library;

import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/frame_metrics.dart';
import 'utils/print_helpers.dart';

void main() {
  group('Persona5Title Performance', () {
    late FrameMetrics metrics;

    setUp(() {
      metrics = FrameMetrics();
    });

    testWidgets('benchmark full animation cycle', (tester) async {
      final stopwatch = Stopwatch();

      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(
            text: 'TAKE YOUR TIME',
          ),
        ),
      );

      // Run animation for full duration (4 seconds)
      const totalDuration = Persona5Timing.totalDuration;
      const frameInterval = Duration(milliseconds: 16);

      var elapsed = Duration.zero;
      while (elapsed < totalDuration) {
        stopwatch
          ..reset()
          ..start();

        await tester.pump(frameInterval);

        stopwatch.stop();
        metrics.recordFrame(stopwatch.elapsed);

        elapsed += frameInterval;
      }

      printMetrics('Persona5Title Full Animation:', metrics);

      expect(
        metrics.jankPercentage,
        lessThan(1.0),
        reason: 'Jank frames should be less than 1%',
      );

      expect(
        metrics.averageFrameTime.inMilliseconds,
        lessThan(16),
        reason: 'Average frame time should be under 16ms for 60fps',
      );
    });

    testWidgets('benchmark initial render', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(
            text: 'BENCHMARK',
          ),
        ),
      );

      stopwatch.stop();

      printInitialRender('Persona5Title', stopwatch.elapsedMilliseconds);

      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(100),
        reason: 'Initial render should complete in under 100ms',
      );
    });

    testWidgets('benchmark circle transition phase', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(
            text: 'TEST',
          ),
        ),
      );

      // Skip initial delay
      await tester.pump(Persona5Timing.initialDelay);

      final stopwatch = Stopwatch();
      metrics.reset();

      // Measure circle transition (325ms)
      for (var i = 0;
          i < Persona5Timing.circleTransitionDuration.inMilliseconds;
          i += 16) {
        stopwatch
          ..reset()
          ..start();

        await tester.pump(const Duration(milliseconds: 16));

        stopwatch.stop();
        metrics.recordFrame(stopwatch.elapsed);
      }

      printPhaseMetrics(
        'Persona5Title Circle Transition:',
        metrics.averageFrameTime.inMicroseconds,
        metrics.jankPercentage,
      );

      expect(
        metrics.jankPercentage,
        lessThan(5.0),
        reason: 'Circle transition should have less than 5% jank',
      );
    });

    testWidgets('benchmark text slide-in animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(
            text: 'LOOKING COOL JOKER',
          ),
        ),
      );

      // Skip to text appear time
      await tester.pump(Persona5Timing.textAppearDelay);

      final stopwatch = Stopwatch();
      metrics.reset();

      // Measure text slide-in (225ms fade transition)
      for (var i = 0;
          i < Persona5Timing.fadeTransitionReverse.inMilliseconds;
          i += 16) {
        stopwatch
          ..reset()
          ..start();

        await tester.pump(const Duration(milliseconds: 16));

        stopwatch.stop();
        metrics.recordFrame(stopwatch.elapsed);
      }

      printMetrics('Persona5Title Text Slide-in:', metrics);

      expect(
        metrics.jankPercentage,
        lessThan(5.0),
        reason: 'Text slide-in should have less than 5% jank',
      );
    });

    testWidgets('benchmark with custom duration', (tester) async {
      final stopwatch = Stopwatch();

      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(
            text: 'CUSTOM DURATION',
            duration: Duration(seconds: 2),
          ),
        ),
      );

      // Run for custom duration
      const testDuration = Duration(seconds: 2);
      var elapsed = Duration.zero;

      while (elapsed < testDuration) {
        stopwatch
          ..reset()
          ..start();

        await tester.pump(const Duration(milliseconds: 16));

        stopwatch.stop();
        metrics.recordFrame(stopwatch.elapsed);

        elapsed += const Duration(milliseconds: 16);
      }

      printMetrics('Persona5Title Custom Duration (2s):', metrics);

      expect(
        metrics.jankPercentage,
        lessThan(2.0),
        reason: 'Custom duration should maintain low jank',
      );
    });

    testWidgets('benchmark exit phase', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(
            text: 'EXIT TEST',
          ),
        ),
      );

      // Skip to just before exit (mainDuration is 3400ms)
      await tester.pump(
        Persona5Timing.initialDelay + Persona5Timing.mainDuration,
      );

      final stopwatch = Stopwatch();
      metrics.reset();

      // Measure exit animation (600ms until totalDuration)
      const exitDuration = Duration(milliseconds: 600);
      var elapsed = Duration.zero;

      while (elapsed < exitDuration) {
        stopwatch
          ..reset()
          ..start();

        await tester.pump(const Duration(milliseconds: 16));

        stopwatch.stop();
        metrics.recordFrame(stopwatch.elapsed);

        elapsed += const Duration(milliseconds: 16);
      }

      printMetrics('Persona5Title Exit Phase:', metrics);

      expect(
        metrics.jankPercentage,
        lessThan(5.0),
        reason: 'Exit phase should have less than 5% jank',
      );
    });
  });
}
