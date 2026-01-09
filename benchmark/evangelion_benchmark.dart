/// Performance benchmark tests for EvangelionTitle widget.
///
/// These tests measure initial render performance and validate animation
/// lifecycle. Full frame-by-frame benchmarking requires integration tests
/// due to CachedBlurWidget using RenderRepaintBoundary.toImage().
///
/// For comprehensive performance testing of EvangelionTitle, use:
/// - flutter drive --target=test_driver/evangelion_perf.dart
library;

import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/frame_metrics.dart';
import 'utils/print_helpers.dart';

void main() {
  group('EvangelionTitle Performance', () {
    late FrameMetrics metrics;

    setUp(() {
      metrics = FrameMetrics();
    });

    testWidgets('benchmark initial render', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        const MaterialApp(
          home: EvangelionTitle(),
        ),
      );

      stopwatch.stop();

      printInitialRender('EvangelionTitle', stopwatch.elapsedMilliseconds);

      // EvangelionTitle has more complex rendering with text styles,
      // so we allow a higher threshold
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(200),
        reason: 'Initial render should complete in under 200ms',
      );
    });

    testWidgets('benchmark verifies animation callbacks', (tester) async {
      var startCalled = false;
      var completeCalled = false;
      final phases = <AnimationPhase>[];

      await tester.pumpWidget(
        MaterialApp(
          home: EvangelionTitle(
            onAnimationStart: () => startCalled = true,
            onAnimationComplete: () => completeCalled = true,
            onPhaseChange: phases.add,
          ),
        ),
      );

      expect(startCalled, isTrue, reason: 'onAnimationStart should be called');
      expect(phases, contains(AnimationPhase.entering));

      // Skip to end
      await tester.pump(EvangelionTiming.totalDuration);

      expect(completeCalled, isTrue);
      expect(phases, contains(AnimationPhase.completed));

      printLine('EvangelionTitle: Animation lifecycle verified');
      printLine('  Phases recorded: ${phases.length}');
    });

    testWidgets('benchmark renders all text lines', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EvangelionTitle(),
        ),
      );

      // Advance to when text is visible
      await tester.pump(EvangelionTiming.textAppearDelay);
      await tester.pump(); // Rebuild

      // Verify text is rendered
      expect(find.text('NEON'), findsOneWidget);
      expect(find.text('GENESIS'), findsOneWidget);
      expect(find.text('EVANGELION'), findsOneWidget);
      expect(find.text('EPISODE:1'), findsOneWidget);
      expect(find.text('ANGEL ATTACK'), findsOneWidget);

      printLine('EvangelionTitle: All 5 text lines render correctly');
    });

    testWidgets('benchmark custom text content', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        const MaterialApp(
          home: EvangelionTitle(
            firstText: 'SHIN',
            secondText: 'EVANGELION',
            thirdText: 'MOVIE',
            fourthText: '3.0+1.0',
            fifthText: 'THRICE UPON A TIME',
          ),
        ),
      );

      stopwatch.stop();
      metrics.recordFrame(stopwatch.elapsed);

      // Advance to text visible
      await tester.pump(EvangelionTiming.textAppearDelay);
      await tester.pump();

      // Verify custom text
      expect(find.text('SHIN'), findsOneWidget);
      expect(find.text('MOVIE'), findsOneWidget);
      expect(find.text('THRICE UPON A TIME'), findsOneWidget);

      printLine(
        'EvangelionTitle Custom Text: Render '
        '${stopwatch.elapsedMilliseconds}ms',
      );
    });

    testWidgets('benchmark phase transition timing', (tester) async {
      final phases = <AnimationPhase>[];
      final phaseTimestamps = <AnimationPhase, Duration>{};
      final startTime = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: EvangelionTitle(
            onPhaseChange: (phase) {
              phases.add(phase);
              phaseTimestamps[phase] = DateTime.now().difference(startTime);
            },
          ),
        ),
      );

      // Advance through all phases
      await tester.pump(EvangelionTiming.textAppearDelay);
      await tester.pump(
        EvangelionTiming.backgroundFadeTime - EvangelionTiming.textAppearDelay,
      );
      await tester.pump(
        EvangelionTiming.totalDuration - EvangelionTiming.backgroundFadeTime,
      );

      printLine('EvangelionTitle Phase Transitions:');
      printLine('  Total phases: ${phases.length}');
      for (final phase in phases) {
        printLine('  - $phase');
      }

      expect(phases, contains(AnimationPhase.entering));
      expect(phases, contains(AnimationPhase.active));
      expect(phases, contains(AnimationPhase.exiting));
      expect(phases, contains(AnimationPhase.completed));
    });

    testWidgets('benchmark animation completes without errors', (tester) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: EvangelionTitle(
            onAnimationComplete: () => completed = true,
          ),
        ),
      );

      // Skip to end
      await tester.pump(EvangelionTiming.totalDuration);

      expect(completed, isTrue);
      printLine('EvangelionTitle: Animation completes successfully at 5s');
    });
  });
}
