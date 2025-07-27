// ignore_for_file: prefer_const_constructors

import 'package:fancy_titles/sonic_mania/sonic_mania_splash.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SonicManiaSplash', () {
    test('can be instantiated', () {
      expect(
        SonicManiaSplash(
          baseText: 'firstText',
          secondaryText: 'secondText',
          lastText: 'app',
        ),
        isNotNull,
      );
    });

    test('throws error if thirdText has more than 4 characters', () {
      expect(
        () => SonicManiaSplash(
          baseText: 'firstText',
          secondaryText: 'secondText',
          lastText: 'apples',
        ),
        throwsAssertionError,
      );
    });
  });
}
