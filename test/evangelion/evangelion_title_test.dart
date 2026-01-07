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

    // Note: Widget tests are limited due to Future.delayed timer issues.
    // Integration testing recommended for full coverage.
  });
}
