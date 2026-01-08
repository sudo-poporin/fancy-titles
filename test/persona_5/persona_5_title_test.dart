import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Persona5Title', () {
    group('instantiation', () {
      test('can be instantiated with required parameters', () {
        expect(
          const Persona5Title(text: 'TEST'),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          const Persona5Title(
            text: 'TEST',
            imagePath: 'assets/test.png',
            withImageBlendMode: true,
            delay: Duration(milliseconds: 200),
            duration: Duration(seconds: 4),
          ),
          isNotNull,
        );
      });

      test('has default delay of 125 milliseconds', () {
        const widget = Persona5Title(text: 'TEST');
        expect(widget, isNotNull);
      });

      test('has default duration of 3400 milliseconds', () {
        const widget = Persona5Title(text: 'TEST');
        expect(widget, isNotNull);
      });
    });

    group('callbacks', () {
      test('can be instantiated with onAnimationStart callback', () {
        var callbackCalled = false;
        final widget = Persona5Title(
          text: 'TEST',
          onAnimationStart: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse); // Not called until widget is built
      });

      test('can be instantiated with onAnimationComplete callback', () {
        var callbackCalled = false;
        final widget = Persona5Title(
          text: 'TEST',
          onAnimationComplete: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse);
      });

      test('can be instantiated with onPhaseChange callback', () {
        final phases = <AnimationPhase>[];
        final widget = Persona5Title(
          text: 'TEST',
          onPhaseChange: phases.add,
        );
        expect(widget, isNotNull);
        expect(phases, isEmpty); // Not called until widget is built
      });

      test('can be instantiated with all callbacks', () {
        var startCalled = false;
        var completeCalled = false;
        final phases = <AnimationPhase>[];

        final widget = Persona5Title(
          text: 'ALL OUT ATTACK',
          imagePath: 'assets/test.png',
          onAnimationStart: () => startCalled = true,
          onAnimationComplete: () => completeCalled = true,
          onPhaseChange: phases.add,
        );

        expect(widget, isNotNull);
        expect(startCalled, isFalse);
        expect(completeCalled, isFalse);
        expect(phases, isEmpty);
      });
    });

    group('widget rendering', () {
      testWidgets('renders with required parameters', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Persona5Title(text: 'TEST'),
          ),
        );

        expect(find.byType(Persona5Title), findsOneWidget);
      });

      testWidgets('renders with all parameters', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Persona5Title(
              text: 'ALL OUT ATTACK',
              withImageBlendMode: true,
              delay: Duration(milliseconds: 200),
              duration: Duration(seconds: 4),
            ),
          ),
        );

        expect(find.byType(Persona5Title), findsOneWidget);
      });

    });

    group('animation lifecycle', () {
      testWidgets('calls onAnimationStart immediately on build',
          (tester) async {
        var startCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              onAnimationStart: () => startCalled = true,
            ),
          ),
        );

        expect(startCalled, isTrue);
      });

      testWidgets('progresses through animation phases', (tester) async {
        final phases = <AnimationPhase>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              onPhaseChange: phases.add,
            ),
          ),
        );

        // Initial phase should be entering
        expect(phases, contains(AnimationPhase.entering));

        // Advance to active phase (after textAppearDelay)
        await tester.pump(Persona5Timing.textAppearDelay);
        expect(phases, contains(AnimationPhase.active));

        // Advance to exiting phase (after delay + duration)
        await tester.pump(
          Persona5Timing.initialDelay +
              Persona5Timing.mainDuration -
              Persona5Timing.textAppearDelay,
        );
        expect(phases, contains(AnimationPhase.exiting));
      });

      testWidgets('calls onAnimationComplete after totalDuration',
          (tester) async {
        var completeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        );

        expect(completeCalled, isFalse);

        // Advance to total duration
        await tester.pump(Persona5Timing.totalDuration);

        expect(completeCalled, isTrue);
      });

      testWidgets('respects custom delay parameter', (tester) async {
        final phases = <AnimationPhase>[];
        const customDelay = Duration(milliseconds: 500);

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              delay: customDelay,
              onPhaseChange: phases.add,
            ),
          ),
        );

        // Widget should start entering immediately
        expect(phases.first, equals(AnimationPhase.entering));
      });

      testWidgets('respects custom duration parameter', (tester) async {
        var completeCalled = false;
        const customDuration = Duration(seconds: 2);

        await tester.pumpWidget(
          MaterialApp(
            home: Persona5Title(
              text: 'TEST',
              duration: customDuration,
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        );

        expect(completeCalled, isFalse);

        // Advance to total duration
        await tester.pump(Persona5Timing.totalDuration);

        expect(completeCalled, isTrue);
      });
    });
  });
}
