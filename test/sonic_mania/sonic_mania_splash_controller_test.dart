import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SonicManiaSplash with controller', () {
    group('instantiation', () {
      test('can be instantiated with controller', () {
        final controller = SonicManiaSplashController();
        expect(
          SonicManiaSplash(
            baseText: 'TEST',
            controller: controller,
          ),
          isNotNull,
        );
      });
    });

    group('controller integration', () {
      testWidgets('controller receives phase updates', (tester) async {
        final controller = SonicManiaSplashController();

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              controller: controller,
            ),
          ),
        );

        // Should be in entering phase after build
        expect(controller.currentPhase, equals(AnimationPhase.entering));

        // Advance to active phase
        await tester.pump(SonicManiaTiming.slideIn);
        expect(controller.currentPhase, equals(AnimationPhase.active));

        // Advance to exiting phase
        await tester.pump(
          SonicManiaTiming.slideOutDelay - SonicManiaTiming.slideIn,
        );
        expect(controller.currentPhase, equals(AnimationPhase.exiting));

        // Advance to completed phase
        await tester.pump(
          SonicManiaTiming.totalDuration - SonicManiaTiming.slideOutDelay,
        );
        expect(controller.currentPhase, equals(AnimationPhase.completed));
      });

      testWidgets('pause() sets controller isPaused state', (tester) async {
        final controller = SonicManiaSplashController();

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              controller: controller,
            ),
          ),
        );

        expect(controller.isPaused, isFalse);

        // Pause
        controller.pause();

        expect(controller.isPaused, isTrue);

        // Resume
        controller.resume();

        expect(controller.isPaused, isFalse);
      });

      testWidgets('resume() continues animation after pause', (tester) async {
        final controller = SonicManiaSplashController();
        final phases = <AnimationPhase>[];

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              controller: controller,
              onPhaseChange: phases.add,
            ),
          ),
        );

        // Pause
        controller.pause();
        await tester.pump(const Duration(milliseconds: 300));

        // Resume
        controller.resume();

        // Continue advancing
        await tester.pump(SonicManiaTiming.slideIn);
        expect(phases, contains(AnimationPhase.active));
      });

      testWidgets('skipToEnd() completes animation immediately',
          (tester) async {
        final controller = SonicManiaSplashController();
        var completeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              controller: controller,
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        );

        expect(completeCalled, isFalse);
        expect(controller.currentPhase, equals(AnimationPhase.entering));

        // Skip to end
        controller.skipToEnd();
        await tester.pump();

        expect(completeCalled, isTrue);
        expect(controller.currentPhase, equals(AnimationPhase.completed));
      });

      testWidgets('reset() restarts animation', (tester) async {
        final controller = SonicManiaSplashController();
        var startCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              controller: controller,
              onAnimationStart: () => startCount++,
            ),
          ),
        );

        expect(startCount, equals(1));

        // Complete the animation
        await tester.pump(SonicManiaTiming.totalDuration);
        expect(controller.currentPhase, equals(AnimationPhase.completed));

        // Reset
        controller.reset();
        await tester.pump();

        expect(startCount, equals(2));
        expect(controller.currentPhase, equals(AnimationPhase.entering));
      });

      testWidgets('controller can be used to listen to state changes',
          (tester) async {
        final controller = SonicManiaSplashController();
        var listenerCallCount = 0;

        controller.addListener(() => listenerCallCount++);

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              controller: controller,
            ),
          ),
        );

        controller.pause();
        expect(listenerCallCount, equals(1));

        controller.resume();
        expect(listenerCallCount, equals(2));

        controller.skipToEnd();
        expect(listenerCallCount, equals(3));
      });
    });

    group('widget behavior with controller', () {
      testWidgets('widget still works without controller', (tester) async {
        final phases = <AnimationPhase>[];

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              onPhaseChange: phases.add,
            ),
          ),
        );

        expect(phases, contains(AnimationPhase.entering));

        await tester.pump(SonicManiaTiming.slideIn);
        expect(phases, contains(AnimationPhase.active));
      });

      testWidgets('widget auto-destructs even with controller',
          (tester) async {
        final controller = SonicManiaSplashController();

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              controller: controller,
            ),
          ),
        );

        await tester.pump(SonicManiaTiming.totalDuration);
        await tester.pump(SonicManiaTiming.fadeTransition);

        expect(controller.isCompleted, isTrue);
      });

    });
  });
}
