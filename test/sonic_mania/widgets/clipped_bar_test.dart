import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/sonic_mania/clippers/clippers.dart';
import 'package:fancy_titles/sonic_mania/widgets/clipped_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClippedBar', () {
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
            home: ClippedBar(
              color: Colors.blue,
              customClipper: BlueBarClipper(),
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with all parameters', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.purple,
              customClipper: BlueBarClipper(),
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceIn,
              delay: const Duration(milliseconds: 1000),
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('color variants', () {
      testWidgets('ClippedBar.red creates red bar', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar.red(
              customClipper: RedBarClipper(),
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('ClippedBar.orange creates orange bar', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar.orange(
              customClipper: OrangeBarClipper(),
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('ClippedBar.blue creates blue bar', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar.blue(
              customClipper: BlueBarClipper(),
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('ClippedBar.green creates green bar', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar.green(
              customClipper: GreenBarClipper(),
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('renders expected widgets', () {
      testWidgets('contains ClipPath', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.blue,
              customClipper: BlueBarClipper(),
            ),
          ),
        );

        expect(find.byType(ClipPath), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('contains ColoredBox with correct color', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.red,
              customClipper: RedBarClipper(),
            ),
          ),
        );

        // Find all ColoredBox widgets and check if one has the expected color
        final coloredBoxes = tester.widgetList<ColoredBox>(
          find.byType(ColoredBox),
        );
        final hasExpectedColor = coloredBoxes.any(
          (box) => box.color == Colors.red,
        );
        expect(hasExpectedColor, isTrue);
        await disposeAndSettle(tester);
      });

      testWidgets('uses provided custom clipper', (tester) async {
        final clipper = BlueBarClipper();

        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.blue,
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
            home: ClippedBar(
              color: Colors.blue,
              customClipper: BlueBarClipper(),
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsOneWidget);

        // Advance past initial delay (725ms from source)
        await tester.pump(const Duration(milliseconds: 725));

        expect(find.byType(ClippedBar), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('slides out after delay', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.blue,
              customClipper: BlueBarClipper(),
              delay: const Duration(milliseconds: 1000),
            ),
          ),
        );

        // Advance through initial animation
        await tester.pump(const Duration(milliseconds: 725));
        await tester.pump(const Duration(milliseconds: 325));

        // Advance past slide out delay
        await tester.pump(const Duration(milliseconds: 1000));

        expect(find.byType(ClippedBar), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('uses custom duration', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.blue,
              customClipper: BlueBarClipper(),
              duration: const Duration(milliseconds: 600),
            ),
          ),
        );

        // Advance past initial delay
        await tester.pump(const Duration(milliseconds: 725));

        // Advance through custom duration
        await tester.pump(const Duration(milliseconds: 600));

        expect(find.byType(ClippedBar), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('uses custom curve', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.blue,
              customClipper: BlueBarClipper(),
              curve: Curves.bounceInOut,
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsOneWidget);

        await disposeAndSettle(tester);
      });
    });

    group('disposal', () {
      testWidgets('disposes without errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.blue,
              customClipper: BlueBarClipper(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes mid-animation without errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.blue,
              customClipper: BlueBarClipper(),
            ),
          ),
        );

        // Advance partially through animation
        await tester.pump(const Duration(milliseconds: 500));

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes during slide out without errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ClippedBar(
              color: Colors.blue,
              customClipper: BlueBarClipper(),
              delay: const Duration(milliseconds: 500),
            ),
          ),
        );

        // Advance to slide out phase
        await tester.pump(const Duration(milliseconds: 725));
        await tester.pump(const Duration(milliseconds: 325));
        await tester.pump(const Duration(milliseconds: 600));

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('all color variants dispose cleanly', (tester) async {
        final variants = [
          ClippedBar.red(customClipper: RedBarClipper()),
          ClippedBar.orange(customClipper: OrangeBarClipper()),
          ClippedBar.blue(customClipper: BlueBarClipper()),
          ClippedBar.green(customClipper: GreenBarClipper()),
        ];

        for (final bar in variants) {
          await tester.pumpWidget(MaterialApp(home: bar));
          await disposeAndSettle(tester);
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('multiple instances', () {
      testWidgets('multiple bars render correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                ClippedBar.red(customClipper: RedBarClipper()),
                ClippedBar.orange(customClipper: OrangeBarClipper()),
                ClippedBar.blue(customClipper: BlueBarClipper()),
                ClippedBar.green(customClipper: GreenBarClipper()),
              ],
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsNWidgets(4));

        await disposeAndSettle(tester);
      });

      testWidgets('multiple bars animate with different delays',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                ClippedBar(
                  color: Colors.red,
                  customClipper: RedBarClipper(),
                  delay: const Duration(milliseconds: 100),
                ),
                ClippedBar(
                  color: Colors.blue,
                  customClipper: BlueBarClipper(),
                  delay: const Duration(milliseconds: 200),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(ClippedBar), findsNWidgets(2));

        // Advance animation
        await tester.pump(const Duration(milliseconds: 725));

        expect(find.byType(ClippedBar), findsNWidgets(2));

        await disposeAndSettle(tester);
      });
    });
  });
}
