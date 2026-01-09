import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fancy_titles/evangelion/painters/cross/fifth_cross_painter.dart';
import 'package:fancy_titles/evangelion/painters/cross/first_cross_painter.dart';
import 'package:fancy_titles/evangelion/painters/cross/fourth_cross_painter.dart';
import 'package:fancy_titles/evangelion/painters/cross/second_cross_painter.dart';
import 'package:fancy_titles/evangelion/painters/cross/sixth_cross_painter.dart';
import 'package:fancy_titles/evangelion/painters/cross/third_cross_painter.dart';
import 'package:fancy_titles/evangelion/painters/curtain/fifth_curtain_painter.dart';
import 'package:fancy_titles/evangelion/painters/curtain/first_curtain_painter.dart';
import 'package:fancy_titles/evangelion/painters/curtain/fourth_curtain_painter.dart';
import 'package:fancy_titles/evangelion/painters/curtain/second_curtain_painter.dart';
import 'package:fancy_titles/evangelion/painters/curtain/third_curtain_painter.dart';
import 'package:fancy_titles/sonic_mania/painters/text_bg_painters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mock Canvas that records drawPath calls for testing.
class MockCanvas implements Canvas {
  final List<Path> drawnPaths = [];
  final List<Paint> usedPaints = [];

  @override
  void drawPath(Path path, Paint paint) {
    drawnPaths.add(path);
    usedPaints.add(paint);
  }

  // Required overrides - no-op implementations
  @override
  void clipPath(Path path, {bool doAntiAlias = true}) {}

  @override
  void clipRRect(RRect rrect, {bool doAntiAlias = true}) {}

  @override
  void clipRect(
    Rect rect, {
    ui.ClipOp clipOp = ui.ClipOp.intersect,
    bool doAntiAlias = true,
  }) {}

  @override
  void drawArc(
    Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    Paint paint,
  ) {}

  @override
  void drawAtlas(
    ui.Image atlas,
    List<ui.RSTransform> transforms,
    List<Rect> rects,
    List<Color>? colors,
    ui.BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) {}

  @override
  void drawCircle(Offset c, double radius, Paint paint) {}

  @override
  void drawColor(Color color, ui.BlendMode blendMode) {}

  @override
  void drawDRRect(RRect outer, RRect inner, Paint paint) {}

  @override
  void drawImage(ui.Image image, Offset offset, Paint paint) {}

  @override
  void drawImageNine(
    ui.Image image,
    Rect center,
    Rect dst,
    Paint paint,
  ) {}

  @override
  void drawImageRect(ui.Image image, Rect src, Rect dst, Paint paint) {}

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {}

  @override
  void drawOval(Rect rect, Paint paint) {}

  @override
  void drawPaint(Paint paint) {}

  @override
  void drawParagraph(ui.Paragraph paragraph, Offset offset) {}

  @override
  void drawPicture(ui.Picture picture) {}

  @override
  void drawPoints(ui.PointMode pointMode, List<Offset> points, Paint paint) {}

  @override
  void drawRRect(RRect rrect, Paint paint) {}

  @override
  void drawRawAtlas(
    ui.Image atlas,
    Float32List rstTransforms,
    Float32List rects,
    Int32List? colors,
    ui.BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) {}

  @override
  void drawRawPoints(ui.PointMode pointMode, Float32List points, Paint paint) {}

  @override
  void drawRect(Rect rect, Paint paint) {}

  @override
  void drawShadow(
    Path path,
    Color color,
    double elevation,
    bool transparentOccluder,
  ) {}

  @override
  void drawVertices(
    ui.Vertices vertices,
    ui.BlendMode blendMode,
    Paint paint,
  ) {}

  @override
  int getSaveCount() => 0;

  @override
  void restore() {}

  @override
  void restoreToCount(int count) {}

  @override
  void rotate(double radians) {}

  @override
  void save() {}

  @override
  void saveLayer(Rect? bounds, Paint paint) {}

  @override
  void scale(double sx, [double? sy]) {}

  @override
  void skew(double sx, double sy) {}

  @override
  void transform(Float64List matrix4) {}

  @override
  void translate(double dx, double dy) {}

  @override
  Rect getDestinationClipBounds() => Rect.zero;

  @override
  Rect getLocalClipBounds() => Rect.zero;

  @override
  Float64List getTransform() => Float64List(16);

  @override
  void clipRSuperellipse(
    ui.RSuperellipse rSuperellipse, {
    bool doAntiAlias = true,
  }) {}

  @override
  void drawRSuperellipse(ui.RSuperellipse rSuperellipse, Paint paint) {}
}

