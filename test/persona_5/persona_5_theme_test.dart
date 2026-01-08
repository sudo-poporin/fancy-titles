import 'package:fancy_titles/persona_5/persona_5_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Persona5Colors', () {
    test('red color has correct value', () {
      expect(Persona5Colors.red, equals(const Color(0xFFFF1518)));
    });

    test('black color is Colors.black', () {
      expect(Persona5Colors.black, equals(Colors.black));
    });

    test('white color is Colors.white', () {
      expect(Persona5Colors.white, equals(Colors.white));
    });

    test('textFill color is Colors.black', () {
      expect(Persona5Colors.textFill, equals(Colors.black));
    });
  });

  group('Persona5Theme', () {
    test('default constructor creates theme with null values', () {
      const theme = Persona5Theme();
      expect(theme.backgroundColor, isNull);
      expect(theme.primaryCircleColor, isNull);
      expect(theme.secondaryCircleColor, isNull);
      expect(theme.textStrokeColor, isNull);
      expect(theme.textFillColor, isNull);
    });

    test('constructor accepts custom colors', () {
      const theme = Persona5Theme(
        backgroundColor: Colors.purple,
        primaryCircleColor: Colors.deepPurple,
        secondaryCircleColor: Colors.black87,
        textStrokeColor: Colors.yellow,
        textFillColor: Colors.orange,
      );

      expect(theme.backgroundColor, equals(Colors.purple));
      expect(theme.primaryCircleColor, equals(Colors.deepPurple));
      expect(theme.secondaryCircleColor, equals(Colors.black87));
      expect(theme.textStrokeColor, equals(Colors.yellow));
      expect(theme.textFillColor, equals(Colors.orange));
    });

    test('defaults() factory creates theme with default colors', () {
      final theme = Persona5Theme.defaults();

      expect(theme.backgroundColor, equals(Persona5Colors.red));
      expect(theme.primaryCircleColor, equals(Persona5Colors.red));
      expect(theme.secondaryCircleColor, equals(Persona5Colors.black));
      expect(theme.textStrokeColor, equals(Persona5Colors.white));
      expect(theme.textFillColor, equals(Persona5Colors.textFill));
    });

    group('copyWith', () {
      test('copies all values when none provided', () {
        const original = Persona5Theme(
          backgroundColor: Colors.red,
          primaryCircleColor: Colors.blue,
          secondaryCircleColor: Colors.green,
          textStrokeColor: Colors.yellow,
          textFillColor: Colors.orange,
        );

        final copied = original.copyWith();

        expect(copied.backgroundColor, equals(original.backgroundColor));
        expect(copied.primaryCircleColor, equals(original.primaryCircleColor));
        expect(
          copied.secondaryCircleColor,
          equals(original.secondaryCircleColor),
        );
        expect(copied.textStrokeColor, equals(original.textStrokeColor));
        expect(copied.textFillColor, equals(original.textFillColor));
      });

      test('replaces specified values', () {
        const original = Persona5Theme(backgroundColor: Colors.red);
        final copied = original.copyWith(primaryCircleColor: Colors.blue);

        expect(copied.backgroundColor, equals(Colors.red));
        expect(copied.primaryCircleColor, equals(Colors.blue));
      });
    });

    group('equality', () {
      test('two themes with same values are equal', () {
        const theme1 = Persona5Theme(
          backgroundColor: Colors.red,
          primaryCircleColor: Colors.blue,
        );
        const theme2 = Persona5Theme(
          backgroundColor: Colors.red,
          primaryCircleColor: Colors.blue,
        );

        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
      });

      test('two themes with different values are not equal', () {
        const theme1 = Persona5Theme(backgroundColor: Colors.red);
        const theme2 = Persona5Theme(backgroundColor: Colors.blue);

        expect(theme1, isNot(equals(theme2)));
      });

      test('identical theme is equal to itself', () {
        const theme = Persona5Theme(backgroundColor: Colors.red);
        expect(theme, equals(theme));
      });
    });

    test('toString returns descriptive string', () {
      const theme = Persona5Theme(backgroundColor: Colors.red);
      final str = theme.toString();

      expect(str, contains('Persona5Theme'));
      expect(str, contains('backgroundColor'));
    });
  });
}
