import 'package:fancy_titles/evangelion/evangelion_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EvangelionColors', () {
    test('background color has correct value', () {
      expect(EvangelionColors.background, equals(const Color(0xFF040404)));
    });

    test('text color has correct value', () {
      expect(EvangelionColors.text, equals(const Color(0xFFF1EEFF)));
    });

    test('textShadow color has correct value', () {
      expect(
        EvangelionColors.textShadow,
        equals(const Color.fromARGB(255, 67, 48, 35)),
      );
    });

    test('curtainFirst color is Colors.black', () {
      expect(EvangelionColors.curtainFirst, equals(Colors.black));
    });
  });

  group('EvangelionTheme', () {
    test('default constructor creates theme with null values', () {
      const theme = EvangelionTheme();
      expect(theme.backgroundColor, isNull);
      expect(theme.textColor, isNull);
      expect(theme.textShadowColor, isNull);
      expect(theme.curtainFirstColor, isNull);
    });

    test('constructor accepts custom colors', () {
      const theme = EvangelionTheme(
        backgroundColor: Colors.purple,
        textColor: Colors.amber,
        textShadowColor: Colors.grey,
        curtainFirstColor: Colors.indigo,
      );

      expect(theme.backgroundColor, equals(Colors.purple));
      expect(theme.textColor, equals(Colors.amber));
      expect(theme.textShadowColor, equals(Colors.grey));
      expect(theme.curtainFirstColor, equals(Colors.indigo));
    });

    test('defaults() factory creates theme with default colors', () {
      final theme = EvangelionTheme.defaults();

      expect(theme.backgroundColor, equals(EvangelionColors.background));
      expect(theme.textColor, equals(EvangelionColors.text));
      expect(theme.textShadowColor, equals(EvangelionColors.textShadow));
      expect(theme.curtainFirstColor, equals(EvangelionColors.curtainFirst));
    });

    group('copyWith', () {
      test('copies all values when none provided', () {
        const original = EvangelionTheme(
          backgroundColor: Colors.black,
          textColor: Colors.white,
          textShadowColor: Colors.grey,
          curtainFirstColor: Colors.black54,
        );

        final copied = original.copyWith();

        expect(copied.backgroundColor, equals(original.backgroundColor));
        expect(copied.textColor, equals(original.textColor));
        expect(copied.textShadowColor, equals(original.textShadowColor));
        expect(copied.curtainFirstColor, equals(original.curtainFirstColor));
      });

      test('replaces specified values', () {
        const original = EvangelionTheme(backgroundColor: Colors.black);
        final copied = original.copyWith(textColor: Colors.amber);

        expect(copied.backgroundColor, equals(Colors.black));
        expect(copied.textColor, equals(Colors.amber));
      });
    });

    group('equality', () {
      test('two themes with same values are equal', () {
        const theme1 = EvangelionTheme(
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        const theme2 = EvangelionTheme(
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );

        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
      });

      test('two themes with different values are not equal', () {
        const theme1 = EvangelionTheme(backgroundColor: Colors.black);
        const theme2 = EvangelionTheme(backgroundColor: Colors.white);

        expect(theme1, isNot(equals(theme2)));
      });

      test('identical theme is equal to itself', () {
        const theme = EvangelionTheme(backgroundColor: Colors.black);
        expect(theme, equals(theme));
      });
    });

    test('toString returns descriptive string', () {
      const theme = EvangelionTheme(backgroundColor: Colors.black);
      final str = theme.toString();

      expect(str, contains('EvangelionTheme'));
      expect(str, contains('backgroundColor'));
    });
  });
}
