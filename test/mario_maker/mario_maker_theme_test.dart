import 'package:fancy_titles/mario_maker/mario_maker_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarioMakerColors', () {
    test('yellow color has correct value', () {
      expect(MarioMakerColors.yellow, equals(const Color(0xFFFFC800)));
    });

    test('black color has correct value', () {
      expect(MarioMakerColors.black, equals(const Color(0xFF000000)));
    });

    test('titleText color is Colors.black', () {
      expect(MarioMakerColors.titleText, equals(Colors.black));
    });

    test('circleBackground color is Colors.transparent', () {
      expect(MarioMakerColors.circleBackground, equals(Colors.transparent));
    });
  });

  group('MarioMakerTheme', () {
    test('default constructor creates theme with null values', () {
      const theme = MarioMakerTheme();
      expect(theme.backgroundColor, isNull);
      expect(theme.expandedBackgroundColor, isNull);
      expect(theme.circleColor, isNull);
      expect(theme.titleColor, isNull);
    });

    test('constructor accepts custom colors', () {
      const theme = MarioMakerTheme(
        backgroundColor: Colors.purple,
        expandedBackgroundColor: Colors.orange,
        circleColor: Colors.blue,
        titleColor: Colors.white,
      );

      expect(theme.backgroundColor, equals(Colors.purple));
      expect(theme.expandedBackgroundColor, equals(Colors.orange));
      expect(theme.circleColor, equals(Colors.blue));
      expect(theme.titleColor, equals(Colors.white));
    });

    test('defaults() factory creates theme with default colors', () {
      final theme = MarioMakerTheme.defaults();

      expect(theme.backgroundColor, equals(MarioMakerColors.black));
      expect(theme.expandedBackgroundColor, equals(MarioMakerColors.yellow));
      expect(theme.circleColor, equals(MarioMakerColors.circleBackground));
      expect(theme.titleColor, equals(MarioMakerColors.titleText));
    });

    group('copyWith', () {
      test('copies all values when none provided', () {
        const original = MarioMakerTheme(
          backgroundColor: Colors.black,
          expandedBackgroundColor: Colors.yellow,
          circleColor: Colors.transparent,
          titleColor: Colors.black,
        );

        final copied = original.copyWith();

        expect(copied.backgroundColor, equals(original.backgroundColor));
        expect(
          copied.expandedBackgroundColor,
          equals(original.expandedBackgroundColor),
        );
        expect(copied.circleColor, equals(original.circleColor));
        expect(copied.titleColor, equals(original.titleColor));
      });

      test('replaces specified values', () {
        const original = MarioMakerTheme(backgroundColor: Colors.black);
        final copied = original.copyWith(
          expandedBackgroundColor: Colors.orange,
        );

        expect(copied.backgroundColor, equals(Colors.black));
        expect(copied.expandedBackgroundColor, equals(Colors.orange));
      });
    });

    group('equality', () {
      test('two themes with same values are equal', () {
        const theme1 = MarioMakerTheme(
          backgroundColor: Colors.black,
          expandedBackgroundColor: Colors.yellow,
        );
        const theme2 = MarioMakerTheme(
          backgroundColor: Colors.black,
          expandedBackgroundColor: Colors.yellow,
        );

        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
      });

      test('two themes with different values are not equal', () {
        const theme1 = MarioMakerTheme(backgroundColor: Colors.black);
        const theme2 = MarioMakerTheme(backgroundColor: Colors.white);

        expect(theme1, isNot(equals(theme2)));
      });

      test('identical theme is equal to itself', () {
        const theme = MarioMakerTheme(backgroundColor: Colors.black);
        expect(theme, equals(theme));
      });
    });

    test('toString returns descriptive string', () {
      const theme = MarioMakerTheme(backgroundColor: Colors.black);
      final str = theme.toString();

      expect(str, contains('MarioMakerTheme'));
      expect(str, contains('backgroundColor'));
    });
  });
}
