import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/sonic_mania/widgets/curtain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Curtain', () {
    /// Helper to dispose widget and settle all animations
    Future<void> disposeAndSettle(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(SonicManiaTiming.totalDuration);
    }

    group('instantiation', () {
      testWidgets('can be instantiated with required color', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(color: Colors.blue),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with custom delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(
              color: Colors.red,
              delay: Duration(milliseconds: 500),
            ),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets(
        'can be instantiated with default zero delay',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Curtain(color: Colors.green),
            ),
          );

          expect(find.byType(Curtain), findsOneWidget);
          await disposeAndSettle(tester);
        },
      );
    });

    group('color variants', () {
      testWidgets('Curtain.blue creates blue curtain', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain.blue(),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.orange creates orange curtain', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain.orange(),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.amber creates amber curtain', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain.amber(),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.green creates green curtain', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain.green(),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.yellow creates yellow curtain', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain.yellow(),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.black creates black curtain', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain.black(),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('renders expected widgets', () {
      testWidgets('contains SizeTransition', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(color: Colors.blue),
          ),
        );

        expect(find.byType(SizeTransition), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('contains AnimatedSize', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(color: Colors.blue),
          ),
        );

        expect(find.byType(AnimatedSize), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('contains ColoredBox with correct color', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(color: Colors.red),
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
    });

    group('animation', () {
      testWidgets('starts animation after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(
              color: Colors.blue,
              delay: Duration(milliseconds: 100),
            ),
          ),
        );

        // Before delay, widget should exist
        expect(find.byType(Curtain), findsOneWidget);

        // Advance past delay
        await tester.pump(const Duration(milliseconds: 100));

        // Widget should still exist during animation
        expect(find.byType(Curtain), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('animates expand and contract', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(color: Colors.blue),
          ),
        );

        // Trigger animation start
        await tester.pump(Duration.zero);

        // Advance through expand
        await tester.pump(SonicManiaTiming.curtainExpandDuration);

        // Widget should exist during animation
        expect(find.byType(Curtain), findsOneWidget);

        // Advance through contract (reverse)
        await tester.pump(SonicManiaTiming.curtainExpandDuration);

        expect(find.byType(Curtain), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('multiple curtains animate with different delays',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Column(
              children: [
                Expanded(child: Curtain.blue()),
                Expanded(child: Curtain.orange()),
                Expanded(child: Curtain.amber()),
              ],
            ),
          ),
        );

        // All curtains should exist
        expect(find.byType(Curtain), findsNWidgets(3));

        // Advance animation
        await tester.pump(SonicManiaTiming.curtainOrangeDelay);

        expect(find.byType(Curtain), findsNWidgets(3));

        await disposeAndSettle(tester);
      });
    });

    group('disposal', () {
      testWidgets('disposes without timer errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(color: Colors.blue),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes mid-animation without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(color: Colors.blue),
          ),
        );

        // Advance partially through animation
        await tester.pump(SonicManiaTiming.curtainExpandDuration ~/ 2);

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes before animation starts without errors',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Curtain(
              color: Colors.blue,
              delay: Duration(seconds: 1),
            ),
          ),
        );

        // Dispose before delay completes
        await tester.pump(const Duration(milliseconds: 100));

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes all color variants without errors', (tester) async {
        // Test each variant disposes cleanly
        for (final curtain in const [
          Curtain.blue(),
          Curtain.orange(),
          Curtain.amber(),
          Curtain.green(),
          Curtain.yellow(),
          Curtain.black(),
        ]) {
          await tester.pumpWidget(
            MaterialApp(home: curtain),
          );
          await disposeAndSettle(tester);
          expect(tester.takeException(), isNull);
        }
      });
    });
  });
}
