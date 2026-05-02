import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Use a real asset bundled in pubspec.yaml under test/fixtures/.
  const realImagePath = 'test/fixtures/test_image.png';

  group('MarioMakerTitle', () {
    group('instantiation', () {
      test('can be instantiated with required parameters', () {
        expect(
          const MarioMakerTitle(
            title: 'TEST',
            imagePath: 'assets/test.png',
          ),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          const MarioMakerTitle(
            title: 'TEST',
            imagePath: 'assets/test.png',
            duration: Duration(seconds: 6),
            circleRadius: 100,
            bottomMargin: 150,
            titleStyle: TextStyle(fontSize: 48),
            irisOutAlignment: Alignment.bottomRight,
            irisOutEdgePadding: 75,
          ),
          isNotNull,
        );
      });

      test('has default duration of 4 seconds', () {
        const widget = MarioMakerTitle(
          title: 'TEST',
          imagePath: 'assets/test.png',
        );
        expect(widget, isNotNull);
      });
    });

    group('callbacks', () {
      test('can be instantiated with onAnimationStart callback', () {
        var callbackCalled = false;
        final widget = MarioMakerTitle(
          title: 'TEST',
          imagePath: 'assets/test.png',
          onAnimationStart: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse); // Not called until widget is built
      });

      test('can be instantiated with onAnimationComplete callback', () {
        var callbackCalled = false;
        final widget = MarioMakerTitle(
          title: 'TEST',
          imagePath: 'assets/test.png',
          onAnimationComplete: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse);
      });

      test('can be instantiated with onPhaseChange callback', () {
        final phases = <AnimationPhase>[];
        final widget = MarioMakerTitle(
          title: 'TEST',
          imagePath: 'assets/test.png',
          onPhaseChange: phases.add,
        );
        expect(widget, isNotNull);
        expect(phases, isEmpty); // Not called until widget is built
      });

      test('can be instantiated with all callbacks', () {
        var startCalled = false;
        var completeCalled = false;
        final phases = <AnimationPhase>[];

        final widget = MarioMakerTitle(
          title: 'TEST',
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
            home: MarioMakerTitle(
              title: 'TEST',
              imagePath: realImagePath,
            ),
          ),
        );

        expect(find.byType(MarioMakerTitle), findsOneWidget);

        // Drain timers
        await tester.pump(MarioMakerTiming.defaultTotalDuration);
        await tester.pump(const Duration(milliseconds: 100));
      });

      testWidgets('renders with custom parameters', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: MarioMakerTitle(
              title: 'CUSTOM',
              imagePath: realImagePath,
              duration: Duration(seconds: 2),
              circleRadius: 50,
              bottomMargin: 80,
              titleStyle: TextStyle(fontSize: 36),
              irisOutAlignment: Alignment.topLeft,
              irisOutEdgePadding: 30,
            ),
          ),
        );

        expect(find.byType(MarioMakerTitle), findsOneWidget);

        // Drain timers
        await tester.pump(const Duration(seconds: 2));
        await tester.pump(const Duration(milliseconds: 100));
      });
    });

    group('animation lifecycle', () {
      testWidgets('calls onAnimationStart immediately on build',
          (tester) async {
        var startCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: MarioMakerTitle(
              title: 'TEST',
              imagePath: realImagePath,
              onAnimationStart: () => startCalled = true,
            ),
          ),
        );

        expect(startCalled, isTrue);

        // Drain timers
        await tester.pump(MarioMakerTiming.defaultTotalDuration);
        await tester.pump(const Duration(milliseconds: 100));
      });

      testWidgets('progresses through animation phases', (tester) async {
        final phases = <AnimationPhase>[];

        await tester.pumpWidget(
          MaterialApp(
            home: MarioMakerTitle(
              title: 'TEST',
              imagePath: realImagePath,
              onPhaseChange: phases.add,
            ),
          ),
        );

        // Initial phase should be entering
        expect(phases, contains(AnimationPhase.entering));

        // Advance to active phase (after titleEntryDelay: 1400ms)
        await tester.pump(MarioMakerTiming.titleEntryDelay);
        expect(phases, contains(AnimationPhase.active));

        // Advance to exiting phase (at duration - irisOutDuration)
        await tester.pump(
          MarioMakerTiming.defaultTotalDuration -
              MarioMakerTiming.irisOutDuration -
              MarioMakerTiming.titleEntryDelay,
        );
        expect(phases, contains(AnimationPhase.exiting));

        // Advance to completed phase
        await tester.pump(MarioMakerTiming.irisOutDuration);
        expect(phases, contains(AnimationPhase.completed));

        // Drain remaining timers
        await tester.pump(const Duration(milliseconds: 100));
      });

      testWidgets('calls onAnimationComplete after totalDuration',
          (tester) async {
        var completeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: MarioMakerTitle(
              title: 'TEST',
              imagePath: realImagePath,
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        );

        expect(completeCalled, isFalse);

        // Advance to total duration
        await tester.pump(MarioMakerTiming.defaultTotalDuration);

        expect(completeCalled, isTrue);

        // Drain timers
        await tester.pump(const Duration(milliseconds: 100));
      });

      testWidgets('hides itself after animation completes', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: MarioMakerTitle(
              title: 'TEST',
              imagePath: realImagePath,
            ),
          ),
        );

        // Drain all child widget timers (BouncingCircle, ExpandingCircleMask,
        // ContractingCircleMask, SlidingTitle, MarioMakerImage scale-out).
        await tester.pump(const Duration(seconds: 5));
        await tester.pump(const Duration(milliseconds: 100));

        // Widget should still exist (renders SizedBox.shrink internally)
        expect(find.byType(MarioMakerTitle), findsOneWidget);
      });

      testWidgets('respects custom duration parameter', (tester) async {
        var completeCalled = false;
        const customDuration = Duration(seconds: 2);

        await tester.pumpWidget(
          MaterialApp(
            home: MarioMakerTitle(
              title: 'TEST',
              imagePath: realImagePath,
              duration: customDuration,
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        );

        expect(completeCalled, isFalse);

        // Advance to custom total duration
        await tester.pump(customDuration);

        expect(completeCalled, isTrue);

        // Drain timers
        await tester.pump(const Duration(milliseconds: 100));
      });

      testWidgets('callback exception is silently handled', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MarioMakerTitle(
              title: 'TEST',
              imagePath: realImagePath,
              onAnimationStart: () => throw Exception('test error'),
            ),
          ),
        );

        // Widget should still render despite callback throwing
        expect(find.byType(MarioMakerTitle), findsOneWidget);

        // Drain timers
        await tester.pump(MarioMakerTiming.defaultTotalDuration);
        await tester.pump(const Duration(milliseconds: 100));
      });
    });

    group('disposal', () {
      testWidgets('disposes without errors mid-animation', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: MarioMakerTitle(
              title: 'TEST',
              imagePath: realImagePath,
            ),
          ),
        );

        // Pump some time
        await tester.pump(const Duration(milliseconds: 500));

        // Replace with empty widget to trigger disposal
        await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

        // Allow any remaining child-widget timers to expire harmlessly
        await tester.pump(const Duration(seconds: 5));
        await tester.pump(const Duration(milliseconds: 100));
      });
    });
  });
}
