import 'dart:ui';

import 'package:fancy_titles/sonic_mania/clippers/clippers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrangeBarClipper', () {
    test('creates path with correct size', () {
      final clipper = OrangeBarClipper();
      final path = clipper.getClip(const Size(200, 100));

      expect(path, isA<Path>());
      expect(path.getBounds(), isNotNull);
    });

    test('path has non-zero dimensions', () {
      final clipper = OrangeBarClipper();
      final path = clipper.getClip(const Size(200, 100));
      final bounds = path.getBounds();

      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('shouldReclip returns false', () {
      final clipper1 = OrangeBarClipper();
      final clipper2 = OrangeBarClipper();

      expect(clipper1.shouldReclip(clipper2), isFalse);
    });

    test('path starts at correct position', () {
      final clipper = OrangeBarClipper();
      final path = clipper.getClip(const Size(100, 100));
      final bounds = path.getBounds();

      // Path should be within the size bounds
      expect(bounds.left, greaterThanOrEqualTo(0));
      expect(bounds.top, greaterThanOrEqualTo(0));
    });
  });

  group('GreenBarClipper', () {
    test('creates path with correct size', () {
      final clipper = GreenBarClipper();
      final path = clipper.getClip(const Size(200, 100));

      expect(path, isA<Path>());
      expect(path.getBounds(), isNotNull);
    });

    test('path has non-zero dimensions', () {
      final clipper = GreenBarClipper();
      final path = clipper.getClip(const Size(200, 100));
      final bounds = path.getBounds();

      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('shouldReclip returns false', () {
      final clipper1 = GreenBarClipper();
      final clipper2 = GreenBarClipper();

      expect(clipper1.shouldReclip(clipper2), isFalse);
    });

    test('path creates diagonal bar shape', () {
      final clipper = GreenBarClipper();
      final path = clipper.getClip(const Size(100, 50));
      final bounds = path.getBounds();

      // Green bar is positioned more to the right
      expect(bounds.right, lessThanOrEqualTo(100));
      expect(bounds.bottom, lessThanOrEqualTo(50));
    });
  });

  group('RedBarClipper', () {
    test('creates path with correct size', () {
      final clipper = RedBarClipper();
      final path = clipper.getClip(const Size(200, 100));

      expect(path, isA<Path>());
      expect(path.getBounds(), isNotNull);
    });

    test('path has non-zero dimensions', () {
      final clipper = RedBarClipper();
      final path = clipper.getClip(const Size(200, 100));
      final bounds = path.getBounds();

      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('shouldReclip returns false', () {
      final clipper1 = RedBarClipper();
      final clipper2 = RedBarClipper();

      expect(clipper1.shouldReclip(clipper2), isFalse);
    });

    test('path is within bounds', () {
      final clipper = RedBarClipper();
      final path = clipper.getClip(const Size(100, 100));
      final bounds = path.getBounds();

      expect(bounds.left, greaterThanOrEqualTo(0));
      expect(bounds.right, lessThanOrEqualTo(100));
    });
  });

  group('BlueBarClipper', () {
    test('creates path with correct size', () {
      final clipper = BlueBarClipper();
      final path = clipper.getClip(const Size(200, 100));

      expect(path, isA<Path>());
      expect(path.getBounds(), isNotNull);
    });

    test('path has non-zero dimensions', () {
      final clipper = BlueBarClipper();
      final path = clipper.getClip(const Size(200, 100));
      final bounds = path.getBounds();

      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('shouldReclip returns false', () {
      final clipper1 = BlueBarClipper();
      final clipper2 = BlueBarClipper();

      expect(clipper1.shouldReclip(clipper2), isFalse);
    });

    test('blue bar covers full height', () {
      final clipper = BlueBarClipper();
      final path = clipper.getClip(const Size(100, 100));
      final bounds = path.getBounds();

      // Blue bar starts at y=0 and goes to bottom
      expect(bounds.top, equals(0));
      expect(bounds.bottom, equals(100));
    });
  });

  group('LeftCurtainClipper', () {
    test('creates path with correct size', () {
      final clipper = LeftCurtainClipper();
      final path = clipper.getClip(const Size(200, 100));

      expect(path, isA<Path>());
      expect(path.getBounds(), isNotNull);
    });

    test('path has non-zero dimensions', () {
      final clipper = LeftCurtainClipper();
      final path = clipper.getClip(const Size(200, 100));
      final bounds = path.getBounds();

      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('shouldReclip returns false', () {
      final clipper1 = LeftCurtainClipper();
      final clipper2 = LeftCurtainClipper();

      expect(clipper1.shouldReclip(clipper2), isFalse);
    });

    test('path starts from left edge', () {
      final clipper = LeftCurtainClipper();
      final path = clipper.getClip(const Size(100, 100));
      final bounds = path.getBounds();

      // Left curtain starts at x=0
      expect(bounds.left, equals(0));
    });

    test('path covers full height', () {
      final clipper = LeftCurtainClipper();
      final path = clipper.getClip(const Size(100, 100));
      final bounds = path.getBounds();

      expect(bounds.top, equals(0));
      expect(bounds.bottom, equals(100));
    });
  });

  group('RightCurtainClipper', () {
    test('creates path with correct size', () {
      final clipper = RightCurtainClipper();
      final path = clipper.getClip(const Size(200, 100));

      expect(path, isA<Path>());
      expect(path.getBounds(), isNotNull);
    });

    test('path has non-zero dimensions', () {
      final clipper = RightCurtainClipper();
      final path = clipper.getClip(const Size(200, 100));
      final bounds = path.getBounds();

      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('shouldReclip returns false', () {
      final clipper1 = RightCurtainClipper();
      final clipper2 = RightCurtainClipper();

      expect(clipper1.shouldReclip(clipper2), isFalse);
    });

    test('path ends at right edge', () {
      final clipper = RightCurtainClipper();
      final path = clipper.getClip(const Size(100, 100));
      final bounds = path.getBounds();

      // Right curtain extends to x=100
      expect(bounds.right, equals(100));
    });

    test('path covers full height', () {
      final clipper = RightCurtainClipper();
      final path = clipper.getClip(const Size(100, 100));
      final bounds = path.getBounds();

      expect(bounds.top, equals(0));
      expect(bounds.bottom, equals(100));
    });
  });

  group('Clippers comparison', () {
    test('all bar clippers create different paths', () {
      const size = Size(100, 100);
      final orangePath = OrangeBarClipper().getClip(size);
      final greenPath = GreenBarClipper().getClip(size);
      final redPath = RedBarClipper().getClip(size);
      final bluePath = BlueBarClipper().getClip(size);

      // Each clipper should create a unique path
      expect(orangePath.getBounds(), isNot(equals(greenPath.getBounds())));
      expect(orangePath.getBounds(), isNot(equals(redPath.getBounds())));
      expect(orangePath.getBounds(), isNot(equals(bluePath.getBounds())));
    });

    test('curtain clippers create different paths', () {
      const size = Size(100, 100);
      final leftPath = LeftCurtainClipper().getClip(size);
      final rightPath = RightCurtainClipper().getClip(size);

      // Left and right curtains should have different bounds
      expect(
        leftPath.getBounds().left,
        isNot(equals(rightPath.getBounds().left)),
      );
    });

    test('all clippers handle zero size gracefully', () {
      const zeroSize = Size.zero;

      expect(
        () => OrangeBarClipper().getClip(zeroSize),
        returnsNormally,
      );
      expect(
        () => GreenBarClipper().getClip(zeroSize),
        returnsNormally,
      );
      expect(
        () => RedBarClipper().getClip(zeroSize),
        returnsNormally,
      );
      expect(
        () => BlueBarClipper().getClip(zeroSize),
        returnsNormally,
      );
      expect(
        () => LeftCurtainClipper().getClip(zeroSize),
        returnsNormally,
      );
      expect(
        () => RightCurtainClipper().getClip(zeroSize),
        returnsNormally,
      );
    });

    test('all clippers handle large size', () {
      const largeSize = Size(10000, 10000);

      expect(
        () => OrangeBarClipper().getClip(largeSize),
        returnsNormally,
      );
      expect(
        () => GreenBarClipper().getClip(largeSize),
        returnsNormally,
      );
      expect(
        () => RedBarClipper().getClip(largeSize),
        returnsNormally,
      );
      expect(
        () => BlueBarClipper().getClip(largeSize),
        returnsNormally,
      );
      expect(
        () => LeftCurtainClipper().getClip(largeSize),
        returnsNormally,
      );
      expect(
        () => RightCurtainClipper().getClip(largeSize),
        returnsNormally,
      );
    });
  });
}
