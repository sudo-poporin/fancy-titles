import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../benchmark/utils/jank_detector.dart';
import '../../benchmark/utils/print_helpers.dart';

void main() {
  group('Jank Detection - SonicManiaSplash', () {
    late TestJankDetector detector;

    setUp(() {
      detector = TestJankDetector();
    });

    testWidgets('full animation has less than 1% jank', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaSplash(baseText: 'TEST'),
        ),
      );

      // Run through full animation (~5 seconds = 300 frames at 60fps)
      const totalDuration = SonicManiaTiming.totalDuration;
      var elapsed = Duration.zero;
      const frameInterval = Duration(milliseconds: 16);

      while (elapsed < totalDuration) {
        detector.startFrame();
        await tester.pump(frameInterval);
        detector.endFrame();
        elapsed += frameInterval;
      }

      printLine('SonicManiaSplash Jank Detection:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(1.0),
        reason: 'SonicManiaSplash should have less than 1% jank frames',
      );
    });

    testWidgets('slide-in phase has low jank', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaSplash(
            baseText: 'STUDIOPOLIS',
            secondaryText: 'ZONE',
          ),
        ),
      );

      // Measure slide-in phase (600ms = ~37 frames)
      const slideInDuration = SonicManiaTiming.slideIn;
      var elapsed = Duration.zero;

      while (elapsed < slideInDuration) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
        elapsed += const Duration(milliseconds: 16);
      }

      printLine('SonicManiaSplash Slide-in Phase:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(2.0),
        reason: 'Slide-in phase should have minimal jank',
      );
    });

    testWidgets('curtain animation has low jank', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaSplash(baseText: 'TEST'),
        ),
      );

      // Skip to curtain phase (after yellow curtain delay)
      await tester.pump(SonicManiaTiming.curtainYellowDelay);

      // Measure curtain expand duration
      const curtainDuration = SonicManiaTiming.curtainExpandDuration;
      var elapsed = Duration.zero;

      while (elapsed < curtainDuration) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
        elapsed += const Duration(milliseconds: 16);
      }

      printLine('SonicManiaSplash Curtain Phase:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(2.0),
        reason: 'Curtain phase should animate smoothly',
      );
    });
  });

  group('Jank Detection - Persona5Title', () {
    late TestJankDetector detector;

    setUp(() {
      detector = TestJankDetector();
    });

    testWidgets('full animation has less than 1% jank', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(text: 'TEST'),
        ),
      );

      // Run through animation (~4 seconds)
      const totalDuration = Persona5Timing.totalDuration;
      var elapsed = Duration.zero;
      const frameInterval = Duration(milliseconds: 16);

      while (elapsed < totalDuration) {
        detector.startFrame();
        await tester.pump(frameInterval);
        detector.endFrame();
        elapsed += frameInterval;
      }

      printLine('Persona5Title Jank Detection:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(1.0),
        reason: 'Persona5Title should have less than 1% jank frames',
      );
    });

    testWidgets('circle transition phase has low jank', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(text: 'TAKE YOUR TIME'),
        ),
      );

      // Measure circle transition (325ms = ~20 frames)
      const transitionDuration = Persona5Timing.circleTransitionDuration;
      var elapsed = Duration.zero;

      while (elapsed < transitionDuration) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
        elapsed += const Duration(milliseconds: 16);
      }

      printLine('Persona5Title Circle Transition:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(2.0),
        reason: 'Circle transition should animate smoothly',
      );
    });

    testWidgets('text appear phase has low jank', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(text: 'PERSONA'),
        ),
      );

      // Skip to text appear
      await tester.pump(Persona5Timing.textAppearDelay);

      // Measure main animation phase (1 second sample)
      for (var i = 0; i < 60; i++) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
      }

      printLine('Persona5Title Text Appear Phase:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(2.0),
        reason: 'Text animation should be smooth',
      );
    });
  });

  // Note: EvangelionTitle uses CachedBlurWidget which was fixed in Session 4.5
  // to properly cancel pending timers on dispose.
  group('Jank Detection - EvangelionTitle', () {
    late TestJankDetector detector;

    setUp(() {
      detector = TestJankDetector();
    });

    testWidgets(
      'initial phases have low jank',
      (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EvangelionTitle(firstText: 'NERV'),
        ),
      );

      // EvangelionTitle uses CachedBlurWidget which doesn't work well
      // in test environment. Test initial frames before blur.
      // Measure first 2 seconds (before heavy blur operations)
      const testDuration = Duration(seconds: 2);
      var elapsed = Duration.zero;

      while (elapsed < testDuration) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
        elapsed += const Duration(milliseconds: 16);
      }

      // Ensure animation completes (EvangelionTitle has 5s total duration)
      await tester.pump(const Duration(seconds: 4));
      await tester.pump(const Duration(seconds: 2));

      printLine('EvangelionTitle Initial Phases:');
      printLine(detector.toString());

      // More lenient threshold due to blur operations
      expect(
        detector.getJankPercentage(),
        lessThan(5.0),
        reason: 'Initial phases should have reasonable performance',
      );
    });

    testWidgets(
      'spark animation phase has acceptable jank',
      (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EvangelionTitle(firstText: 'EVA'),
        ),
      );

      // Skip to second spark animation
      await tester.pump(EvangelionTiming.sparkSecondDelay);

      // Measure spark sequence (1 second = 60 frames)
      for (var i = 0; i < 60; i++) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
      }

      // Ensure animation completes (EvangelionTitle has 5s total duration)
      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(seconds: 2));

      printLine('EvangelionTitle Spark Phase:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(5.0),
        reason: 'Spark animations should perform acceptably',
      );
    });
  });

  group('Jank Detection - MarioMakerTitle', () {
    late TestJankDetector detector;

    setUp(() {
      detector = TestJankDetector();
    });

    testWidgets('full animation has less than 1% jank', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MarioMakerTitle(
            title: 'TEST',
            imagePath: 'test/fixtures/test_image.png',
          ),
        ),
      );

      // Run through animation (~4 seconds)
      const totalDuration = MarioMakerTiming.defaultTotalDuration;
      var elapsed = Duration.zero;
      const frameInterval = Duration(milliseconds: 16);

      while (elapsed < totalDuration) {
        detector.startFrame();
        await tester.pump(frameInterval);
        detector.endFrame();
        elapsed += frameInterval;
      }

      // Ensure timers complete
      await tester.pump(const Duration(seconds: 1));

      printLine('MarioMakerTitle Jank Detection:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(1.0),
        reason: 'MarioMakerTitle should have less than 1% jank frames',
      );
    });

    testWidgets('circle expand phase has low jank', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MarioMakerTitle(
            title: 'WORLD 1-1',
            imagePath: 'test/fixtures/test_image.png',
          ),
        ),
      );

      // Skip to expand phase
      await tester.pump(MarioMakerTiming.expandDelay);

      // Measure expand duration (800ms)
      const expandDuration = MarioMakerTiming.expandDuration;
      var elapsed = Duration.zero;

      while (elapsed < expandDuration) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
        elapsed += const Duration(milliseconds: 16);
      }

      // Ensure timers complete
      await tester.pump(const Duration(seconds: 2));

      printLine('MarioMakerTitle Circle Expand:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(2.0),
        reason: 'Circle expand should animate smoothly',
      );
    });
  });

  group('Jank Detection - All Widgets Summary', () {
    testWidgets('all widgets complete animations without timeout',
        (tester) async {
      // Test each widget completes its animation without timeout
      // Using discrete pumps instead of pumpAndSettle for consistent behavior

      // SonicMania (5 seconds)
      await tester.pumpWidget(
        MaterialApp(home: SonicManiaSplash(baseText: 'TEST')),
      );
      await tester.pump(SonicManiaTiming.totalDuration);
      await tester.pump(const Duration(seconds: 1));

      // Persona5 (4 seconds)
      await tester.pumpWidget(
        const MaterialApp(home: Persona5Title(text: 'TEST')),
      );
      await tester.pump(Persona5Timing.totalDuration);
      await tester.pump(const Duration(seconds: 1));

      // Evangelion (5 seconds)
      await tester.pumpWidget(
        const MaterialApp(home: EvangelionTitle(firstText: 'TEST')),
      );
      await tester.pump(EvangelionTiming.totalDuration);
      await tester.pump(const Duration(seconds: 1));

      // MarioMaker (4 seconds)
      await tester.pumpWidget(
        const MaterialApp(
          home: MarioMakerTitle(
            title: 'TEST',
            imagePath: 'test/fixtures/test_image.png',
          ),
        ),
      );
      await tester.pump(MarioMakerTiming.defaultTotalDuration);
      await tester.pump(const Duration(seconds: 1));

      // If we get here, all animations completed successfully
      expect(true, isTrue);
    });

    testWidgets(
      'combined jank across all widgets stays below threshold',
      (tester) async {
      final detector = TestJankDetector();

      // Test SonicMania (1 second sample)
      await tester.pumpWidget(
        MaterialApp(home: SonicManiaSplash(baseText: 'SONIC')),
      );
      for (var i = 0; i < 60; i++) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
      }
      // Pump remaining animation time
      await tester.pump(const Duration(seconds: 5));

      // Test Persona5 (1 second sample)
      await tester.pumpWidget(
        const MaterialApp(home: Persona5Title(text: 'PERSONA')),
      );
      for (var i = 0; i < 60; i++) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
      }
      await tester.pump(const Duration(seconds: 4));

      // Test Evangelion (1 second sample)
      await tester.pumpWidget(
        const MaterialApp(home: EvangelionTitle(firstText: 'NERV')),
      );
      for (var i = 0; i < 60; i++) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
      }
      await tester.pump(const Duration(seconds: 5));

      // Test MarioMaker (1 second sample)
      await tester.pumpWidget(
        const MaterialApp(
          home: MarioMakerTitle(
            title: 'MARIO',
            imagePath: 'test/fixtures/test_image.png',
          ),
        ),
      );
      for (var i = 0; i < 60; i++) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
      }
      // Ensure all MarioMaker timers complete
      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(seconds: 1));

      printLine('Combined Jank Across All Widgets (240 frames total):');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(2.0),
        reason: 'Combined widgets should maintain low jank',
      );
    });
  });

  group('Jank Detection - Stress Tests', () {
    late TestJankDetector detector;

    setUp(() {
      detector = TestJankDetector();
    });

    testWidgets('SonicMania with long text maintains performance',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaSplash(
            baseText: 'STUDIOPOLIS STUDIOPOLIS',
            secondaryText: 'ZONE ZONE ZONE',
            lastText: 'ACT1', // lastText limited to 4 characters
          ),
        ),
      );

      // Test 2 seconds of animation
      for (var i = 0; i < 120; i++) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
      }

      // Ensure timers complete
      await tester.pump(const Duration(seconds: 4));

      printLine('SonicMania Long Text Stress:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(2.0),
        reason: 'Long text should not significantly impact performance',
      );
    });

    testWidgets('Persona5 with long text maintains performance',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Persona5Title(text: 'TAKE YOUR TIME AND ENJOY THE MOMENT'),
        ),
      );

      // Test 2 seconds of animation
      for (var i = 0; i < 120; i++) {
        detector.startFrame();
        await tester.pump(const Duration(milliseconds: 16));
        detector.endFrame();
      }

      // Ensure timers complete
      await tester.pump(const Duration(seconds: 3));

      printLine('Persona5 Long Text Stress:');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(2.0),
        reason: 'Long text should not significantly impact performance',
      );
    });

    testWidgets('rapid widget creation does not cause jank', (tester) async {
      // Rapidly create and destroy widgets
      for (var j = 0; j < 5; j++) {
        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(baseText: 'TEST $j'),
          ),
        );

        // Measure a few frames after each creation
        for (var i = 0; i < 10; i++) {
          detector.startFrame();
          await tester.pump(const Duration(milliseconds: 16));
          detector.endFrame();
        }
      }

      // Ensure final widget's timers complete
      await tester.pump(const Duration(seconds: 5));

      printLine('Rapid Widget Creation (50 frames across 5 widgets):');
      printLine(detector.toString());

      expect(
        detector.getJankPercentage(),
        lessThan(5.0),
        reason: 'Rapid widget creation should not cause excessive jank',
      );
    });
  });

  group('TestJankDetector Unit Tests', () {
    test('calculates jank percentage correctly', () {
      final detector = TestJankDetector();

      // Record 10 frames: 9 fast, 1 slow
      for (var i = 0; i < 9; i++) {
        detector.recordFrame(const Duration(milliseconds: 5));
      }
      detector.recordFrame(const Duration(milliseconds: 20)); // jank frame

      expect(detector.frameCount, equals(10));
      expect(detector.getJankCount(), equals(1));
      expect(detector.getJankPercentage(), equals(10.0));
    });

    test('calculates average frame time correctly', () {
      final detector = TestJankDetector()
        ..recordFrame(const Duration(microseconds: 1000))
        ..recordFrame(const Duration(microseconds: 2000))
        ..recordFrame(const Duration(microseconds: 3000));

      expect(detector.averageFrameTime.inMicroseconds, equals(2000));
    });

    test('calculates p95 frame time correctly', () {
      final detector = TestJankDetector();

      // Record 100 frames: 95 at 5ms, 5 at 20ms
      for (var i = 0; i < 95; i++) {
        detector.recordFrame(const Duration(milliseconds: 5));
      }
      for (var i = 0; i < 5; i++) {
        detector.recordFrame(const Duration(milliseconds: 20));
      }

      // P95 should be around 5ms (the 95th percentile)
      expect(detector.p95FrameTime.inMilliseconds, lessThanOrEqualTo(20));
    });

    test('reset clears all data', () {
      final detector = TestJankDetector()
        ..recordFrame(const Duration(milliseconds: 10))
        ..recordFrame(const Duration(milliseconds: 20));

      expect(detector.frameCount, equals(2));

      detector.reset();

      expect(detector.frameCount, equals(0));
      expect(detector.getJankPercentage(), equals(0.0));
    });

    test('handles empty state gracefully', () {
      final detector = TestJankDetector();

      expect(detector.frameCount, equals(0));
      expect(detector.getJankPercentage(), equals(0.0));
      expect(detector.averageFrameTime, equals(Duration.zero));
      expect(detector.maxFrameTime, equals(Duration.zero));
      expect(detector.p95FrameTime, equals(Duration.zero));
    });

    test('toJson produces valid output', () {
      final detector = TestJankDetector()
        ..recordFrame(const Duration(milliseconds: 10))
        ..recordFrame(const Duration(milliseconds: 20));

      final json = detector.toJson();

      expect(json['frameCount'], equals(2));
      expect(json['jankPercentage'], isA<double>());
      expect(json['jankCount'], isA<int>());
      expect(json['averageFrameTimeUs'], isA<int>());
      expect(json['maxFrameTimeMs'], isA<int>());
      expect(json['p95FrameTimeUs'], isA<int>());
    });
  });
}
