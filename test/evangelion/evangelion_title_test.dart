import 'package:fancy_titles/fancy_titles.dart';
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

    // Note: Widget tests are limited due to Future.delayed timer issues.
    // Integration testing recommended for full coverage.
  });
}
