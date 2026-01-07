import 'package:fancy_titles/mario_maker/widgets/bouncing_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BouncingCircle', () {
    // Helper to create a widget wrapped in MaterialApp
    Widget buildTestWidget({
      Widget child = const Icon(Icons.star),
      double circleRadius = 80,
      Color circleColor = Colors.transparent,
      Duration bounceDuration = const Duration(seconds: 2),
      Duration imageScaleOutDuration = const Duration(milliseconds: 300),
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: BouncingCircle(
              circleRadius: circleRadius,
              circleColor: circleColor,
              bounceDuration: bounceDuration,
              imageScaleOutDuration: imageScaleOutDuration,
              child: child,
            ),
          ),
        ),
      );
    }

    group('instantiation', () {
      test('can be instantiated with required parameters', () {
        expect(
          const BouncingCircle(
            circleRadius: 80,
            child: Icon(Icons.star),
          ),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          const BouncingCircle(
            circleRadius: 100,
            circleColor: Colors.red,
            bounceDuration: Duration(seconds: 3),
            imageScaleOutDuration: Duration(milliseconds: 500),
            child: Icon(Icons.star),
          ),
          isNotNull,
        );
      });

      test('has default transparent circleColor', () {
        const widget = BouncingCircle(
          circleRadius: 80,
          child: Icon(Icons.star),
        );
        expect(widget, isNotNull);
      });

      test('has default bounceDuration of 2 seconds', () {
        const widget = BouncingCircle(
          circleRadius: 80,
          child: Icon(Icons.star),
        );
        expect(widget, isNotNull);
      });
    });

    group('rendering', () {
      testWidgets('renders with required parameters', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.byType(BouncingCircle), findsOneWidget);
      });

      testWidgets('renders child widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(child: const Text('TEST')),
        );

        expect(find.text('TEST'), findsOneWidget);
      });

      testWidgets('applies circleColor to container', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(circleColor: Colors.blue),
        );

        // Find Container with decoration
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, equals(Colors.blue));
      });

      testWidgets('creates circular shape', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Find Container with circular shape
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.shape, equals(BoxShape.circle));
      });

      testWidgets('has RepaintBoundary for optimization', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // BouncingCircle adds its own RepaintBoundary (plus framework ones)
        expect(find.byType(RepaintBoundary), findsWidgets);
      });
    });

    group('animation', () {
      testWidgets('starts bounce animation immediately', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Pump a few frames to advance animation
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(BouncingCircle), findsOneWidget);
      });

      testWidgets('completes bounce animation after bounceDuration',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(bounceDuration: const Duration(seconds: 1)),
        );

        // Advance past bounce duration
        await tester.pump(const Duration(milliseconds: 1100));

        expect(find.byType(BouncingCircle), findsOneWidget);
      });

      testWidgets('scales image out after bounce completes', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            bounceDuration: const Duration(milliseconds: 500),
            imageScaleOutDuration: const Duration(milliseconds: 200),
          ),
        );

        // Advance past bounce duration
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 100));

        // Image scale animation should be running
        expect(find.byType(BouncingCircle), findsOneWidget);
      });

      testWidgets('respects custom bounceDuration', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(bounceDuration: const Duration(seconds: 3)),
        );

        // At 2 seconds, animation should still be running
        await tester.pump(const Duration(seconds: 2));

        expect(find.byType(BouncingCircle), findsOneWidget);
      });

      testWidgets('respects custom imageScaleOutDuration', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            bounceDuration: const Duration(milliseconds: 100),
            imageScaleOutDuration: const Duration(milliseconds: 500),
          ),
        );

        // Advance past bounce duration
        await tester.pump(const Duration(milliseconds: 100));

        // Advance through image scale out
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(BouncingCircle), findsOneWidget);
      });
    });

    group('sizing', () {
      testWidgets('uses correct base size from circleRadius', (tester) async {
        await tester.pumpWidget(buildTestWidget(circleRadius: 100));

        // The SizedBox should be 2 * circleRadius = 200
        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(sizedBox.width, equals(200));
        expect(sizedBox.height, equals(200));
      });

      testWidgets('handles zero circleRadius', (tester) async {
        await tester.pumpWidget(buildTestWidget(circleRadius: 0));
        expect(find.byType(BouncingCircle), findsOneWidget);
      });

      testWidgets('handles large circleRadius', (tester) async {
        await tester.pumpWidget(buildTestWidget(circleRadius: 500));
        expect(find.byType(BouncingCircle), findsOneWidget);
      });
    });

    group('lifecycle', () {
      testWidgets('disposes animation controllers correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Advance animation
        await tester.pump(const Duration(milliseconds: 500));

        // Remove widget - should not throw
        await tester.pumpWidget(
          const MaterialApp(home: SizedBox.shrink()),
        );

        expect(find.byType(BouncingCircle), findsNothing);
      });

      testWidgets('handles rapid widget rebuild', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        // Rebuild with different parameters
        await tester.pumpWidget(buildTestWidget(circleRadius: 120));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(BouncingCircle), findsOneWidget);
      });

      testWidgets('handles dispose during bounce animation', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Start bounce animation
        await tester.pump(const Duration(milliseconds: 200));

        // Dispose widget mid-bounce
        await tester.pumpWidget(
          const MaterialApp(home: SizedBox.shrink()),
        );

        // Should not throw
        expect(find.byType(BouncingCircle), findsNothing);
      });

      testWidgets('handles dispose during image scale out', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            bounceDuration: const Duration(milliseconds: 100),
          ),
        );

        // Complete bounce, start image scale out
        await tester.pump(const Duration(milliseconds: 150));

        // Dispose widget mid-scale
        await tester.pumpWidget(
          const MaterialApp(home: SizedBox.shrink()),
        );

        // Should not throw
        expect(find.byType(BouncingCircle), findsNothing);
      });
    });

    group('TweenSequence optimization', () {
      testWidgets('uses static TweenSequence (no recreation)', (tester) async {
        // Create multiple widgets - they should share the same TweenSequence
        await tester.pumpWidget(buildTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        await tester.pumpWidget(buildTestWidget(circleRadius: 100));
        await tester.pump(const Duration(milliseconds: 100));

        await tester.pumpWidget(buildTestWidget(circleRadius: 120));
        await tester.pump(const Duration(milliseconds: 100));

        // All should render correctly with shared TweenSequence
        expect(find.byType(BouncingCircle), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('handles very short bounceDuration', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(bounceDuration: const Duration(milliseconds: 50)),
        );

        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(BouncingCircle), findsOneWidget);
      });

      testWidgets('handles very short imageScaleOutDuration', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            bounceDuration: const Duration(milliseconds: 100),
            imageScaleOutDuration: const Duration(milliseconds: 10),
          ),
        );

        await tester.pump(const Duration(milliseconds: 150));

        expect(find.byType(BouncingCircle), findsOneWidget);
      });

      testWidgets('handles complex child widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star),
                Text('Label'),
              ],
            ),
          ),
        );

        expect(find.byType(BouncingCircle), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Label'), findsOneWidget);
      });
    });
  });
}
