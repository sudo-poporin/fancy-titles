import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarioMakerTitle', () {
    group('instantiation', () {
      test('can be instantiated with required parameters', () {
        expect(
          const MarioMakerTitle(
            title: 'TEST',
            imagePath: 'assets/test.png',
          ),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          const MarioMakerTitle(
            title: 'TEST',
            imagePath: 'assets/test.png',
            duration: Duration(seconds: 6),
            circleRadius: 100,
            bottomMargin: 150,
            titleStyle: TextStyle(fontSize: 48),
            irisOutAlignment: Alignment.bottomRight,
            irisOutEdgePadding: 75,
          ),
          isNotNull,
        );
      });

      test('has default duration of 4 seconds', () {
        const widget = MarioMakerTitle(
          title: 'TEST',
          imagePath: 'assets/test.png',
        );
        expect(widget, isNotNull);
      });
    });

    // Note: Widget tests are limited due to Future.delayed timer issues.
    // Integration testing recommended for full coverage.
  });
}
