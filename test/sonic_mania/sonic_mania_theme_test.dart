import 'package:fancy_titles/sonic_mania/sonic_mania_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SonicManiaBarColors', () {
    test('has correct default red color', () {
      expect(SonicManiaBarColors.red, equals(const Color(0xFFD15529)));
    });

    test('has correct default orange color', () {
      expect(SonicManiaBarColors.orange, equals(const Color(0xFFFB9B0F)));
    });

    test('has correct default blue color', () {
      expect(SonicManiaBarColors.blue, equals(const Color(0xFF456EBD)));
    });

    test('has correct default green color', () {
      expect(SonicManiaBarColors.green, equals(const Color(0xFF4E9B89)));
    });
  });

  group('SonicManiaCurtainColors', () {
    test('has correct default blue color', () {
      expect(SonicManiaCurtainColors.blue, equals(const Color(0xFF3D62AA)));
    });

    test('has correct default orange color', () {
      expect(SonicManiaCurtainColors.orange, equals(const Color(0xFFFE6933)));
    });

    test('has correct default amber color', () {
      expect(SonicManiaCurtainColors.amber, equals(const Color(0xFFCA7C0B)));
    });

    test('has correct default green color', () {
      expect(SonicManiaCurtainColors.green, equals(const Color(0xFF5DB4A1)));
    });

    test('has correct default yellow color', () {
      expect(SonicManiaCurtainColors.yellow, equals(const Color(0xFFF7C700)));
    });

    test('has correct default black color', () {
      expect(SonicManiaCurtainColors.black, equals(const Color(0xFF040404)));
    });
  });

  group('SonicManiaTextBarColors', () {
    test('has correct default blackBackground color', () {
      expect(
        SonicManiaTextBarColors.blackBackground,
        equals(const Color(0xFF212121)),
      );
    });

    test('has correct default whiteText color', () {
      expect(
        SonicManiaTextBarColors.whiteText,
        equals(const Color(0xFFF3F3F3)),
      );
    });

    test('has correct default whiteBackground color', () {
      expect(
        SonicManiaTextBarColors.whiteBackground,
        equals(const Color(0xFFF3F3F3)),
      );
    });

    test('has correct default blackText color', () {
      expect(
        SonicManiaTextBarColors.blackText,
        equals(const Color(0xFF212121)),
      );
    });
  });

  group('SonicManiaTheme', () {
    test('constructor creates theme with null values', () {
      const theme = SonicManiaTheme();

      expect(theme.redBarColor, isNull);
      expect(theme.orangeBarColor, isNull);
      expect(theme.blueBarColor, isNull);
      expect(theme.greenBarColor, isNull);
      expect(theme.blueCurtainColor, isNull);
      expect(theme.orangeCurtainColor, isNull);
      expect(theme.amberCurtainColor, isNull);
      expect(theme.greenCurtainColor, isNull);
      expect(theme.yellowCurtainColor, isNull);
      expect(theme.clippedCurtainColor, isNull);
      expect(theme.textBarBlackColor, isNull);
      expect(theme.textBarWhiteColor, isNull);
      expect(theme.textOnBlackColor, isNull);
      expect(theme.textOnWhiteColor, isNull);
    });

    test('constructor accepts custom colors', () {
      const theme = SonicManiaTheme(
        redBarColor: Colors.red,
        orangeBarColor: Colors.orange,
        blueBarColor: Colors.blue,
        greenBarColor: Colors.green,
      );

      expect(theme.redBarColor, equals(Colors.red));
      expect(theme.orangeBarColor, equals(Colors.orange));
      expect(theme.blueBarColor, equals(Colors.blue));
      expect(theme.greenBarColor, equals(Colors.green));
    });

    test('defaults() creates theme with all default values', () {
      final theme = SonicManiaTheme.defaults();

      expect(theme.redBarColor, equals(SonicManiaBarColors.red));
      expect(theme.orangeBarColor, equals(SonicManiaBarColors.orange));
      expect(theme.blueBarColor, equals(SonicManiaBarColors.blue));
      expect(theme.greenBarColor, equals(SonicManiaBarColors.green));
      expect(theme.blueCurtainColor, equals(SonicManiaCurtainColors.blue));
      expect(theme.orangeCurtainColor, equals(SonicManiaCurtainColors.orange));
      expect(theme.amberCurtainColor, equals(SonicManiaCurtainColors.amber));
      expect(theme.greenCurtainColor, equals(SonicManiaCurtainColors.green));
      expect(theme.yellowCurtainColor, equals(SonicManiaCurtainColors.yellow));
      expect(theme.clippedCurtainColor, equals(SonicManiaCurtainColors.yellow));
      expect(
        theme.textBarBlackColor,
        equals(SonicManiaTextBarColors.blackBackground),
      );
      expect(
        theme.textBarWhiteColor,
        equals(SonicManiaTextBarColors.whiteBackground),
      );
      expect(theme.textOnBlackColor, equals(SonicManiaTextBarColors.whiteText));
      expect(theme.textOnWhiteColor, equals(SonicManiaTextBarColors.blackText));
    });

    group('copyWith', () {
      test('returns new theme with modified bar colors', () {
        const original = SonicManiaTheme(redBarColor: Colors.red);
        final copied = original.copyWith(orangeBarColor: Colors.orange);

        expect(copied.redBarColor, equals(Colors.red));
        expect(copied.orangeBarColor, equals(Colors.orange));
        expect(copied.blueBarColor, isNull);
      });

      test('returns new theme with modified curtain colors', () {
        const original = SonicManiaTheme(blueCurtainColor: Colors.blue);
        final copied = original.copyWith(orangeCurtainColor: Colors.orange);

        expect(copied.blueCurtainColor, equals(Colors.blue));
        expect(copied.orangeCurtainColor, equals(Colors.orange));
        expect(copied.amberCurtainColor, isNull);
      });

      test('returns new theme with modified text bar colors', () {
        const original = SonicManiaTheme(textBarBlackColor: Colors.black);
        final copied = original.copyWith(textOnBlackColor: Colors.white);

        expect(copied.textBarBlackColor, equals(Colors.black));
        expect(copied.textOnBlackColor, equals(Colors.white));
        expect(copied.textBarWhiteColor, isNull);
      });

      test('preserves all values when called without arguments', () {
        final original = SonicManiaTheme.defaults();
        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('equality', () {
      test('two themes with same values are equal', () {
        const theme1 = SonicManiaTheme(redBarColor: Colors.red);
        const theme2 = SonicManiaTheme(redBarColor: Colors.red);

        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
      });

      test('two themes with different values are not equal', () {
        const theme1 = SonicManiaTheme(redBarColor: Colors.red);
        const theme2 = SonicManiaTheme(redBarColor: Colors.blue);

        expect(theme1, isNot(equals(theme2)));
      });

      test('empty themes are equal', () {
        const theme1 = SonicManiaTheme();
        const theme2 = SonicManiaTheme();

        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
      });

      test('default themes are equal', () {
        final theme1 = SonicManiaTheme.defaults();
        final theme2 = SonicManiaTheme.defaults();

        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
      });
    });

    group('toString', () {
      test('returns readable string representation', () {
        const theme = SonicManiaTheme(redBarColor: Colors.red);
        final str = theme.toString();

        expect(str, contains('SonicManiaTheme'));
        expect(str, contains('redBarColor'));
      });
    });
  });
}
