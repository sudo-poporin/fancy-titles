import 'dart:ui';

import 'package:fancy_titles/sonic_mania/clippers/bar_clipper.dart';
import 'package:fancy_titles/sonic_mania/painters/text_bg_painters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LargeBGDraw', () {
    test('can be instantiated with color', () {
      final painter = LargeBGDraw(Colors.blue, slope: 1);
      expect(painter, isA<CustomPainter>());
    });

    test('creates paint with correct color', () {
      const color = Color(0xFFFF5722);
      final painter = LargeBGDraw(color, slope: 1);
      // Compare color values instead of Color objects directly
      expect(painter.painter.color.toARGB32(), equals(color.toARGB32()));
    });

    test('creates paint with fill style', () {
      final painter = LargeBGDraw(Colors.green, slope: 1);
      expect(painter.painter.style, equals(PaintingStyle.fill));
    });

    test('shouldRepaint es false con el mismo color y pendiente', () {
      final painter1 = LargeBGDraw(Colors.blue, slope: 1);
      final painter2 = LargeBGDraw(Colors.blue, slope: 1);

      expect(painter1.shouldRepaint(painter2), isFalse);
    });

    test('paint does not throw', () {
      final painter = LargeBGDraw(Colors.blue, slope: 1);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(200, 100);

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('paint works with zero size', () {
      final painter = LargeBGDraw(Colors.blue, slope: 1);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size.zero;

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('paint works with large size', () {
      final painter = LargeBGDraw(Colors.blue, slope: 1);
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
        final painter = LargeBGDraw(color, slope: 1);
        expect(painter.painter.color.toARGB32(), equals(color.toARGB32()));
      }
    });
  });

  group('SmallBGDraw', () {
    test('can be instantiated with color', () {
      final painter = SmallBGDraw(Colors.blue, slope: 1);
      expect(painter, isA<CustomPainter>());
    });

    test('creates paint with correct color', () {
      const color = Color(0xFFFF5722);
      final painter = SmallBGDraw(color, slope: 1);
      // Compare color values instead of Color objects directly
      expect(painter.painter.color.toARGB32(), equals(color.toARGB32()));
    });

    test('creates paint with fill style', () {
      final painter = SmallBGDraw(Colors.green, slope: 1);
      expect(painter.painter.style, equals(PaintingStyle.fill));
    });

    test('shouldRepaint es false con el mismo color y pendiente', () {
      final painter1 = SmallBGDraw(Colors.blue, slope: 1);
      final painter2 = SmallBGDraw(Colors.blue, slope: 1);

      expect(painter1.shouldRepaint(painter2), isFalse);
    });

    test('paint does not throw', () {
      final painter = SmallBGDraw(Colors.blue, slope: 1);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(200, 100);

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('paint works with zero size', () {
      final painter = SmallBGDraw(Colors.blue, slope: 1);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size.zero;

      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('paint works with large size', () {
      final painter = SmallBGDraw(Colors.blue, slope: 1);
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
        final painter = SmallBGDraw(color, slope: 1);
        expect(painter.painter.color.toARGB32(), equals(color.toARGB32()));
      }
    });
  });

  group('Painters comparison', () {
    test('LargeBGDraw and SmallBGDraw are different types', () {
      final large = LargeBGDraw(Colors.blue, slope: 1);
      final small = SmallBGDraw(Colors.blue, slope: 1);

      expect(large.runtimeType, isNot(equals(small.runtimeType)));
    });

    test('both painters can use same color', () {
      const color = Colors.purple;
      final large = LargeBGDraw(color, slope: 1);
      final small = SmallBGDraw(color, slope: 1);

      expect(large.painter.color, equals(small.painter.color));
    });

    test('both painters have same paint style', () {
      final large = LargeBGDraw(Colors.blue, slope: 1);
      final small = SmallBGDraw(Colors.blue, slope: 1);

      expect(large.painter.style, equals(small.painter.style));
      expect(large.painter.style, equals(PaintingStyle.fill));
    });
  });

  group('Integration with CustomPaint', () {
    testWidgets('LargeBGDraw works in CustomPaint widget', (tester) async {
      final painter = LargeBGDraw(Colors.blue, slope: 1);
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
      final painter = SmallBGDraw(Colors.red, slope: 1);
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
      final largePainter = LargeBGDraw(Colors.blue, slope: 1);
      final smallPainter = SmallBGDraw(Colors.red, slope: 1);
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

  group('debug API', () {
    test('LargeBGDraw caches path and size after paint', () {
      LargeBGDraw.debugResetCache();
      expect(LargeBGDraw.debugCachedPath, isNull);
      expect(LargeBGDraw.debugCachedSize, isNull);

      final painter = LargeBGDraw(const Color(0xFF000000), slope: 1);
      final recorder = PictureRecorder();
      painter.paint(Canvas(recorder), const Size(150, 80));

      expect(LargeBGDraw.debugCachedPath, isNotNull);
      expect(LargeBGDraw.debugCachedSize, equals(const Size(150, 80)));
    });

    test('SmallBGDraw caches path and size after paint', () {
      SmallBGDraw.debugResetCache();
      expect(SmallBGDraw.debugCachedPath, isNull);
      expect(SmallBGDraw.debugCachedSize, isNull);

      final painter = SmallBGDraw(const Color(0xFFFFFFFF), slope: 1);
      final recorder = PictureRecorder();
      painter.paint(Canvas(recorder), const Size(120, 40));

      expect(SmallBGDraw.debugCachedPath, isNotNull);
      expect(SmallBGDraw.debugCachedSize, equals(const Size(120, 40)));
    });
  });

  group('pendiente de los extremos', () {
    void paintLarge(double slope, Size size) => LargeBGDraw(
      Colors.black,
      slope: slope,
    ).paint(Canvas(PictureRecorder()), size);

    void paintSmall(double slope, Size size) => SmallBGDraw(
      Colors.white,
      slope: slope,
    ).paint(Canvas(PictureRecorder()), size);

    for (final screen in const [Size(844, 390), Size(390, 844)]) {
      test('LargeBGDraw es paralela a las franjas en $screen', () {
        LargeBGDraw.debugResetCache();
        const bar = Size(200, 30);
        paintLarge(stripeSlope(screen), bar);

        final bounds = LargeBGDraw.debugCachedPath!.getBounds();
        final band = bar.height * 0.4;
        expect(-bounds.left / band, closeTo(stripeSlope(screen), 1e-4));
        expect(
          (bounds.right - bar.width) / band,
          closeTo(stripeSlope(screen), 1e-4),
        );
      });

      test('SmallBGDraw es paralela a las franjas en $screen', () {
        SmallBGDraw.debugResetCache();
        const bar = Size(120, 24);
        paintSmall(stripeSlope(screen), bar);

        final bounds = SmallBGDraw.debugCachedPath!.getBounds();
        final band = bar.height * 0.2;
        expect(-bounds.left / band, closeTo(stripeSlope(screen), 1e-4));
        expect(
          (bounds.right - bar.width) / band,
          closeTo(stripeSlope(screen), 1e-4),
        );
      });
    }

    test('mismo Size y otra pendiente reconstruye el path', () {
      LargeBGDraw.debugResetCache();
      const bar = Size(200, 30);
      paintLarge(1, bar);
      final first = LargeBGDraw.debugCachedPath;

      paintLarge(2, bar);

      expect(LargeBGDraw.debugCachedPath, isNot(same(first)));
      expect(LargeBGDraw.debugCachedSlope, 2);
      expect(
        -LargeBGDraw.debugCachedPath!.getBounds().left,
        closeTo(2 * 30 * 0.4, 1e-4),
      );
    });

    test('dos barras de distinto tamaño pintan cada una su path', () {
      LargeBGDraw.debugResetCache();
      paintLarge(1, const Size(200, 30));
      paintLarge(1, const Size(300, 50));

      expect(LargeBGDraw.debugCachedSize, const Size(300, 50));
      expect(
        LargeBGDraw.debugCachedPath!.getBounds().right,
        closeTo(300 + 50 * 0.4, 1e-4),
      );
    });

    test('pendiente 0 con tamaño 0 da un path finito', () {
      LargeBGDraw.debugResetCache();
      SmallBGDraw.debugResetCache();
      paintLarge(0, Size.zero);
      paintSmall(0, Size.zero);

      expect(LargeBGDraw.debugCachedPath!.getBounds().isFinite, isTrue);
      expect(SmallBGDraw.debugCachedPath!.getBounds().isFinite, isTrue);
    });

    test('debugResetCache limpia la pendiente', () {
      paintLarge(1, const Size(10, 10));
      paintSmall(1, const Size(10, 10));
      LargeBGDraw.debugResetCache();
      SmallBGDraw.debugResetCache();

      expect(LargeBGDraw.debugCachedSlope, isNull);
      expect(SmallBGDraw.debugCachedSlope, isNull);
    });

    test('shouldRepaint es true si cambia la pendiente o el color', () {
      final base = LargeBGDraw(Colors.black, slope: 1);
      expect(LargeBGDraw(Colors.black, slope: 2).shouldRepaint(base), isTrue);
      expect(LargeBGDraw(Colors.red, slope: 1).shouldRepaint(base), isTrue);

      final small = SmallBGDraw(Colors.white, slope: 1);
      expect(SmallBGDraw(Colors.white, slope: 2).shouldRepaint(small), isTrue);
      expect(SmallBGDraw(Colors.red, slope: 1).shouldRepaint(small), isTrue);
    });
  });
}
