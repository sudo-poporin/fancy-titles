import 'package:fancy_titles/mario_maker/clippers/circle_mask_clipper.dart';
import 'package:fancy_titles/sonic_mania/clippers/bar_clipper.dart';
import 'package:fancy_titles/sonic_mania/clippers/curtain_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sonic Mania Bar Clippers - Path Caching', () {
    const testSize = Size(400, 100);
    const differentSize = Size(800, 200);

    setUp(() {
      // Reset all caches before each test
      OrangeBarClipper.debugResetCache();
      GreenBarClipper.debugResetCache();
      RedBarClipper.debugResetCache();
      BlueBarClipper.debugResetCache();
    });

    test('OrangeBarClipper caches path on repeated getClip calls', () {
      final clipper = OrangeBarClipper();

      // First call - creates path
      expect(OrangeBarClipper.debugCachedPath, isNull);
      final path1 = clipper.getClip(testSize);
      expect(OrangeBarClipper.debugCachedPath, isNotNull);

      // Second call with same size - should return cached path
      final path2 = clipper.getClip(testSize);

      // Should be the same cached path
      expect(identical(path1, path2), isTrue);
    });

    test('OrangeBarClipper creates new path for different sizes', () {
      final clipper = OrangeBarClipper();

      final pathSmall = clipper.getClip(testSize);
      final pathLarge = clipper.getClip(differentSize);

      expect(identical(pathSmall, pathLarge), isFalse);
      expect(OrangeBarClipper.debugCachedSize, equals(differentSize));
    });

    test('OrangeBarClipper shouldReclip returns false', () {
      final clipper = OrangeBarClipper();
      expect(clipper.shouldReclip(clipper), isFalse);
    });

    test('GreenBarClipper caches path correctly', () {
      final clipper = GreenBarClipper();

      final path1 = clipper.getClip(testSize);
      final path2 = clipper.getClip(testSize);

      expect(identical(path1, path2), isTrue);
    });

    test('RedBarClipper caches path correctly', () {
      final clipper = RedBarClipper();

      final path1 = clipper.getClip(testSize);
      final path2 = clipper.getClip(testSize);

      expect(identical(path1, path2), isTrue);
    });

    test('BlueBarClipper caches path correctly', () {
      final clipper = BlueBarClipper();

      final path1 = clipper.getClip(testSize);
      final path2 = clipper.getClip(testSize);

      expect(identical(path1, path2), isTrue);
    });

    test('All bar clippers return false for shouldReclip', () {
      expect(OrangeBarClipper().shouldReclip(OrangeBarClipper()), isFalse);
      expect(GreenBarClipper().shouldReclip(GreenBarClipper()), isFalse);
      expect(RedBarClipper().shouldReclip(RedBarClipper()), isFalse);
      expect(BlueBarClipper().shouldReclip(BlueBarClipper()), isFalse);
    });
  });

  group('Sonic Mania Curtain Clippers - Path Caching', () {
    const testSize = Size(400, 300);
    const differentSize = Size(800, 600);

    setUp(() {
      LeftCurtainClipper.debugResetCache();
      RightCurtainClipper.debugResetCache();
    });

    test('LeftCurtainClipper caches path on repeated getClip calls', () {
      final clipper = LeftCurtainClipper();

      final path1 = clipper.getClip(testSize);
      expect(LeftCurtainClipper.debugCachedPath, isNotNull);

      final path2 = clipper.getClip(testSize);

      expect(identical(path1, path2), isTrue);
    });

    test('LeftCurtainClipper creates new path for different sizes', () {
      final clipper = LeftCurtainClipper();

      final pathSmall = clipper.getClip(testSize);
      final pathLarge = clipper.getClip(differentSize);

      expect(identical(pathSmall, pathLarge), isFalse);
    });

    test('RightCurtainClipper caches path correctly', () {
      final clipper = RightCurtainClipper();

      final path1 = clipper.getClip(testSize);
      final path2 = clipper.getClip(testSize);

      expect(identical(path1, path2), isTrue);
    });

    test('RightCurtainClipper creates new path for different sizes', () {
      final clipper = RightCurtainClipper();

      final pathSmall = clipper.getClip(testSize);
      final pathLarge = clipper.getClip(differentSize);

      expect(identical(pathSmall, pathLarge), isFalse);
    });

    test('Curtain clippers return false for shouldReclip', () {
      expect(LeftCurtainClipper().shouldReclip(LeftCurtainClipper()), isFalse);
      expect(
        RightCurtainClipper().shouldReclip(RightCurtainClipper()),
        isFalse,
      );
    });
  });

  group('Mario Maker CircleMaskClipper - Path Caching', () {
    const testCenter = Offset(200, 150);
    const differentCenter = Offset(400, 300);
    const testRadius = 100.0;
    const differentRadius = 200.0;

    setUp(CircleMaskClipper.debugResetCache);

    test('CircleMaskClipper caches path on repeated getClip calls', () {
      final clipper = CircleMaskClipper(
        radius: testRadius,
        center: testCenter,
      );

      final path1 = clipper.getClip(const Size(400, 300));
      expect(CircleMaskClipper.debugCachedPath, isNotNull);
      expect(CircleMaskClipper.debugCachedRadius, equals(testRadius));
      expect(CircleMaskClipper.debugCachedCenter, equals(testCenter));

      final path2 = clipper.getClip(const Size(400, 300));

      expect(identical(path1, path2), isTrue);
    });

    test('CircleMaskClipper creates new path for different radius', () {
      final clipper1 = CircleMaskClipper(
        radius: testRadius,
        center: testCenter,
      );
      final clipper2 = CircleMaskClipper(
        radius: differentRadius,
        center: testCenter,
      );

      final path1 = clipper1.getClip(const Size(400, 300));
      final path2 = clipper2.getClip(const Size(400, 300));

      expect(identical(path1, path2), isFalse);
      expect(CircleMaskClipper.debugCachedRadius, equals(differentRadius));
    });

    test('CircleMaskClipper creates new path for different center', () {
      final clipper1 = CircleMaskClipper(
        radius: testRadius,
        center: testCenter,
      );
      final clipper2 = CircleMaskClipper(
        radius: testRadius,
        center: differentCenter,
      );

      final path1 = clipper1.getClip(const Size(400, 300));
      final path2 = clipper2.getClip(const Size(400, 300));

      expect(identical(path1, path2), isFalse);
      expect(CircleMaskClipper.debugCachedCenter, equals(differentCenter));
    });

    test(
      'CircleMaskClipper shouldReclip returns true for different params',
      () {
        final clipper1 = CircleMaskClipper(
          radius: testRadius,
          center: testCenter,
        );
        final clipper2 = CircleMaskClipper(
          radius: differentRadius,
          center: testCenter,
        );
        final clipper3 = CircleMaskClipper(
          radius: testRadius,
          center: differentCenter,
        );

        expect(clipper1.shouldReclip(clipper1), isFalse);
        expect(clipper1.shouldReclip(clipper2), isTrue);
        expect(clipper1.shouldReclip(clipper3), isTrue);
      },
    );
  });

  group('Cache Invalidation Tests', () {
    const testSize = Size(400, 100);

    test('debugResetCache clears all cached data for bar clippers', () {
      OrangeBarClipper().getClip(testSize);
      expect(OrangeBarClipper.debugCachedPath, isNotNull);
      expect(OrangeBarClipper.debugCachedSize, isNotNull);

      OrangeBarClipper.debugResetCache();

      expect(OrangeBarClipper.debugCachedPath, isNull);
      expect(OrangeBarClipper.debugCachedSize, isNull);
    });

    test('debugResetCache clears all cached data for curtain clippers', () {
      LeftCurtainClipper().getClip(testSize);
      expect(LeftCurtainClipper.debugCachedPath, isNotNull);
      expect(LeftCurtainClipper.debugCachedSize, isNotNull);

      LeftCurtainClipper.debugResetCache();

      expect(LeftCurtainClipper.debugCachedPath, isNull);
      expect(LeftCurtainClipper.debugCachedSize, isNull);
    });

    test('debugResetCache clears all cached data for CircleMaskClipper', () {
      CircleMaskClipper(
        radius: 100,
        center: const Offset(200, 150),
      ).getClip(testSize);
      expect(CircleMaskClipper.debugCachedPath, isNotNull);
      expect(CircleMaskClipper.debugCachedRadius, isNotNull);
      expect(CircleMaskClipper.debugCachedCenter, isNotNull);

      CircleMaskClipper.debugResetCache();

      expect(CircleMaskClipper.debugCachedPath, isNull);
      expect(CircleMaskClipper.debugCachedRadius, isNull);
      expect(CircleMaskClipper.debugCachedCenter, isNull);
    });
  });

  group('Multiple getClip Calls Performance Simulation', () {
    const testSize = Size(400, 100);

    setUp(OrangeBarClipper.debugResetCache);

    test('Path is only created once for 100 getClip calls with same size', () {
      final clipper = OrangeBarClipper();

      // First call creates the path
      final originalPath = clipper.getClip(testSize);

      // Simulate 99 more getClip calls (like during animation)
      for (var i = 0; i < 99; i++) {
        final path = clipper.getClip(testSize);
        expect(identical(originalPath, path), isTrue);
      }

      // Path should still be the exact same object
      expect(
        identical(originalPath, OrangeBarClipper.debugCachedPath),
        isTrue,
      );
    });

    test(
      'CircleMaskClipper path is reused for 100 calls with same parameters',
      () {
        CircleMaskClipper.debugResetCache();

        final clipper = CircleMaskClipper(
          radius: 100,
          center: const Offset(200, 150),
        );

        final originalPath = clipper.getClip(testSize);

        for (var i = 0; i < 99; i++) {
          final path = clipper.getClip(testSize);
          expect(identical(originalPath, path), isTrue);
        }

        expect(
          identical(originalPath, CircleMaskClipper.debugCachedPath),
          isTrue,
        );
      },
    );
  });
}