void main() {
  group('Evangelion Cross Painters - Path Caching', () {
    const testSize = Size(400, 300);
    const differentSize = Size(800, 600);
    late MockCanvas canvas;

    setUp(() {
      canvas = MockCanvas();
      // Reset all caches before each test
      FirstCrossPainter.debugResetCache();
      SecondCrossPainter.debugResetCache();
      ThirdCrossPainter.debugResetCache();
      FourthCrossRenderer.debugResetCache();
      FifthCrossPainter.debugResetCache();
      SixthCrossPainter.debugResetCache();
    });

    test('FirstCrossPainter caches path on repeated paints', () {
      const painter = FirstCrossPainter();

      // First paint - should create path
      expect(FirstCrossPainter.debugCachedPath, isNull);
      painter.paint(canvas, testSize);

      final pathAfterFirst = FirstCrossPainter.debugCachedPath;
      expect(pathAfterFirst, isNotNull);
      expect(FirstCrossPainter.debugCachedSize, equals(testSize));

      // Second paint with same size - should reuse path
      painter.paint(canvas, testSize);
      final pathAfterSecond = FirstCrossPainter.debugCachedPath;

      // Should be the exact same object (not recreated)
      expect(identical(pathAfterFirst, pathAfterSecond), isTrue);
    });

    test('FirstCrossPainter recreates path on size change', () {
      final painter = const FirstCrossPainter()..paint(canvas, testSize);
      final pathSmall = FirstCrossPainter.debugCachedPath;

      painter.paint(canvas, differentSize);
      final pathLarge = FirstCrossPainter.debugCachedPath;

      // Should be different objects for different sizes
      expect(identical(pathSmall, pathLarge), isFalse);
      expect(FirstCrossPainter.debugCachedSize, equals(differentSize));
    });

    test('FirstCrossPainter shouldRepaint returns false', () {
      const painter = FirstCrossPainter();
      expect(painter.shouldRepaint(painter), isFalse);
    });

    test('SecondCrossPainter caches path correctly', () {
      final painter = const SecondCrossPainter()..paint(canvas, testSize);
      final path1 = SecondCrossPainter.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = SecondCrossPainter.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('ThirdCrossPainter caches path correctly', () {
      final painter = const ThirdCrossPainter()..paint(canvas, testSize);
      final path1 = ThirdCrossPainter.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = ThirdCrossPainter.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('FourthCrossRenderer caches path correctly', () {
      final painter = const FourthCrossRenderer()..paint(canvas, testSize);
      final path1 = FourthCrossRenderer.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = FourthCrossRenderer.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('FifthCrossPainter caches path correctly', () {
      final painter = const FifthCrossPainter()..paint(canvas, testSize);
      final path1 = FifthCrossPainter.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = FifthCrossPainter.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('SixthCrossPainter caches path correctly', () {
      final painter = const SixthCrossPainter()..paint(canvas, testSize);
      final path1 = SixthCrossPainter.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = SixthCrossPainter.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });
  });

  group('Evangelion Curtain Painters - Path Caching', () {
    const testSize = Size(400, 300);
    late MockCanvas canvas;

    setUp(() {
      canvas = MockCanvas();
      FirstCurtainPainter.debugResetCache();
      SecondCurtainPainter.debugResetCache();
      ThirdCurtainPainter.debugResetCache();
      FourthCurtainPainter.debugResetCache();
      FifthCurtainPainter.debugResetCache();
    });

    test('FirstCurtainPainter caches path on repeated paints', () {
      final painter = const FirstCurtainPainter()..paint(canvas, testSize);
      final path1 = FirstCurtainPainter.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = FirstCurtainPainter.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('SecondCurtainPainter caches path correctly', () {
      final painter = const SecondCurtainPainter()..paint(canvas, testSize);
      final path1 = SecondCurtainPainter.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = SecondCurtainPainter.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('ThirdCurtainPainter caches path correctly', () {
      final painter = const ThirdCurtainPainter()..paint(canvas, testSize);
      final path1 = ThirdCurtainPainter.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = ThirdCurtainPainter.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('FourthCurtainPainter caches path correctly', () {
      final painter = const FourthCurtainPainter()..paint(canvas, testSize);
      final path1 = FourthCurtainPainter.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = FourthCurtainPainter.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('FifthCurtainPainter caches path correctly', () {
      final painter = const FifthCurtainPainter()..paint(canvas, testSize);
      final path1 = FifthCurtainPainter.debugCachedPath;

      painter.paint(canvas, testSize);
      final path2 = FifthCurtainPainter.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('All curtain painters return false for shouldRepaint', () {
      expect(
        const FirstCurtainPainter().shouldRepaint(const FirstCurtainPainter()),
        isFalse,
      );
      expect(
        const SecondCurtainPainter().shouldRepaint(
          const SecondCurtainPainter(),
        ),
        isFalse,
      );
      expect(
        const ThirdCurtainPainter().shouldRepaint(const ThirdCurtainPainter()),
        isFalse,
      );
      expect(
        const FourthCurtainPainter().shouldRepaint(
          const FourthCurtainPainter(),
        ),
        isFalse,
      );
      expect(
        const FifthCurtainPainter().shouldRepaint(const FifthCurtainPainter()),
        isFalse,
      );
    });
  });

  group('Sonic Mania BG Painters - Path Caching', () {
    const testSize = Size(400, 300);
    const differentSize = Size(800, 600);
    late MockCanvas canvas;

    setUp(() {
      canvas = MockCanvas();
      LargeBGDraw.debugResetCache();
      SmallBGDraw.debugResetCache();
    });

    test('LargeBGDraw caches path on repeated paints', () {
      final painter = LargeBGDraw(Colors.red)..paint(canvas, testSize);
      final path1 = LargeBGDraw.debugCachedPath;
      expect(path1, isNotNull);

      painter.paint(canvas, testSize);
      final path2 = LargeBGDraw.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('LargeBGDraw recreates path on size change', () {
      final painter = LargeBGDraw(Colors.red)..paint(canvas, testSize);
      final pathSmall = LargeBGDraw.debugCachedPath;

      painter.paint(canvas, differentSize);
      final pathLarge = LargeBGDraw.debugCachedPath;

      expect(identical(pathSmall, pathLarge), isFalse);
    });

    test('SmallBGDraw caches path on repeated paints', () {
      final painter = SmallBGDraw(Colors.blue)..paint(canvas, testSize);
      final path1 = SmallBGDraw.debugCachedPath;
      expect(path1, isNotNull);

      painter.paint(canvas, testSize);
      final path2 = SmallBGDraw.debugCachedPath;

      expect(identical(path1, path2), isTrue);
    });

    test('SmallBGDraw recreates path on size change', () {
      final painter = SmallBGDraw(Colors.blue)..paint(canvas, testSize);
      final pathSmall = SmallBGDraw.debugCachedPath;

      painter.paint(canvas, differentSize);
      final pathLarge = SmallBGDraw.debugCachedPath;

      expect(identical(pathSmall, pathLarge), isFalse);
    });

    test('BG painters return false for shouldRepaint', () {
      expect(
        LargeBGDraw(Colors.red).shouldRepaint(LargeBGDraw(Colors.red)),
        isFalse,
      );
      expect(
        SmallBGDraw(Colors.blue).shouldRepaint(SmallBGDraw(Colors.blue)),
        isFalse,
      );
    });
  });

  group('Cache Invalidation Tests', () {
    const testSize = Size(400, 300);
    late MockCanvas canvas;

    setUp(() {
      canvas = MockCanvas();
    });

    test('debugResetCache clears all cached data for cross painters', () {
      const FirstCrossPainter().paint(canvas, testSize);
      expect(FirstCrossPainter.debugCachedPath, isNotNull);
      expect(FirstCrossPainter.debugCachedSize, isNotNull);

      FirstCrossPainter.debugResetCache();

      expect(FirstCrossPainter.debugCachedPath, isNull);
      expect(FirstCrossPainter.debugCachedSize, isNull);
    });

    test('debugResetCache clears all cached data for BG painters', () {
      LargeBGDraw(Colors.red).paint(canvas, testSize);
      expect(LargeBGDraw.debugCachedPath, isNotNull);
      expect(LargeBGDraw.debugCachedSize, isNotNull);

      LargeBGDraw.debugResetCache();

      expect(LargeBGDraw.debugCachedPath, isNull);
      expect(LargeBGDraw.debugCachedSize, isNull);
    });
  });

  group('Multiple Paint Calls Performance Simulation', () {
    const testSize = Size(400, 300);
    late MockCanvas canvas;

    setUp(() {
      canvas = MockCanvas();
      FirstCrossPainter.debugResetCache();
    });

    test('Path is only created once for 100 paint calls with same size', () {
      final painter = const FirstCrossPainter()..paint(canvas, testSize);
      final originalPath = FirstCrossPainter.debugCachedPath;

      // Simulate 99 more paint calls (like during animation)
      for (var i = 0; i < 99; i++) {
        painter.paint(canvas, testSize);
      }

      // Path should still be the exact same object
      expect(
        identical(originalPath, FirstCrossPainter.debugCachedPath),
        isTrue,
      );
    });
  });
}
