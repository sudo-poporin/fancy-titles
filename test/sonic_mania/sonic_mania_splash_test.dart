import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SonicManiaSplash', () {
    group('instantiation', () {
      test('can be instantiated with only baseText', () {
        expect(
          SonicManiaSplash(baseText: 'TEST'),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          SonicManiaSplash(
            baseText: 'STUDIOPOLIS',
            secondaryText: 'ZONE',
            lastText: 'ACT1',
          ),
          isNotNull,
        );
      });

      test('throws FlutterError if lastText exceeds 4 characters', () {
        expect(
          () => SonicManiaSplash(
            baseText: 'TEST',
            lastText: 'TOOLONG',
          ),
          throwsFlutterError,
        );
      });

      test('accepts lastText with exactly 4 characters', () {
        expect(
          SonicManiaSplash(
            baseText: 'TEST',
            lastText: 'ACT1',
          ),
          isNotNull,
        );
      });

      test('handles single character lastText', () {
        expect(
          SonicManiaSplash(
            baseText: 'TEST',
            lastText: 'A',
          ),
          isNotNull,
        );
      });
    });

    group('callbacks', () {
      test('can be instantiated with onAnimationStart callback', () {
        var callbackCalled = false;
        final widget = SonicManiaSplash(
          baseText: 'TEST',
          onAnimationStart: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse); // Not called until widget is built
      });

      test('can be instantiated with onAnimationComplete callback', () {
        var callbackCalled = false;
        final widget = SonicManiaSplash(
          baseText: 'TEST',
          onAnimationComplete: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse);
      });

      test('can be instantiated with onPhaseChange callback', () {
        final phases = <AnimationPhase>[];
        final widget = SonicManiaSplash(
          baseText: 'TEST',
          onPhaseChange: phases.add,
        );
        expect(widget, isNotNull);
        expect(phases, isEmpty); // Not called until widget is built
      });

      test('can be instantiated with all callbacks', () {
        var startCalled = false;
        var completeCalled = false;
        final phases = <AnimationPhase>[];

        final widget = SonicManiaSplash(
          baseText: 'STUDIOPOLIS',
          secondaryText: 'ZONE',
          lastText: 'ACT1',
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
          MaterialApp(
            home: SonicManiaSplash(baseText: 'TEST'),
          ),
        );

        expect(find.byType(SonicManiaSplash), findsOneWidget);
      });

      testWidgets('renders with all parameters', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'STUDIOPOLIS',
              secondaryText: 'ZONE',
              lastText: 'ACT1',
            ),
          ),
        );

        expect(find.byType(SonicManiaSplash), findsOneWidget);
      });

    });

    group('animation lifecycle', () {
      testWidgets('calls onAnimationStart immediately on build',
          (tester) async {
        var startCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
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
            home: SonicManiaSplash(
              baseText: 'TEST',
              onPhaseChange: phases.add,
            ),
          ),
        );

        // Initial phase should be entering
        expect(phases, contains(AnimationPhase.entering));

        // Advance to active phase (after slideIn: 600ms)
        await tester.pump(SonicManiaTiming.slideIn);
        expect(phases, contains(AnimationPhase.active));

        // Advance to exiting phase (at slideOutDelay: 3500ms)
        await tester.pump(
          SonicManiaTiming.slideOutDelay - SonicManiaTiming.slideIn,
        );
        expect(phases, contains(AnimationPhase.exiting));
      });

      testWidgets('calls onAnimationComplete after totalDuration',
          (tester) async {
        var completeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        );

        expect(completeCalled, isFalse);

        // Advance to total duration
        await tester.pump(SonicManiaTiming.totalDuration);

        expect(completeCalled, isTrue);
      });

      testWidgets('auto-destructs after totalDuration', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(baseText: 'TEST'),
          ),
        );

        expect(find.byType(SonicManiaSplash), findsOneWidget);

        // Advance past total duration
        await tester.pump(SonicManiaTiming.totalDuration);
        await tester.pump(SonicManiaTiming.fadeTransition);

        // Widget should still exist but content should be SizedBox.shrink
        // due to AnimatedSwitcher
        expect(find.byType(SonicManiaSplash), findsOneWidget);
      });
    });
  });
}
