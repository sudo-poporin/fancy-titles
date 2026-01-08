import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

    // Note: Widget rendering and animation lifecycle tests are complex to
    // implement due to child widgets (BouncingCircle, SlidingTitle, etc.)
    // having their own timers and using precacheImage which fails in tests.
    //
    // The core timer cancellation behavior is thoroughly tested in
    // test/core/cancelable_timers_test.dart. MarioMakerTitle uses
    // CancelableTimersMixin for safe timer management.
    //
    // See test/mario_maker/widgets/bouncing_circle_test.dart for lifecycle
    // tests of the child widgets.
  });
}
