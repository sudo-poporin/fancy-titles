/// Performance benchmark tests for MarioMakerTitle widget.
///
/// These tests measure frame timing, jank percentage, and initial render
/// performance to validate the optimizations from OPT-006.
///
/// Uses test assets from test/fixtures/:
/// - test_image.png (1.8KB) - for standard tests
/// - large_image.png (97KB) - for stress tests
library;

import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/frame_metrics.dart';
import 'utils/print_helpers.dart';

void main() {
  group('MarioMakerTitle Performance', () {
    late FrameMetrics metrics;

    setUp(() {
      metrics = FrameMetrics();
    });

    testWidgets('benchmark full animation cycle', (tester) async {
      final stopwatch = Stopwatch();

      await tester.pumpWidget(
        const MaterialApp(
          home: MarioMakerTitle(
            title: 'WORLD 1-1',
            imagePath: 'test/fixtures/test_image.png',
          ),
        ),
      );

      // Run animation for full duration (4 seconds)
      const totalDuration = MarioMakerTiming.defaultTotalDuration;
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

      // Ensure all timers complete
      await tester.pump(const Duration(seconds: 1));

      printMetrics('MarioMakerTitle Full Animation:', metrics);

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
          home: MarioMakerTitle(
            title: 'TEST',
            imagePath: 'test/fixtures/test_image.png',
          ),
        ),
      );

      stopwatch.stop();

      printInitialRender('MarioMakerTitle', stopwatch.elapsedMilliseconds);

      // Complete animation to avoid timer issues
      await tester.pump(MarioMakerTiming.defaultTotalDuration);
      await tester.pump(const Duration(seconds: 1));

      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(100),
        reason: 'Initial render should complete in under 100ms',
      );
    });

    testWidgets('benchmark with custom iris alignment', (tester) async {
      final stopwatch = Stopwatch();

      await tester.pumpWidget(
        const MaterialApp(
          home: MarioMakerTitle(
            title: 'CUSTOM IRIS',
            imagePath: 'test/fixtures/test_image.png',
            irisOutAlignment: Alignment.bottomRight,
            irisOutEdgePadding: 80,
          ),
        ),
      );

      // Run for full animation
      const totalDuration = MarioMakerTiming.defaultTotalDuration;
      var elapsed = Duration.zero;

      while (elapsed < totalDuration) {
        stopwatch
          ..reset()
          ..start();

        await tester.pump(const Duration(milliseconds: 16));

        stopwatch.stop();
        metrics.recordFrame(stopwatch.elapsed);

        elapsed += const Duration(milliseconds: 16);
      }

      // Ensure all timers complete
      await tester.pump(const Duration(seconds: 1));

      printMetrics('MarioMakerTitle Custom Iris:', metrics);

      expect(
        metrics.jankPercentage,
        lessThan(2.0),
        reason: 'Custom iris alignment should maintain low jank',
      );
    });

    testWidgets('benchmark with custom circle size', (tester) async {
      final stopwatch = Stopwatch();

      await tester.pumpWidget(
        const MaterialApp(
          home: MarioMakerTitle(
            title: 'LARGE CIRCLE',
            imagePath: 'test/fixtures/test_image.png',
            circleRadius: 120,
            bottomMargin: 150,
          ),
        ),
      );

      // Run for full animation
      const totalDuration = MarioMakerTiming.defaultTotalDuration;
      var elapsed = Duration.zero;

      while (elapsed < totalDuration) {
        stopwatch
          ..reset()
          ..start();

        await tester.pump(const Duration(milliseconds: 16));

        stopwatch.stop();
        metrics.recordFrame(stopwatch.elapsed);

        elapsed += const Duration(milliseconds: 16);
      }

      // Ensure all timers complete
      await tester.pump(const Duration(seconds: 1));

      printMetrics('MarioMakerTitle Large Circle:', metrics);

      expect(
        metrics.jankPercentage,
        lessThan(2.0),
        reason: 'Large circle should maintain low jank',
      );
    });

    testWidgets('benchmark animation lifecycle', (tester) async {
      var startCalled = false;
      var completeCalled = false;
      final phases = <AnimationPhase>[];

      await tester.pumpWidget(
        MaterialApp(
          home: MarioMakerTitle(
            title: 'LIFECYCLE',
            imagePath: 'test/fixtures/test_image.png',
            onAnimationStart: () => startCalled = true,
            onAnimationComplete: () => completeCalled = true,
            onPhaseChange: phases.add,
          ),
        ),
      );

      expect(startCalled, isTrue, reason: 'onAnimationStart should be called');

      // Complete animation
      await tester.pump(MarioMakerTiming.defaultTotalDuration);
      await tester.pump(const Duration(seconds: 1));

      expect(completeCalled, isTrue);

      printLine('MarioMakerTitle: Animation lifecycle verified');
      printLine('  Phases recorded: ${phases.length}');
    });

    testWidgets('stress test with large image (97KB)', (tester) async {
      final stopwatch = Stopwatch();

      // Initial render with large image
      final initialStopwatch = Stopwatch()..start();
      await tester.pumpWidget(
        const MaterialApp(
          home: MarioMakerTitle(
            title: 'STRESS TEST',
            imagePath: 'test/fixtures/large_image.png',
          ),
        ),
      );
      initialStopwatch.stop();

      // Run animation for full duration
      const totalDuration = MarioMakerTiming.defaultTotalDuration;
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

      // Ensure all timers complete
      await tester.pump(const Duration(seconds: 1));

      printLine('');
      printLine('MarioMakerTitle Stress Test (97KB image):');
      printLine('  Initial render: ${initialStopwatch.elapsedMilliseconds}ms');
      printMetrics('  Animation:', metrics);

      // Stress test has relaxed thresholds
      expect(
        metrics.jankPercentage,
        lessThan(5.0),
        reason: 'Large image should still maintain <5% jank',
      );

      expect(
        initialStopwatch.elapsedMilliseconds,
        lessThan(200),
        reason: 'Initial render with large image should complete in <200ms',
      );
    });
  });
}
