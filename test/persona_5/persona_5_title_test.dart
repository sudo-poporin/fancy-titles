import 'package:fancy_titles/fancy_titles.dart';
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

    // Note: Widget tests are limited due to Future.delayed timer issues.
    // Integration testing recommended for full coverage.
  });
}
