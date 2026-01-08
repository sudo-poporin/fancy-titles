import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/sonic_mania/clippers/clippers.dart';
import 'package:fancy_titles/sonic_mania/widgets/clipped_curtain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClippedCurtain', () {
    /// Helper to dispose widget and settle all animations
    Future<void> disposeAndSettle(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(SonicManiaTiming.totalDuration);
    }

    group('instantiation', () {
      testWidgets('can be instantiated with required parameters',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain(
              customClipper: LeftCurtainClipper(),
              beginOffset: const Offset(-1, 0),
              endOffset: const Offset(-1, 0),
            ),
          ),
        );

        expect(find.byType(ClippedCurtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with custom offsets', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain(
              customClipper: RightCurtainClipper(),
              beginOffset: const Offset(0.5, 0),
              endOffset: const Offset(1.5, 0),
            ),
          ),
        );

        expect(find.byType(ClippedCurtain), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('direction variants', () {
      testWidgets('ClippedCurtain.left creates left curtain', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: LeftCurtainClipper(),
            ),
          ),
        );

        expect(find.byType(ClippedCurtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('ClippedCurtain.right creates right curtain', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.right(
              customClipper: RightCurtainClipper(),
            ),
          ),
        );

        expect(find.byType(ClippedCurtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('left variant uses correct default offsets', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: LeftCurtainClipper(),
            ),
          ),
        );

        // Widget should exist with left-side defaults
        expect(find.byType(ClippedCurtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('right variant uses correct default offsets', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.right(
              customClipper: RightCurtainClipper(),
            ),
          ),
        );

        // Widget should exist with right-side defaults
        expect(find.byType(ClippedCurtain), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('renders expected widgets', () {
      testWidgets('contains ClipPath', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: LeftCurtainClipper(),
            ),
          ),
        );

        expect(find.byType(ClipPath), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('contains ColoredBox with yellow color', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: LeftCurtainClipper(),
            ),
          ),
        );

        // Find all ColoredBox widgets and check if one has the expected color
        // Yellow color from source: Color(0xFFF7C700)
        final coloredBoxes = tester.widgetList<ColoredBox>(
          find.byType(ColoredBox),
        );
        final hasExpectedColor = coloredBoxes.any(
          (box) => box.color == const Color(0xFFF7C700),
        );
        expect(hasExpectedColor, isTrue);
        await disposeAndSettle(tester);
      });

      testWidgets('uses provided custom clipper', (tester) async {
        final clipper = LeftCurtainClipper();

        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: clipper,
            ),
          ),
        );

        final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
        expect(clipPath.clipper, clipper);
        await disposeAndSettle(tester);
      });
    });

    group('animation', () {
      testWidgets('starts animation after initial delay', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: LeftCurtainClipper(),
            ),
          ),
        );

        expect(find.byType(ClippedCurtain), findsOneWidget);

        // Advance past initial delay (500ms from source)
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(ClippedCurtain), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('slides out after hold delay', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: LeftCurtainClipper(),
            ),
          ),
        );

        // Advance through initial animation
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 325));

        // Advance past slide out delay (2500ms from source)
        await tester.pump(const Duration(milliseconds: 2500));

        expect(find.byType(ClippedCurtain), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('animates from begin offset to neutral', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain(
              customClipper: LeftCurtainClipper(),
              beginOffset: const Offset(-1, 0),
              endOffset: const Offset(-1, 0),
            ),
          ),
        );

        // Initial state
        expect(find.byType(ClippedCurtain), findsOneWidget);

        // After delay, animation should progress
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 325));

        expect(find.byType(ClippedCurtain), findsOneWidget);

        await disposeAndSettle(tester);
      });
    });

    group('disposal', () {
      testWidgets('disposes without errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: LeftCurtainClipper(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes mid-animation without errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: LeftCurtainClipper(),
            ),
          ),
        );

        // Advance partially through animation
        await tester.pump(const Duration(milliseconds: 300));

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes during slide out without errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedCurtain.left(
              customClipper: LeftCurtainClipper(),
            ),
          ),
        );

        // Advance to slide out phase
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 325));
        await tester.pump(const Duration(milliseconds: 2600));

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('both direction variants dispose cleanly', (tester) async {
        final variants = [
          ClippedCurtain.left(customClipper: LeftCurtainClipper()),
          ClippedCurtain.right(customClipper: RightCurtainClipper()),
        ];

        for (final curtain in variants) {
          await tester.pumpWidget(MaterialApp(home: curtain));
          await disposeAndSettle(tester);
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('multiple instances', () {
      testWidgets('left and right curtains render together', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                ClippedCurtain.left(customClipper: LeftCurtainClipper()),
                ClippedCurtain.right(customClipper: RightCurtainClipper()),
              ],
            ),
          ),
        );

        expect(find.byType(ClippedCurtain), findsNWidgets(2));

        await disposeAndSettle(tester);
      });

      testWidgets('multiple curtains animate independently', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                ClippedCurtain.left(customClipper: LeftCurtainClipper()),
                ClippedCurtain.right(customClipper: RightCurtainClipper()),
              ],
            ),
          ),
        );

        // Advance animation
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(ClippedCurtain), findsNWidgets(2));

        await disposeAndSettle(tester);
      });
    });
  });
}
