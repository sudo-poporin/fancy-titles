import 'dart:ui';

import 'package:fancy_titles/sonic_mania/painters/text_bg_painters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LargeBGDraw', () {
    test('can be instantiated with color', () {
      final painter = LargeBGDraw(Colors.blue);
      expect(painter, isA<CustomPainter>());
    });

    test('creates paint with correct color', () {
      const color = Color(0xFFFF5722);
      final painter = LargeBGDraw(color);
      // Compare color values instead of Color objects directly
      expect(painter.painter.color.toARGB32(), equals(color.toARGB32()));
    });

    test('creates paint with fill style', () {
      final painter = LargeBGDraw(Colors.green);
      expect(painter.painter.style, equals(PaintingStyle.fill));
    });

    test('shouldRepaint returns false', () {
      final painter1 = LargeBGDraw(Colors.blue);
      final painter2 = LargeBGDraw(Colors.red);

      expect(painter1.shouldRepaint(painter2), isFalse);
    });

    test('paint does not throw', () {
      final painter = LargeBGDraw(Colors.blue);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(200, 100);

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('paint works with zero size', () {
      final painter = LargeBGDraw(Colors.blue);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size.zero;

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('paint works with large size', () {
      final painter = LargeBGDraw(Colors.blue);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(10000, 10000);

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('can be instantiated with different colors', () {
      const colors = [
        Color(0xFFFF0000), // red
        Color(0xFF0000FF), // blue
        Color(0xFF00FF00), // green
        Colors.black,
        Colors.white,
        Colors.transparent,
      ];

      for (final color in colors) {
        final painter = LargeBGDraw(color);
        expect(painter.painter.color.toARGB32(), equals(color.toARGB32()));
      }
    });
  });

  group('SmallBGDraw', () {
    test('can be instantiated with color', () {
      final painter = SmallBGDraw(Colors.blue);
      expect(painter, isA<CustomPainter>());
    });

    test('creates paint with correct color', () {
      const color = Color(0xFFFF5722);
      final painter = SmallBGDraw(color);
      // Compare color values instead of Color objects directly
      expect(painter.painter.color.toARGB32(), equals(color.toARGB32()));
    });

    test('creates paint with fill style', () {
      final painter = SmallBGDraw(Colors.green);
      expect(painter.painter.style, equals(PaintingStyle.fill));
    });

    test('shouldRepaint returns false', () {
      final painter1 = SmallBGDraw(Colors.blue);
      final painter2 = SmallBGDraw(Colors.red);

      expect(painter1.shouldRepaint(painter2), isFalse);
    });

    test('paint does not throw', () {
      final painter = SmallBGDraw(Colors.blue);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(200, 100);

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('paint works with zero size', () {
      final painter = SmallBGDraw(Colors.blue);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size.zero;

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('paint works with large size', () {
      final painter = SmallBGDraw(Colors.blue);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(10000, 10000);

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('can be instantiated with different colors', () {
      const colors = [
        Color(0xFFFF0000), // red
        Color(0xFF0000FF), // blue
        Color(0xFF00FF00), // green
        Colors.black,
        Colors.white,
        Colors.transparent,
      ];

      for (final color in colors) {
        final painter = SmallBGDraw(color);
        expect(painter.painter.color.toARGB32(), equals(color.toARGB32()));
      }
    });
  });

  group('Painters comparison', () {
    test('LargeBGDraw and SmallBGDraw are different types', () {
      final large = LargeBGDraw(Colors.blue);
      final small = SmallBGDraw(Colors.blue);

      expect(large.runtimeType, isNot(equals(small.runtimeType)));
    });

    test('both painters can use same color', () {
      const color = Colors.purple;
      final large = LargeBGDraw(color);
      final small = SmallBGDraw(color);

      expect(large.painter.color, equals(small.painter.color));
    });

    test('both painters have same paint style', () {
      final large = LargeBGDraw(Colors.blue);
      final small = SmallBGDraw(Colors.blue);

      expect(large.painter.style, equals(small.painter.style));
      expect(large.painter.style, equals(PaintingStyle.fill));
    });
  });

  group('Integration with CustomPaint', () {
    testWidgets('LargeBGDraw works in CustomPaint widget', (tester) async {
      final painter = LargeBGDraw(Colors.blue);
      await tester.pumpWidget(
        MaterialApp(
          home: CustomPaint(
            painter: painter,
            size: const Size(200, 100),
          ),
        ),
      );

      // Find the CustomPaint with our specific painter
      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final hasOurPainter = customPaints.any((cp) => cp.painter == painter);
      expect(hasOurPainter, isTrue);
    });

    testWidgets('SmallBGDraw works in CustomPaint widget', (tester) async {
      final painter = SmallBGDraw(Colors.red);
      await tester.pumpWidget(
        MaterialApp(
          home: CustomPaint(
            painter: painter,
            size: const Size(200, 100),
          ),
        ),
      );

      // Find the CustomPaint with our specific painter
      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final hasOurPainter = customPaints.any((cp) => cp.painter == painter);
      expect(hasOurPainter, isTrue);
    });

    testWidgets('both painters render without errors', (tester) async {
      final largePainter = LargeBGDraw(Colors.blue);
      final smallPainter = SmallBGDraw(Colors.red);
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              CustomPaint(
                painter: largePainter,
                size: const Size(200, 50),
              ),
              CustomPaint(
                painter: smallPainter,
                size: const Size(200, 50),
              ),
            ],
          ),
        ),
      );

      // Verify both painters are in the widget tree
      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final hasLargePainter = customPaints.any(
        (cp) => cp.painter == largePainter,
      );
      final hasSmallPainter = customPaints.any(
        (cp) => cp.painter == smallPainter,
      );
      expect(hasLargePainter, isTrue);
      expect(hasSmallPainter, isTrue);
      expect(tester.takeException(), isNull);
    });
  });
}
