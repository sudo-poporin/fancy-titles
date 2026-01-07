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

    // Note: Widget tests for SonicManiaSplash are limited because the widget
    // uses staggered Future.delayed timers that cannot be canceled on dispose.
    // This is a known limitation of the widget architecture.
    // Full integration testing is recommended with real devices.
  });
}
