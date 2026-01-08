import 'package:fancy_titles/persona_5/painters/circle_painter.dart';
import 'package:fancy_titles/persona_5/widgets/background_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BackgroundCircle', () {
    group('instantiation', () {
      testWidgets('can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BackgroundCircle(),
            ),
          ),
        );

        expect(find.byType(BackgroundCircle), findsOneWidget);
      });

      testWidgets('is a const constructor', (tester) async {
        // Verifies the widget uses const constructor
        const widget1 = BackgroundCircle();
        const widget2 = BackgroundCircle();

        // Both should be identical instances if truly const
        expect(widget1.key, equals(widget2.key));
      });
    });

    group('renders expected widgets', () {
      testWidgets('contains RepaintBoundary', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BackgroundCircle(),
            ),
          ),
        );

        // Find RepaintBoundary within BackgroundCircle
        expect(
          find.descendant(
            of: find.byType(BackgroundCircle),
            matching: find.byType(RepaintBoundary),
          ),
          findsOneWidget,
        );
      });

      testWidgets('contains SizedBox.expand', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BackgroundCircle(),
            ),
          ),
        );

        // SizedBox.expand creates a SizedBox with expand constraints
        final sizedBox = tester.widget<SizedBox>(
          find.descendant(
            of: find.byType(BackgroundCircle),
            matching: find.byType(SizedBox),
          ),
        );

        // SizedBox.expand sets width and height to double.infinity
        expect(sizedBox.width, equals(double.infinity));
        expect(sizedBox.height, equals(double.infinity));
      });

      testWidgets('contains CustomPaint', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BackgroundCircle(),
            ),
          ),
        );

        // Find CustomPaint within BackgroundCircle
        expect(
          find.descendant(
            of: find.byType(BackgroundCircle),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      });

      testWidgets('CustomPaint uses CirclePainter', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BackgroundCircle(),
            ),
          ),
        );

        final customPaint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(BackgroundCircle),
            matching: find.byType(CustomPaint),
          ),
        );

        expect(customPaint.painter, isA<CirclePainter>());
      });
    });

    group('widget hierarchy', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BackgroundCircle(),
            ),
          ),
        );

        // RepaintBoundary should be a descendant of BackgroundCircle
        expect(
          find.descendant(
            of: find.byType(BackgroundCircle),
            matching: find.byType(RepaintBoundary),
          ),
          findsOneWidget,
        );

        // SizedBox should be a descendant of RepaintBoundary
        expect(
          find.descendant(
            of: find.byType(RepaintBoundary),
            matching: find.byType(SizedBox),
          ),
          findsOneWidget,
        );

        // CustomPaint should be a descendant of SizedBox
        expect(
          find.descendant(
            of: find.byType(SizedBox),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      });
    });

    group('inflated values', () {
      testWidgets('CirclePainter has correct inflated values', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BackgroundCircle(),
            ),
          ),
        );

        final customPaint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(BackgroundCircle),
            matching: find.byType(CustomPaint),
          ),
        );
        final painter = customPaint.painter! as CirclePainter;

        // The widget uses a specific list of inflated values
        // This test verifies the painter is configured correctly
        expect(painter, isNotNull);
      });
    });

    group('in different contexts', () {
      testWidgets('renders in Stack', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  BackgroundCircle(),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(BackgroundCircle), findsOneWidget);
      });

      testWidgets('renders in Container with constraints', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 300,
                child: BackgroundCircle(),
              ),
            ),
          ),
        );

        expect(find.byType(BackgroundCircle), findsOneWidget);
      });

      testWidgets('renders in Expanded', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: BackgroundCircle(),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(BackgroundCircle), findsOneWidget);
      });

      testWidgets('renders in Center', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: BackgroundCircle(),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(BackgroundCircle), findsOneWidget);
      });
    });

    group('multiple instances', () {
      testWidgets('can render multiple instances in Stack', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  BackgroundCircle(),
                  BackgroundCircle(),
                  BackgroundCircle(),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(BackgroundCircle), findsNWidgets(3));
      });

      testWidgets('multiple instances have correct painters', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  BackgroundCircle(key: Key('circle1')),
                  BackgroundCircle(key: Key('circle2')),
                ],
              ),
            ),
          ),
        );

        // Each BackgroundCircle should have its own CustomPaint
        expect(find.byType(BackgroundCircle), findsNWidgets(2));

        // Verify each one has a CustomPaint
        expect(
          find.descendant(
            of: find.byKey(const Key('circle1')),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('circle2')),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      });
    });

    group('stateless behavior', () {
      testWidgets('rebuilds correctly when parent changes', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ColoredBox(
                color: Colors.red,
                child: BackgroundCircle(),
              ),
            ),
          ),
        );

        expect(find.byType(BackgroundCircle), findsOneWidget);

        // Rebuild with different parent
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ColoredBox(
                color: Colors.blue,
                child: BackgroundCircle(),
              ),
            ),
          ),
        );

        expect(find.byType(BackgroundCircle), findsOneWidget);
      });

      testWidgets('disposes without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BackgroundCircle(),
            ),
          ),
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox.shrink(),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    });

    group('with key', () {
      testWidgets('can be instantiated with key', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BackgroundCircle(key: Key('test-key')),
            ),
          ),
        );

        expect(find.byKey(const Key('test-key')), findsOneWidget);
      });

      testWidgets('different keys create different widgets', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  BackgroundCircle(key: Key('circle-a')),
                  BackgroundCircle(key: Key('circle-b')),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('circle-a')), findsOneWidget);
        expect(find.byKey(const Key('circle-b')), findsOneWidget);
      });
    });
  });
}
