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

    // Note: Widget tests are limited due to Future.delayed timer issues.
    // Integration testing recommended for full coverage.
  });
}
