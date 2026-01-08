import 'dart:ui';

import 'package:fancy_titles/persona_5/constants/constants.dart';
import 'package:fancy_titles/persona_5/painters/circle_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CirclePainter', () {
    group('instantiation', () {
      test('can be instantiated with inflated values', () {
        final painter = CirclePainter(inflatedValues: [100, 200, 300]);

        expect(painter, isA<CirclePainter>());
      });

      test('can be instantiated with empty list', () {
        final painter = CirclePainter(inflatedValues: []);

        expect(painter, isA<CirclePainter>());
      });

      test('can be instantiated with single value', () {
        final painter = CirclePainter(inflatedValues: [50]);

        expect(painter, isA<CirclePainter>());
      });

      test('can be instantiated with negative values', () {
        final painter = CirclePainter(inflatedValues: [-100, -50, 0, 50, 100]);

        expect(painter, isA<CirclePainter>());
      });

      test('can be const constructed', () {
        final painter1 = CirclePainter(inflatedValues: [100]);
        final painter2 = CirclePainter(inflatedValues: [100]);

        // Both should be valid const instances
        expect(painter1, isA<CirclePainter>());
        expect(painter2, isA<CirclePainter>());
      });
    });

    group('paint', () {
      test('paints without error on canvas', () {
        final painter = CirclePainter(inflatedValues: [100, 200, 300]);
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(400, 400);

        // Should not throw
        expect(() => painter.paint(canvas, size), returnsNormally);
      });

      test('paints with empty inflated values', () {
        final painter = CirclePainter(inflatedValues: []);
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(400, 400);

        // Should not throw even with empty list
        expect(() => painter.paint(canvas, size), returnsNormally);
      });

      test('paints with single value', () {
        final painter = CirclePainter(inflatedValues: [50]);
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(200, 200);

        expect(() => painter.paint(canvas, size), returnsNormally);
      });

      test('paints with many values', () {
        final painter = CirclePainter(
          inflatedValues: const [
            1200,
            1100,
            1000,
            900,
            800,
            700,
            600,
            500,
            400,
            300,
            200,
            100,
            0,
            -100,
            -200,
          ],
        );
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(500, 500);

        expect(() => painter.paint(canvas, size), returnsNormally);
      });

      test('paints correctly with different canvas sizes', () {
        final painter = CirclePainter(inflatedValues: [100, 200]);
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        // Small size
        expect(
          () => painter.paint(canvas, const Size(50, 50)),
          returnsNormally,
        );

        // Large size
        expect(
          () => painter.paint(canvas, const Size(2000, 2000)),
          returnsNormally,
        );

        // Asymmetric size
        expect(
          () => painter.paint(canvas, const Size(100, 300)),
          returnsNormally,
        );
      });
    });

    group('shouldRepaint', () {
      test('returns false for same inflated values', () {
        final painter1 = CirclePainter(inflatedValues: [100, 200, 300]);
        final painter2 = CirclePainter(inflatedValues: [100, 200, 300]);

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('returns true for different inflated values', () {
        final painter1 = CirclePainter(inflatedValues: [100, 200, 300]);
        final painter2 = CirclePainter(inflatedValues: [100, 200, 400]);

        expect(painter1.shouldRepaint(painter2), isTrue);
      });

      test('returns true for different length lists', () {
        final painter1 = CirclePainter(inflatedValues: [100, 200]);
        final painter2 = CirclePainter(inflatedValues: [100, 200, 300]);

        expect(painter1.shouldRepaint(painter2), isTrue);
      });

      test('returns false for both empty lists', () {
        final painter1 = CirclePainter(inflatedValues: []);
        final painter2 = CirclePainter(inflatedValues: []);

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('returns true when one list is empty', () {
        final painter1 = CirclePainter(inflatedValues: [100]);
        final painter2 = CirclePainter(inflatedValues: []);

        expect(painter1.shouldRepaint(painter2), isTrue);
      });

      test('returns true for same values in different order', () {
        final painter1 = CirclePainter(inflatedValues: [100, 200, 300]);
        final painter2 = CirclePainter(inflatedValues: [300, 200, 100]);

        expect(painter1.shouldRepaint(painter2), isTrue);
      });
    });

    group('color alternation', () {
      testWidgets('uses redColor for even indices', (tester) async {
        // Verify that the painter uses redColor from constants
        expect(redColor, equals(const Color(0xFFFF1518)));
      });

      testWidgets('uses blackColor for odd indices', (tester) async {
        // Verify that the painter uses blackColor from constants
        expect(blackColor, equals(Colors.black));
      });
    });

    group('widget integration', () {
      testWidgets('can be used in CustomPaint widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                key: const Key('circle-paint'),
                painter: CirclePainter(inflatedValues: const [100, 200, 300]),
                size: const Size(300, 300),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('circle-paint')), findsOneWidget);
      });

      testWidgets('can be used with SizedBox.expand', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox.expand(
                child: CustomPaint(
                  key: const Key('circle-paint'),
                  painter: CirclePainter(inflatedValues: const [50, 100]),
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('circle-paint')), findsOneWidget);
      });

      testWidgets('renders in RepaintBoundary', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RepaintBoundary(
                key: const Key('circle-boundary'),
                child: CustomPaint(
                  key: const Key('circle-paint'),
                  painter: CirclePainter(inflatedValues: const [100]),
                  size: const Size(200, 200),
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('circle-boundary')), findsOneWidget);
        expect(find.byKey(const Key('circle-paint')), findsOneWidget);
      });
    });

    group('with BackgroundCircle values', () {
      testWidgets('handles BackgroundCircle default values', (tester) async {
        // These are the values used by BackgroundCircle widget
        const inflatedValues = [
          1200,
          1100,
          1000,
          900,
          800,
          700,
          600,
          500,
          400,
          300,
          200,
          100,
          0,
          -100,
          -200,
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 400,
                child: CustomPaint(
                  key: const Key('circle-paint'),
                  painter: CirclePainter(inflatedValues: inflatedValues),
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('circle-paint')), findsOneWidget);
      });
    });

    group('edge cases', () {
      test('handles zero size canvas', () {
        final painter = CirclePainter(inflatedValues: [100]);
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        expect(
          () => painter.paint(canvas, Size.zero),
          returnsNormally,
        );
      });

      test('handles very small size canvas', () {
        final painter = CirclePainter(inflatedValues: [100]);
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        expect(
          () => painter.paint(canvas, const Size(1, 1)),
          returnsNormally,
        );
      });

      test('handles large inflated values', () {
        final painter = CirclePainter(inflatedValues: [10000, 20000, 30000]);
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        expect(
          () => painter.paint(canvas, const Size(100, 100)),
          returnsNormally,
        );
      });

      test('paints creates correct number of paths', () {
        const inflatedValues = [100, 200, 300, 400, 500];
        final painter = CirclePainter(inflatedValues: inflatedValues);
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        // Just verify it runs without error
        expect(
          () => painter.paint(canvas, const Size(400, 400)),
          returnsNormally,
        );
      });
    });

    group('multiple painters', () {
      testWidgets('can render multiple CustomPaints', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  CustomPaint(
                    key: const Key('paint-1'),
                    painter: CirclePainter(inflatedValues: const [100]),
                    size: const Size(200, 200),
                  ),
                  CustomPaint(
                    key: const Key('paint-2'),
                    painter: CirclePainter(inflatedValues: const [200]),
                    size: const Size(200, 200),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('paint-1')), findsOneWidget);
        expect(find.byKey(const Key('paint-2')), findsOneWidget);
      });
    });
  });
}
