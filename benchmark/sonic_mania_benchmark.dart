/// Performance benchmark tests for SonicManiaSplash widget.
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
  group('SonicManiaSplash Performance', () {
    late FrameMetrics metrics;

    setUp(() {
      metrics = FrameMetrics();
    });

    testWidgets('benchmark full animation cycle', (tester) async {
      final stopwatch = Stopwatch();

      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaSplash(
            baseText: 'BENCHMARK',
            secondaryText: 'TEST',
            lastText: 'RUN',
          ),
        ),
      );

      // Run animation for full duration (5 seconds)
      const totalDuration = SonicManiaTiming.totalDuration;
      const frameInterval = Duration(milliseconds: 16); // ~60fps

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

      printMetrics('SonicManiaSplash Full Animation:', metrics);

      // Assertions for 60fps target
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
        MaterialApp(
          home: SonicManiaSplash(
            baseText: 'TEST',
          ),
        ),
      );

      stopwatch.stop();

      printInitialRender('SonicManiaSplash', stopwatch.elapsedMilliseconds);

      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(100),
        reason: 'Initial render should complete in under 100ms',
      );
    });

    testWidgets('benchmark slide-in animation phase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaSplash(
            baseText: 'TEST',
            secondaryText: 'ZONE',
          ),
        ),
      );

      // Measure slide-in phase (600ms)
      const slideInDuration = SonicManiaTiming.slideIn;
      final stopwatch = Stopwatch();
      var frameCount = 0;

      for (var i = 0; i < slideInDuration.inMilliseconds; i += 16) {
        stopwatch
          ..reset()
          ..start();

        await tester.pump(const Duration(milliseconds: 16));

        stopwatch.stop();
        metrics.recordFrame(stopwatch.elapsed);
        frameCount++;
      }

      printLine('SonicManiaSplash Slide-in animation:');
      printLine('  Frames: $frameCount');
      printPhaseMetrics(
        '',
        metrics.averageFrameTime.inMicroseconds,
        metrics.jankPercentage,
      );

      expect(
        metrics.jankPercentage,
        lessThan(5.0),
        reason: 'Slide-in should have less than 5% jank',
      );
    });

    testWidgets('benchmark with all three text lines', (tester) async {
      final stopwatch = Stopwatch();

      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaSplash(
            baseText: 'STUDIOPOLIS',
            secondaryText: 'ZONE',
            lastText: 'ACT1',
          ),
        ),
      );

      // Run for 2 seconds to capture most animations
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

      printMetrics('SonicManiaSplash Three Text Lines (2s sample):', metrics);

      expect(
        metrics.jankPercentage,
        lessThan(2.0),
        reason: 'Three text lines should maintain low jank',
      );
    });

    testWidgets('benchmark clipped bars animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaSplash(
            baseText: 'TEST',
          ),
        ),
      );

      // Skip to when clipped bars appear (725ms)
      await tester.pump(SonicManiaTiming.clippedBarInitialDelay);

      final stopwatch = Stopwatch();
      metrics.reset();

      // Measure 1 second of clipped bar animation
      for (var i = 0; i < 60; i++) {
        stopwatch
          ..reset()
          ..start();

        await tester.pump(const Duration(milliseconds: 16));

        stopwatch.stop();
        metrics.recordFrame(stopwatch.elapsed);
      }

      printMetrics('SonicManiaSplash Clipped Bars Animation:', metrics);

      expect(
        metrics.jankPercentage,
        lessThan(2.0),
        reason: 'Clipped bars should animate smoothly',
      );
    });
  });
}
