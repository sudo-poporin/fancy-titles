/// Integration test for EvangelionTitle frame-by-frame performance.
///
/// This test requires a device or emulator to run because CachedBlurWidget
/// uses RenderRepaintBoundary.toImage() which doesn't work in widget tests.
///
/// Run with:
/// ```bash
/// flutter test integration_test/evangelion_performance_test.dart
/// ```
///
/// Or on a specific device:
/// ```bash
/// flutter test integration_test/evangelion_performance_test.dart -d <device_id>
/// ```
library;

import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('EvangelionTitle Integration Performance', () {
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
            body: EvangelionTitle(),
          ),
        ),
      );

      // Start frame timing
      SchedulerBinding.instance.scheduleFrameCallback(frameCallback);

      // Run animation for full duration
      await tester.pumpAndSettle(
        const Duration(milliseconds: 16),
        EnginePhase.sendSemanticsUpdate,
        EvangelionTiming.totalDuration + const Duration(seconds: 1),
      );

      // Stop frame recording by not scheduling more callbacks
      // (Dart's GC will clean up the callback reference)

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
EvangelionTitle Integration Performance:
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
                body: EvangelionTitle(),
              ),
            ),
          );

          // Run through the animation
          await tester.pumpAndSettle(
            const Duration(milliseconds: 16),
            EnginePhase.sendSemanticsUpdate,
            EvangelionTiming.totalDuration + const Duration(seconds: 1),
          );
        },
        reportKey: 'evangelion_animation',
      );
    });

    testWidgets('animation phases complete correctly', (tester) async {
      var startCalled = false;
      var completeCalled = false;
      final phases = <AnimationPhase>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EvangelionTitle(
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
        EvangelionTiming.totalDuration + const Duration(seconds: 1),
      );

      expect(completeCalled, isTrue);
      expect(phases, contains(AnimationPhase.entering));
      expect(phases, contains(AnimationPhase.active));
      expect(phases, contains(AnimationPhase.exiting));
      expect(phases, contains(AnimationPhase.completed));

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('EvangelionTitle Integration: Animation phases verified');
    });

    testWidgets('renders text correctly during animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EvangelionTitle(),
          ),
        ),
      );

      // Advance to when text is visible
      await tester.pump(EvangelionTiming.textAppearDelay);
      await tester.pump(const Duration(milliseconds: 100));

      // Verify default text renders
      expect(find.text('NEON'), findsOneWidget);
      expect(find.text('GENESIS'), findsOneWidget);
      expect(find.text('EVANGELION'), findsOneWidget);

      // Output is intentional for benchmark results reporting.
      // ignore: avoid_print
      print('EvangelionTitle Integration: Text renders correctly');
    });
  });
}
