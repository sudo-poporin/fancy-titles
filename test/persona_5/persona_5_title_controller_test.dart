import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Persona5TitleController', () {
    group('instantiation', () {
      test('can be instantiated', () {
        expect(Persona5TitleController(), isNotNull);
      });

      test('starts with idle phase', () {
        final controller = Persona5TitleController();
        expect(controller.currentPhase, equals(AnimationPhase.idle));
      });

      test('starts not paused', () {
        final controller = Persona5TitleController();
        expect(controller.isPaused, isFalse);
      });

      test('starts not completed', () {
        final controller = Persona5TitleController();
        expect(controller.isCompleted, isFalse);
      });
    });

    group('with widget', () {
      testWidgets('can be used with Persona5Title', (tester) async {
        final controller = Persona5TitleController();

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              controller: controller,
            ),
          ),
        );

        expect(find.byType(Persona5Title), findsOneWidget);
        controller.dispose();
      });

      testWidgets('controller receives phase updates', (tester) async {
        final controller = Persona5TitleController();
        final phases = <AnimationPhase>[];

        controller.addListener(() {
          phases.add(controller.currentPhase);
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              controller: controller,
            ),
          ),
        );

        // Initial phase should be entering
        expect(controller.currentPhase, equals(AnimationPhase.entering));

        controller.dispose();
      });
    });

    group('controller integration', () {
      testWidgets('pause() sets controller isPaused state', (tester) async {
        final controller = Persona5TitleController();

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              controller: controller,
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));

        controller.pause();
        expect(controller.isPaused, isTrue);

        controller.dispose();
      });

      testWidgets('resume() continues animation after pause', (tester) async {
        final controller = Persona5TitleController();

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              controller: controller,
            ),
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
        final controller = Persona5TitleController();
        var completeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
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
        final controller = Persona5TitleController();
        var startCallCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              controller: controller,
              onAnimationStart: () => startCallCount++,
            ),
          ),
        );

        // First start
        expect(startCallCount, equals(1));

        // Advance to active phase
        await tester.pump(Persona5Timing.textAppearDelay);
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
        final controller = Persona5TitleController();
        expect(controller.dispose, returnsNormally);
      });

      testWidgets('widget handles controller disposal', (tester) async {
        final controller = Persona5TitleController();

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              controller: controller,
            ),
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
            home: Persona5Title(text: 'TEST'),
          ),
        );

        expect(find.byType(Persona5Title), findsOneWidget);

        // Advance animation
        await tester.pump(Persona5Timing.totalDuration);
        await tester.pump(const Duration(milliseconds: 100));

        // Should auto-destruct
        expect(find.byType(SizedBox), findsWidgets);
      });
    });
  });
}
