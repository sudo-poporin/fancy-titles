import 'dart:ui';

import 'package:fancy_titles/evangelion/painters/painters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Evangelion Cross Painters', () {
    group('FirstCrossPainter', () {
      test('can be instantiated', () {
        const painter = FirstCrossPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = FirstCrossPainter();
        const painter2 = FirstCrossPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = FirstCrossPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        // Should not throw
        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = FirstCrossPainter();

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
        const painter = FirstCrossPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('SecondCrossPainter', () {
      test('can be instantiated', () {
        const painter = SecondCrossPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = SecondCrossPainter();
        const painter2 = SecondCrossPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = SecondCrossPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = SecondCrossPainter();

        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = SecondCrossPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('ThirdCrossPainter', () {
      test('can be instantiated', () {
        const painter = ThirdCrossPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = ThirdCrossPainter();
        const painter2 = ThirdCrossPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = ThirdCrossPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = ThirdCrossPainter();

        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = ThirdCrossPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('FourthCrossRenderer', () {
      test('can be instantiated', () {
        const painter = FourthCrossRenderer();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = FourthCrossRenderer();
        const painter2 = FourthCrossRenderer();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = FourthCrossRenderer();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = FourthCrossRenderer();

        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = FourthCrossRenderer();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('FifthCrossPainter', () {
      test('can be instantiated', () {
        const painter = FifthCrossPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = FifthCrossPainter();
        const painter2 = FifthCrossPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = FifthCrossPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = FifthCrossPainter();

        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = FifthCrossPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('SixthCrossPainter', () {
      test('can be instantiated', () {
        const painter = SixthCrossPainter();
        expect(painter, isNotNull);
      });

      test('shouldRepaint returns false for same type', () {
        const painter1 = SixthCrossPainter();
        const painter2 = SixthCrossPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('paints without errors', () {
        const painter = SixthCrossPainter();
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        painter.paint(canvas, const Size(100, 100));

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      });

      test('paints on various canvas sizes', () {
        const painter = SixthCrossPainter();

        final smallRecorder = PictureRecorder();
        painter.paint(Canvas(smallRecorder), const Size(10, 10));
        expect(smallRecorder.endRecording(), isNotNull);

        final largeRecorder = PictureRecorder();
        painter.paint(Canvas(largeRecorder), const Size(1000, 1000));
        expect(largeRecorder.endRecording(), isNotNull);
      });

      test('paints on non-square canvas', () {
        const painter = SixthCrossPainter();
        final recorder = PictureRecorder();

        painter.paint(Canvas(recorder), const Size(200, 100));

        expect(recorder.endRecording(), isNotNull);
      });
    });

    group('all painters', () {
      test('all painters are const constructible', () {
        const painters = [
          FirstCrossPainter(),
          SecondCrossPainter(),
          ThirdCrossPainter(),
          FourthCrossRenderer(),
          FifthCrossPainter(),
          SixthCrossPainter(),
        ];

        expect(painters.length, equals(6));
        for (final painter in painters) {
          expect(painter, isNotNull);
        }
      });

      test('all painters return false for shouldRepaint', () {
        const firstPainter = FirstCrossPainter();
        const secondPainter = SecondCrossPainter();
        const thirdPainter = ThirdCrossPainter();
        const fourthPainter = FourthCrossRenderer();
        const fifthPainter = FifthCrossPainter();
        const sixthPainter = SixthCrossPainter();

        expect(firstPainter.shouldRepaint(const FirstCrossPainter()), isFalse);
        expect(
          secondPainter.shouldRepaint(const SecondCrossPainter()),
          isFalse,
        );
        expect(thirdPainter.shouldRepaint(const ThirdCrossPainter()), isFalse);
        expect(
          fourthPainter.shouldRepaint(const FourthCrossRenderer()),
          isFalse,
        );
        expect(fifthPainter.shouldRepaint(const FifthCrossPainter()), isFalse);
        expect(sixthPainter.shouldRepaint(const SixthCrossPainter()), isFalse);
      });

      test('all painters paint without errors on same canvas', () {
        const painters = [
          FirstCrossPainter(),
          SecondCrossPainter(),
          ThirdCrossPainter(),
          FourthCrossRenderer(),
          FifthCrossPainter(),
          SixthCrossPainter(),
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
          FirstCrossPainter(),
          SecondCrossPainter(),
          ThirdCrossPainter(),
          FourthCrossRenderer(),
          FifthCrossPainter(),
          SixthCrossPainter(),
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
    });
  });
}
