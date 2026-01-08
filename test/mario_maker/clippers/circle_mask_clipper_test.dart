import 'dart:ui';

import 'package:fancy_titles/mario_maker/clippers/circle_mask_clipper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CircleMaskClipper', () {
    group('instantiation', () {
      test('can be instantiated with required parameters', () {
        final clipper = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        expect(clipper, isNotNull);
      });

      test('stores radius correctly', () {
        final clipper = CircleMaskClipper(
          radius: 75,
          center: const Offset(100, 100),
        );
        expect(clipper.radius, equals(75));
      });

      test('stores center correctly', () {
        final clipper = CircleMaskClipper(
          radius: 50,
          center: const Offset(150, 200),
        );
        expect(clipper.center, equals(const Offset(150, 200)));
      });
    });

    group('getClip', () {
      test('returns a Path', () {
        final clipper = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        final path = clipper.getClip(const Size(200, 200));

        expect(path, isA<Path>());
      });

      test('creates path with correct bounds', () {
        final clipper = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        final path = clipper.getClip(const Size(200, 200));
        final bounds = path.getBounds();

        // Circle at (100, 100) with radius 50 should have bounds:
        // left: 50, top: 50, right: 150, bottom: 150
        expect(bounds.left, equals(50));
        expect(bounds.top, equals(50));
        expect(bounds.right, equals(150));
        expect(bounds.bottom, equals(150));
      });

      test('path bounds reflect radius', () {
        final smallClipper = CircleMaskClipper(
          radius: 25,
          center: const Offset(100, 100),
        );
        final largeClipper = CircleMaskClipper(
          radius: 100,
          center: const Offset(100, 100),
        );

        final smallPath = smallClipper.getClip(const Size(200, 200));
        final largePath = largeClipper.getClip(const Size(200, 200));

        final smallBounds = smallPath.getBounds();
        final largeBounds = largePath.getBounds();

        expect(smallBounds.width, equals(50)); // 25 * 2
        expect(largeBounds.width, equals(200)); // 100 * 2
        expect(largeBounds.width, greaterThan(smallBounds.width));
      });

      test('path bounds reflect center position', () {
        final leftClipper = CircleMaskClipper(
          radius: 50,
          center: const Offset(50, 100),
        );
        final rightClipper = CircleMaskClipper(
          radius: 50,
          center: const Offset(150, 100),
        );

        final leftPath = leftClipper.getClip(const Size(200, 200));
        final rightPath = rightClipper.getClip(const Size(200, 200));

        final leftBounds = leftPath.getBounds();
        final rightBounds = rightPath.getBounds();

        expect(leftBounds.center.dx, equals(50));
        expect(rightBounds.center.dx, equals(150));
      });

      test('handles zero radius', () {
        final clipper = CircleMaskClipper(
          radius: 0,
          center: const Offset(100, 100),
        );
        final path = clipper.getClip(const Size(200, 200));
        final bounds = path.getBounds();

        expect(bounds.width, equals(0));
        expect(bounds.height, equals(0));
      });

      test('handles large radius', () {
        final clipper = CircleMaskClipper(
          radius: 1000,
          center: const Offset(100, 100),
        );
        final path = clipper.getClip(const Size(200, 200));
        final bounds = path.getBounds();

        expect(bounds.width, equals(2000));
        expect(bounds.height, equals(2000));
      });

      test('handles negative center coordinates', () {
        final clipper = CircleMaskClipper(
          radius: 50,
          center: const Offset(-50, -50),
        );
        final path = clipper.getClip(const Size(200, 200));
        final bounds = path.getBounds();

        expect(bounds.center.dx, equals(-50));
        expect(bounds.center.dy, equals(-50));
      });

      test('handles center at origin', () {
        final clipper = CircleMaskClipper(
          radius: 50,
          center: Offset.zero,
        );
        final path = clipper.getClip(const Size(200, 200));
        final bounds = path.getBounds();

        expect(bounds.center, equals(Offset.zero));
      });

      test('size parameter does not affect path shape', () {
        final clipper = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );

        final smallSizePath = clipper.getClip(const Size(50, 50));
        final largeSizePath = clipper.getClip(const Size(500, 500));

        final smallBounds = smallSizePath.getBounds();
        final largeBounds = largeSizePath.getBounds();

        // Path bounds should be the same regardless of size parameter
        expect(smallBounds, equals(largeBounds));
      });
    });

    group('shouldReclip', () {
      test('returns false when radius and center are the same', () {
        final clipper1 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        final clipper2 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );

        expect(clipper1.shouldReclip(clipper2), isFalse);
      });

      test('returns true when radius changes', () {
        final clipper1 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        final clipper2 = CircleMaskClipper(
          radius: 75,
          center: const Offset(100, 100),
        );

        expect(clipper1.shouldReclip(clipper2), isTrue);
      });

      test('returns true when center.x changes', () {
        final clipper1 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        final clipper2 = CircleMaskClipper(
          radius: 50,
          center: const Offset(150, 100),
        );

        expect(clipper1.shouldReclip(clipper2), isTrue);
      });

      test('returns true when center.y changes', () {
        final clipper1 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        final clipper2 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 150),
        );

        expect(clipper1.shouldReclip(clipper2), isTrue);
      });

      test('returns true when both radius and center change', () {
        final clipper1 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        final clipper2 = CircleMaskClipper(
          radius: 100,
          center: const Offset(200, 200),
        );

        expect(clipper1.shouldReclip(clipper2), isTrue);
      });

      test('handles comparison with very small radius differences', () {
        final clipper1 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        final clipper2 = CircleMaskClipper(
          radius: 50.001,
          center: const Offset(100, 100),
        );

        // Even tiny differences should trigger reclip
        expect(clipper1.shouldReclip(clipper2), isTrue);
      });

      test('handles comparison with very small center differences', () {
        final clipper1 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100, 100),
        );
        final clipper2 = CircleMaskClipper(
          radius: 50,
          center: const Offset(100.001, 100),
        );

        // Even tiny differences should trigger reclip
        expect(clipper1.shouldReclip(clipper2), isTrue);
      });
    });

    group('edge cases', () {
      test('handles very small radius', () {
        final clipper = CircleMaskClipper(
          radius: 0.001,
          center: const Offset(100, 100),
        );
        final path = clipper.getClip(const Size(200, 200));

        expect(path, isNotNull);
        expect(path.getBounds().width, closeTo(0.002, 0.001));
      });

      test('handles very large center coordinates', () {
        final clipper = CircleMaskClipper(
          radius: 50,
          center: const Offset(10000, 10000),
        );
        final path = clipper.getClip(const Size(200, 200));
        final bounds = path.getBounds();

        expect(bounds.center.dx, equals(10000));
        expect(bounds.center.dy, equals(10000));
      });

      test('handles infinity radius gracefully', () {
        final clipper = CircleMaskClipper(
          radius: double.infinity,
          center: const Offset(100, 100),
        );
        final path = clipper.getClip(const Size(200, 200));

        expect(path, isNotNull);
      });
    });
  });
}
