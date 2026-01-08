import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EvangelionTitleController', () {
    group('instantiation', () {
      test('can be instantiated', () {
        expect(EvangelionTitleController(), isNotNull);
      });

      test('starts with idle phase', () {
        final controller = EvangelionTitleController();
        expect(controller.currentPhase, equals(AnimationPhase.idle));
      });

      test('starts not paused', () {
        final controller = EvangelionTitleController();
        expect(controller.isPaused, isFalse);
      });

      test('starts not completed', () {
        final controller = EvangelionTitleController();
        expect(controller.isCompleted, isFalse);
      });
    });

    group('with widget', () {
      testWidgets('can be used with EvangelionTitle', (tester) async {
        final controller = EvangelionTitleController();

        await tester.pumpWidget(
          MaterialApp(
            home: EvangelionTitle(controller: controller),
          ),
        );

        expect(find.byType(EvangelionTitle), findsOneWidget);
        controller.dispose();
      });

      testWidgets('controller receives phase updates', (tester) async {
        final controller = EvangelionTitleController();

        await tester.pumpWidget(
          MaterialApp(
            home: EvangelionTitle(controller: controller),
          ),
        );

        // Initial phase should be entering
        expect(controller.currentPhase, equals(AnimationPhase.entering));

        controller.dispose();
      });
    });

    group('controller integration', () {
      testWidgets('pause() sets controller isPaused state', (tester) async {
        final controller = EvangelionTitleController();

        await tester.pumpWidget(
          MaterialApp(
            home: EvangelionTitle(controller: controller),
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));

        controller.pause();
        expect(controller.isPaused, isTrue);

        controller.dispose();
      });

      testWidgets('resume() continues animation after pause', (tester) async {
        final controller = EvangelionTitleController();

        await tester.pumpWidget(
          MaterialApp(
            home: EvangelionTitle(controller: controller),
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));

        controller.pause();
        expect(controller.isPaused, isTrue);

        controller.resume();
        expect(controller.isPaused, isFalse);

        controller.dispose();
      });

      testWidgets('skipToEnd() completes animation', (tester) async {
        final controller = EvangelionTitleController();
        var completeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: EvangelionTitle(
              controller: controller,
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));

        controller.skipToEnd();
        await tester.pump();

        expect(controller.isCompleted, isTrue);
        expect(completeCalled, isTrue);

        controller.dispose();
      });

      testWidgets('reset() restarts animation', (tester) async {
        final controller = EvangelionTitleController();
        var startCallCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: EvangelionTitle(
              controller: controller,
              onAnimationStart: () => startCallCount++,
            ),
          ),
        );

        // First start
        expect(startCallCount, equals(1));

        // Advance to active phase
        await tester.pump(EvangelionTiming.textAppearDelay);
        await tester.pump(const Duration(milliseconds: 100));

        // Reset
        controller.reset();
        await tester.pump();

        // Should be called again
        expect(startCallCount, equals(2));
        expect(controller.currentPhase, equals(AnimationPhase.entering));

        controller.dispose();
      });
    });

    group('dispose', () {
      test('can be disposed', () {
        final controller = EvangelionTitleController();
        expect(controller.dispose, returnsNormally);
      });

      testWidgets('widget handles controller disposal', (tester) async {
        final controller = EvangelionTitleController();

        await tester.pumpWidget(
          MaterialApp(
            home: EvangelionTitle(controller: controller),
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));

        controller.dispose();

        // Widget should continue without errors
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
      });
    });

    group('backward compatibility', () {
      testWidgets('widget still works without controller', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: EvangelionTitle(),
          ),
        );

        expect(find.byType(EvangelionTitle), findsOneWidget);

        // Advance animation
        await tester.pump(EvangelionTiming.totalDuration);
        await tester.pump(const Duration(milliseconds: 100));

        // Should auto-destruct
        expect(find.byType(SizedBox), findsWidgets);
      });
    });
  });
}
