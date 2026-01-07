import 'package:fancy_titles/fancy_titles.dart';
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

    // Note: Widget tests for SonicManiaSplash are limited because the widget
    // uses staggered Future.delayed timers that cannot be canceled on dispose.
    // This is a known limitation of the widget architecture.
    // Full integration testing is recommended with real devices.
  });
}
