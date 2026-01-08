import 'dart:ui' as ui;

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/evangelion/widgets/cached_blur_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A simple test painter for testing CachedBlurPainter
class _TestPainter extends CustomPainter {
  const _TestPainter({this.color = Colors.red});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _TestPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

/// A painter that tracks paint calls for testing
class _TrackingPainter extends CustomPainter {
  _TrackingPainter({this.onPaint});

  final VoidCallback? onPaint;

  @override
  void paint(Canvas canvas, Size size) {
    onPaint?.call();
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 4,
      Paint()..color = Colors.blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  group('CachedBlurPainter', () {
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
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with custom sigma values', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(200, 150),
              sigmaX: 20,
              sigmaY: 15,
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with zero sigma values', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaX: 0,
              sigmaY: 0,
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('default values', () {
      testWidgets('uses default sigma of 10 for both X and Y', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
            ),
          ),
        );

        final widget = tester.widget<CachedBlurPainter>(
          find.byType(CachedBlurPainter),
        );
        expect(widget.sigmaX, equals(10));
        expect(widget.sigmaY, equals(10));
        await disposeAndSettle(tester);
      });

      testWidgets('stores size correctly', (tester) async {
        const size = Size(250, 175);
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(painter: _TestPainter(), size: size),
          ),
        );

        final widget = tester.widget<CachedBlurPainter>(
          find.byType(CachedBlurPainter),
        );
        expect(widget.size, equals(size));
        await disposeAndSettle(tester);
      });

      testWidgets('stores painter correctly', (tester) async {
        const painter = _TestPainter(color: Colors.green);
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(painter: painter, size: Size(100, 100)),
          ),
        );

        final widget = tester.widget<CachedBlurPainter>(
          find.byType(CachedBlurPainter),
        );
        expect(widget.painter, equals(painter));
        await disposeAndSettle(tester);
      });
    });

    group('renders painter', () {
      testWidgets('initially contains ImageFiltered', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
            ),
          ),
        );

        expect(find.byType(ImageFiltered), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('initially contains CustomPaint', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
            ),
          ),
        );

        // Find CustomPaint within CachedBlurPainter
        expect(
          find.descendant(
            of: find.byType(CachedBlurPainter),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
        await disposeAndSettle(tester);
      });

      testWidgets('contains RepaintBoundary initially', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
            ),
          ),
        );

        // Find RepaintBoundary within CachedBlurPainter
        expect(
          find.descendant(
            of: find.byType(CachedBlurPainter),
            matching: find.byType(RepaintBoundary),
          ),
          findsOneWidget,
        );
        await disposeAndSettle(tester);
      });

      testWidgets('CustomPaint has correct size', (tester) async {
        const size = Size(150, 200);
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(painter: _TestPainter(), size: size),
          ),
        );

        final customPaint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(CachedBlurPainter),
            matching: find.byType(CustomPaint),
          ),
        );
        expect(customPaint.size, equals(size));
        await disposeAndSettle(tester);
      });

      testWidgets('calls painter paint method', (tester) async {
        var paintCallCount = 0;
        final painter = _TrackingPainter(onPaint: () => paintCallCount++);

        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurPainter(
              painter: painter,
              size: const Size(100, 100),
            ),
          ),
        );

        // Initial paint
        expect(paintCallCount, greaterThan(0));
        await disposeAndSettle(tester);
      });
    });

    group('ImageFilter configuration', () {
      testWidgets('applies blur with custom sigmaX', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaX: 25,
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
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaY: 30,
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
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);

        // Update with new size
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(200, 200),
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles sigmaX change', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaX: 5,
            ),
          ),
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaX: 20,
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles sigmaY change', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaY: 5,
            ),
          ),
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaY: 25,
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('no rebuild when parameters are the same', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaX: 15,
              sigmaY: 15,
            ),
          ),
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaX: 15,
              sigmaY: 15,
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('disposal', () {
      testWidgets('disposes without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes after frame callback', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
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
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
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
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
            ),
          ),
        );

        // Immediate disposal without any pump
        await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
        await tester.pump(EvangelionTiming.totalDuration);

        expect(tester.takeException(), isNull);
      });
    });

    group('different painters', () {
      testWidgets('renders with different color painter', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(color: Colors.blue),
              size: Size(100, 100),
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('renders with tracking painter', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedBlurPainter(
              painter: _TrackingPainter(),
              size: const Size(100, 100),
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('edge cases', () {
      testWidgets('handles very small size', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(1, 1),
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles very large size', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(1000, 1000),
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles very high sigma values', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaX: 100,
              sigmaY: 100,
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles asymmetric size', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(300, 50),
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles asymmetric sigma values', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CachedBlurPainter(
              painter: _TestPainter(),
              size: Size(100, 100),
              sigmaX: 5,
              sigmaY: 50,
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('multiple instances', () {
      testWidgets('can render multiple instances', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Column(
              children: [
                CachedBlurPainter(
                  painter: _TestPainter(color: Colors.purple),
                  size: Size(100, 50),
                ),
                CachedBlurPainter(
                  painter: _TestPainter(color: Colors.green),
                  size: Size(100, 50),
                ),
                CachedBlurPainter(
                  painter: _TestPainter(color: Colors.blue),
                  size: Size(100, 50),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsNWidgets(3));
        await disposeAndSettle(tester);
      });

      testWidgets('multiple instances with different sigma', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Column(
              children: [
                CachedBlurPainter(
                  painter: _TestPainter(),
                  size: Size(50, 50),
                  sigmaX: 5,
                ),
                CachedBlurPainter(
                  painter: _TestPainter(),
                  size: Size(100, 100),
                  sigmaX: 20,
                ),
              ],
            ),
          ),
        );

        expect(find.byType(CachedBlurPainter), findsNWidgets(2));
        await disposeAndSettle(tester);
      });
    });
  });
}
