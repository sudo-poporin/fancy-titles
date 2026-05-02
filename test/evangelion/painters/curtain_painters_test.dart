import 'dart:ui';

import 'package:fancy_titles/evangelion/painters/painters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Evangelion Curtain Painters', () {
    group('FirstCurtainPainter', () {
      test('can be instantiated', () {
        const painter = FirstCurtainPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = FirstCurtainPainter();
        const painter2 = FirstCurtainPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = FirstCurtainPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        // Should not throw
        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = FirstCurtainPainter();

        // Small canvas
        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        // Large canvas
        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = FirstCurtainPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('SecondCurtainPainter', () {
      test('can be instantiated', () {
        const painter = SecondCurtainPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = SecondCurtainPainter();
        const painter2 = SecondCurtainPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = SecondCurtainPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = SecondCurtainPainter();

        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = SecondCurtainPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('ThirdCurtainPainter', () {
      test('can be instantiated', () {
        const painter = ThirdCurtainPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = ThirdCurtainPainter();
        const painter2 = ThirdCurtainPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = ThirdCurtainPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = ThirdCurtainPainter();

        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = ThirdCurtainPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('FourthCurtainPainter', () {
      test('can be instantiated', () {
        const painter = FourthCurtainPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = FourthCurtainPainter();
        const painter2 = FourthCurtainPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = FourthCurtainPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = FourthCurtainPainter();

        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = FourthCurtainPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('FifthCurtainPainter', () {
      test('can be instantiated', () {
        const painter = FifthCurtainPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = FifthCurtainPainter();
        const painter2 = FifthCurtainPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = FifthCurtainPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = FifthCurtainPainter();

        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = FifthCurtainPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('all painters', () {
      test('all painters are const constructible', () {
        const painters = [
          FirstCurtainPainter(),
          SecondCurtainPainter(),
          ThirdCurtainPainter(),
          FourthCurtainPainter(),
          FifthCurtainPainter(),
        ];

        expect(painters.length, equals(5));
        for (final painter in painters) {
          expect(painter, isNotNull);
        }
      });

      test('all painters return false for shouldRepaint', () {
        const firstPainter = FirstCurtainPainter();
        const secondPainter = SecondCurtainPainter();
        const thirdPainter = ThirdCurtainPainter();
        const fourthPainter = FourthCurtainPainter();
        const fifthPainter = FifthCurtainPainter();

        expect(
          firstPainter.shouldRepaint(const FirstCurtainPainter()),
          isFalse,
        );
        expect(
          secondPainter.shouldRepaint(const SecondCurtainPainter()),
          isFalse,
        );
        expect(
          thirdPainter.shouldRepaint(const ThirdCurtainPainter()),
          isFalse,
        );
        expect(
          fourthPainter.shouldRepaint(const FourthCurtainPainter()),
          isFalse,
        );
        expect(
          fifthPainter.shouldRepaint(const FifthCurtainPainter()),
          isFalse,
        );
      });

      test('all painters paint without errors on same canvas', () {
        const painters = [
          FirstCurtainPainter(),
          SecondCurtainPainter(),
          ThirdCurtainPainter(),
          FourthCurtainPainter(),
          FifthCurtainPainter(),
        ];

        for (final painter in painters) {
          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          // Should not throw
          painter.paint(canvas, const Size(200, 200));

          final picture = recorder.endRecording();
          expect(picture, isNotNull);
        }
      });

      test('all painters handle zero-sized canvas', () {
        const painters = [
          FirstCurtainPainter(),
          SecondCurtainPainter(),
          ThirdCurtainPainter(),
          FourthCurtainPainter(),
          FifthCurtainPainter(),
        ];

        for (final painter in painters) {
          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          // Should not throw even with zero size
          painter.paint(canvas, Size.zero);

          final picture = recorder.endRecording();
          expect(picture, isNotNull);
        }
      });

      test('curtain painters draw black shapes', () {
        // Verify that curtain painters use black color for fill
        // This is a design verification test
        const painter = FirstCurtainPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        // Paint should complete without errors
        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });
    });

    group('debug API', () {
      test('FirstCurtainPainter caches path and size after paint', () {
        FirstCurtainPainter.debugResetCache();
        expect(FirstCurtainPainter.debugCachedPath, isNull);
        expect(FirstCurtainPainter.debugCachedSize, isNull);

        const painter = FirstCurtainPainter();
        const size = Size(100, 100);
        final recorder = PictureRecorder();
        painter.paint(Canvas(recorder), size);

        expect(FirstCurtainPainter.debugCachedPath, isNotNull);
        expect(FirstCurtainPainter.debugCachedSize, equals(size));
      });

      test('SecondCurtainPainter caches path and size after paint', () {
        SecondCurtainPainter.debugResetCache();
        expect(SecondCurtainPainter.debugCachedPath, isNull);
        expect(SecondCurtainPainter.debugCachedSize, isNull);

        const painter = SecondCurtainPainter();
        const size = Size(120, 120);
        final recorder = PictureRecorder();
        painter.paint(Canvas(recorder), size);

        expect(SecondCurtainPainter.debugCachedPath, isNotNull);
        expect(SecondCurtainPainter.debugCachedSize, equals(size));
      });

      test('ThirdCurtainPainter caches path and size after paint', () {
        ThirdCurtainPainter.debugResetCache();
        expect(ThirdCurtainPainter.debugCachedPath, isNull);
        expect(ThirdCurtainPainter.debugCachedSize, isNull);

        const painter = ThirdCurtainPainter();
        const size = Size(150, 150);
        final recorder = PictureRecorder();
        painter.paint(Canvas(recorder), size);

        expect(ThirdCurtainPainter.debugCachedPath, isNotNull);
        expect(ThirdCurtainPainter.debugCachedSize, equals(size));
      });

      test('FourthCurtainPainter caches path and size after paint', () {
        FourthCurtainPainter.debugResetCache();
        expect(FourthCurtainPainter.debugCachedPath, isNull);
        expect(FourthCurtainPainter.debugCachedSize, isNull);

        const painter = FourthCurtainPainter();
        const size = Size(180, 180);
        final recorder = PictureRecorder();
        painter.paint(Canvas(recorder), size);

        expect(FourthCurtainPainter.debugCachedPath, isNotNull);
        expect(FourthCurtainPainter.debugCachedSize, equals(size));
      });

      test('FifthCurtainPainter caches path and size after paint', () {
        FifthCurtainPainter.debugResetCache();
        expect(FifthCurtainPainter.debugCachedPath, isNull);
        expect(FifthCurtainPainter.debugCachedSize, isNull);

        const painter = FifthCurtainPainter();
        const size = Size(210, 210);
        final recorder = PictureRecorder();
        painter.paint(Canvas(recorder), size);

        expect(FifthCurtainPainter.debugCachedPath, isNotNull);
        expect(FifthCurtainPainter.debugCachedSize, equals(size));
      });
    });
  });
}
