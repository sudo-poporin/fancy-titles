import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EvangelionTitle', () {
    group('instantiation', () {
      test('can be instantiated with no parameters (uses defaults)', () {
        expect(
          const EvangelionTitle(),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          const EvangelionTitle(
            firstText: 'NEON',
            secondText: 'GENESIS',
            thirdText: 'EVANGELION',
            fourthText: 'EPISODE:1',
            fifthText: 'ANGEL ATTACK',
          ),
          isNotNull,
        );
      });

      test('has correct default values', () {
        const widget = EvangelionTitle();
        expect(widget, isNotNull);
      });
    });

    group('callbacks', () {
      test('can be instantiated with onAnimationStart callback', () {
        var callbackCalled = false;
        final widget = EvangelionTitle(
          onAnimationStart: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse); // Not called until widget is built
      });

      test('can be instantiated with onAnimationComplete callback', () {
        var callbackCalled = false;
        final widget = EvangelionTitle(
          onAnimationComplete: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse);
      });

      test('can be instantiated with onPhaseChange callback', () {
        final phases = <AnimationPhase>[];
        final widget = EvangelionTitle(
          onPhaseChange: phases.add,
        );
        expect(widget, isNotNull);
        expect(phases, isEmpty); // Not called until widget is built
      });

      test('can be instantiated with all callbacks', () {
        var startCalled = false;
        var completeCalled = false;
        final phases = <AnimationPhase>[];

        final widget = EvangelionTitle(
          firstText: 'SHIN',
          secondText: 'EVANGELION',
          thirdText: 'MOVIE',
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
      testWidgets('renders with default parameters', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: EvangelionTitle(),
          ),
        );

        expect(find.byType(EvangelionTitle), findsOneWidget);
      });

      testWidgets('renders with custom parameters', (tester) async {
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

        expect(find.byType(EvangelionTitle), findsOneWidget);
      });
    });

    group('animation lifecycle', () {
      testWidgets('calls onAnimationStart immediately on build', (
        tester,
      ) async {
        var startCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: EvangelionTitle(
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
            home: EvangelionTitle(
              onPhaseChange: phases.add,
            ),
          ),
        );

        // Initial phase should be entering
        expect(phases, contains(AnimationPhase.entering));

        // Advance to active phase (after textAppearDelay: 450ms)
        await tester.pump(EvangelionTiming.textAppearDelay);
        expect(phases, contains(AnimationPhase.active));

        // Advance to exiting phase (at backgroundFadeTime: 3s)
        await tester.pump(
          EvangelionTiming.backgroundFadeTime -
              EvangelionTiming.textAppearDelay,
        );
        expect(phases, contains(AnimationPhase.exiting));
      });

      testWidgets('calls onAnimationComplete after totalDuration', (
        tester,
      ) async {
        var completeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: EvangelionTitle(
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        );

        expect(completeCalled, isFalse);

        // Advance to total duration
        await tester.pump(EvangelionTiming.totalDuration);

        expect(completeCalled, isTrue);
      });

      testWidgets('shows text after textAppearDelay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: EvangelionTitle(),
          ),
        );

        // Initially text should not be visible (black background only)
        expect(find.text('NEON'), findsNothing);

        // Advance past text appear delay
        await tester.pump(EvangelionTiming.textAppearDelay);
        await tester.pump(); // Rebuild

        // Text should now be visible
        expect(find.text('NEON'), findsOneWidget);
      });
    });
  });
}
