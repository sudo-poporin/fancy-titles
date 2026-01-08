import 'dart:ui' as ui;

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/evangelion/widgets/cached_blur_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CachedBlurWidget', () {
    /// Helper to dispose widget and settle all animations
    Future<void> disposeAndSettle(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(EvangelionTiming.totalDuration);
    }

    group('instantiation', () {
      testWidgets('can be instantiated with required parameters', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(color: Colors.red),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with custom sigma values', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(200, 150),
              sigmaX: 20,
              sigmaY: 15,
              child: Container(color: Colors.blue),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with zero sigma values', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaX: 0,
              sigmaY: 0,
              child: Container(color: Colors.green),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('default values', () {
      testWidgets('uses default sigma of 10 for both X and Y', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(),
            ),
          ),
        );

        final widget = tester.widget<CachedBlurWidget>(
          find.byType(CachedBlurWidget),
        );
        expect(widget.sigmaX, equals(10));
        expect(widget.sigmaY, equals(10));
        await disposeAndSettle(tester);
      });

      testWidgets('stores size correctly', (tester) async {
        const size = Size(250, 175);
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: size,
              child: Container(),
            ),
          ),
        );

        final widget = tester.widget<CachedBlurWidget>(
          find.byType(CachedBlurWidget),
        );
        expect(widget.size, equals(size));
        await disposeAndSettle(tester);
      });
    });

    group('renders child', () {
      testWidgets('renders the provided child widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(
                key: const Key('test-child'),
                color: Colors.purple,
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('test-child')), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('wraps child in ImageFiltered initially', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(color: Colors.red),
            ),
          ),
        );

        expect(find.byType(ImageFiltered), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('contains RepaintBoundary initially', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(),
            ),
          ),
        );

        // Find RepaintBoundary within CachedBlurWidget
        expect(
          find.descendant(
            of: find.byType(CachedBlurWidget),
            matching: find.byType(RepaintBoundary),
          ),
          findsOneWidget,
        );
        await disposeAndSettle(tester);
      });

      testWidgets('renders SizedBox with correct dimensions', (tester) async {
        const size = Size(150, 200);
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: size,
              child: Container(),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.descendant(
            of: find.byType(CachedBlurWidget),
            matching: find.byType(SizedBox),
          ),
        );
        expect(sizedBox.width, equals(size.width));
        expect(sizedBox.height, equals(size.height));
        await disposeAndSettle(tester);
      });
    });

    group('ImageFilter configuration', () {
      testWidgets('applies blur with custom sigmaX', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaX: 25,
              child: Container(),
            ),
          ),
        );

        final imageFiltered = tester.widget<ImageFiltered>(
          find.byType(ImageFiltered),
        );
        expect(imageFiltered.imageFilter, isA<ui.ImageFilter>());
        await disposeAndSettle(tester);
      });

      testWidgets('applies blur with custom sigmaY', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaY: 30,
              child: Container(),
            ),
          ),
        );

        final imageFiltered = tester.widget<ImageFiltered>(
          find.byType(ImageFiltered),
        );
        expect(imageFiltered.imageFilter, isA<ui.ImageFilter>());
        await disposeAndSettle(tester);
      });
    });

    group('didUpdateWidget', () {
      testWidgets('handles size change', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);

        // Update with new size
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(200, 200),
              child: Container(),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles sigmaX change', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaX: 5,
              child: Container(),
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaX: 20,
              child: Container(),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles sigmaY change', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaY: 5,
              child: Container(),
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaY: 25,
              child: Container(),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('no change when parameters are the same', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaX: 15,
              sigmaY: 15,
              child: Container(),
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaX: 15,
              sigmaY: 15,
              child: Container(),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('disposal', () {
      testWidgets('disposes without errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes after frame callback', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(),
            ),
          ),
        );

        // Allow post-frame callback to execute
        await tester.pump(const Duration(milliseconds: 20));

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes after multiple pumps', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(),
            ),
          ),
        );

        // Multiple pumps to simulate real rendering
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('handles immediate disposal gracefully', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              child: Container(),
            ),
          ),
        );

        // Immediate disposal without any pump
        await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
        await tester.pump(EvangelionTiming.totalDuration);

        expect(tester.takeException(), isNull);
      });
    });

    group('complex children', () {
      testWidgets('handles nested widgets as child', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(200, 200),
              child: Column(
                children: [
                  Container(color: Colors.red, height: 50),
                  Container(color: Colors.green, height: 50),
                  Container(color: Colors.blue, height: 50),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles Text as child', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurWidget(
              size: Size(200, 100),
              child: Center(
                child: Text('Blurred Text'),
              ),
            ),
          ),
        );

        expect(find.text('Blurred Text'), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles Icon as child', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurWidget(
              size: Size(100, 100),
              child: Icon(Icons.star, size: 50),
            ),
          ),
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('edge cases', () {
      testWidgets('handles very small size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(1, 1),
              child: Container(color: Colors.red),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles very large size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(1000, 1000),
              child: Container(color: Colors.red),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles very high sigma values', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaX: 100,
              sigmaY: 100,
              child: Container(),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles asymmetric size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(300, 50),
              child: Container(color: Colors.orange),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles asymmetric sigma values', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurWidget(
              size: const Size(100, 100),
              sigmaX: 5,
              sigmaY: 50,
              child: Container(),
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('multiple instances', () {
      testWidgets('can render multiple instances', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: [
                CachedBlurWidget(
                  size: const Size(100, 50),
                  child: Container(color: Colors.red),
                ),
                CachedBlurWidget(
                  size: const Size(100, 50),
                  child: Container(color: Colors.green),
                ),
                CachedBlurWidget(
                  size: const Size(100, 50),
                  child: Container(color: Colors.blue),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsNWidgets(3));
        await disposeAndSettle(tester);
      });

      testWidgets('multiple instances with different sizes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: [
                CachedBlurWidget(
                  size: const Size(50, 50),
                  sigmaX: 5,
                  child: Container(color: Colors.red),
                ),
                CachedBlurWidget(
                  size: const Size(100, 100),
                  sigmaX: 15,
                  child: Container(color: Colors.green),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(CachedBlurWidget), findsNWidgets(2));
        await disposeAndSettle(tester);
      });
    });
  });
}
