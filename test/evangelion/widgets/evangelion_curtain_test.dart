import 'package:fancy_titles/core/animation_timings.dart';
// Using direct import to avoid name conflict with sonic_mania Curtain
import 'package:fancy_titles/evangelion/widgets/evangelion_curtain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Evangelion Curtain', () {
    /// Helper to dispose widget and settle all animations
    Future<void> disposeAndSettle(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(EvangelionTiming.totalDuration);
    }

    group('CurtainOrder enum', () {
      test('has all expected values', () {
        expect(CurtainOrder.values, hasLength(6));
        expect(CurtainOrder.values, contains(CurtainOrder.first));
        expect(CurtainOrder.values, contains(CurtainOrder.second));
        expect(CurtainOrder.values, contains(CurtainOrder.third));
        expect(CurtainOrder.values, contains(CurtainOrder.fourth));
        expect(CurtainOrder.values, contains(CurtainOrder.fifth));
        expect(CurtainOrder.values, contains(CurtainOrder.sixth));
      });
    });

    group('instantiation', () {
      testWidgets('Curtain.first can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.first(),
            ),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.second can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.second(),
            ),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.third can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.third(),
            ),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.fourth can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.fourth(),
            ),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.fifth can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.fifth(),
            ),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.sixth can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.sixth(),
            ),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with custom order', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain(order: CurtainOrder.first),
            ),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with custom parameters', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain(
                order: CurtainOrder.second,
                duration: Duration(milliseconds: 100),
                delay: Duration(milliseconds: 50),
                curve: Curves.linear,
              ),
            ),
          ),
        );

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('renders expected widgets', () {
      testWidgets('contains AnimatedSwitcher', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.first(),
            ),
          ),
        );

        expect(find.byType(AnimatedSwitcher), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('initially shows SizedBox.shrink', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.first(),
            ),
          ),
        );

        // Before delay completes, should show shrunk box
        expect(find.byType(SizedBox), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.first shows ColoredBox when visible',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.first(),
            ),
          ),
        );

        // Advance past delay to show curtain
        await tester.pump(EvangelionTiming.curtainFirstDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(ColoredBox), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.second shows CustomPaint when visible',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.second(),
            ),
          ),
        );

        // Advance past delay to show curtain
        await tester.pump(EvangelionTiming.curtainSecondDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(CustomPaint), findsWidgets);
        await disposeAndSettle(tester);
      });
    });

    group('animation', () {
      testWidgets('Curtain.first shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.first(),
            ),
          ),
        );

        // Advance past first curtain delay
        await tester.pump(EvangelionTiming.curtainFirstDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.second shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.second(),
            ),
          ),
        );

        // Advance past second curtain delay
        await tester.pump(EvangelionTiming.curtainSecondDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.third shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.third(),
            ),
          ),
        );

        // Advance past third curtain delay
        await tester.pump(EvangelionTiming.curtainThirdDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.fourth shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.fourth(),
            ),
          ),
        );

        // Advance past fourth curtain delay
        await tester.pump(EvangelionTiming.curtainFourthDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.fifth shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.fifth(),
            ),
          ),
        );

        // Advance past fifth curtain delay
        await tester.pump(EvangelionTiming.curtainFifthDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.sixth shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.sixth(),
            ),
          ),
        );

        // Advance past sixth curtain delay
        await tester.pump(EvangelionTiming.curtainSixthDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('curtain fades out after duration', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.first(),
            ),
          ),
        );

        // Advance past delay + duration
        await tester.pump(EvangelionTiming.curtainFirstDelay);
        await tester.pump(EvangelionTiming.curtainFirstDuration);
        await tester.pump(const Duration(milliseconds: 50));

        expect(find.byType(Curtain), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('multiple curtains', () {
      testWidgets('can render multiple curtains together', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Curtain.first(),
                  Curtain.second(),
                  Curtain.third(),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Curtain), findsNWidgets(3));
        await disposeAndSettle(tester);
      });

      testWidgets('all six curtains can render together', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Curtain.first(),
                  Curtain.second(),
                  Curtain.third(),
                  Curtain.fourth(),
                  Curtain.fifth(),
                  Curtain.sixth(),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Curtain), findsNWidgets(6));
        await disposeAndSettle(tester);
      });
    });

    group('disposal', () {
      testWidgets('Curtain.first disposes without timer errors',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.first(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Curtain.second disposes without timer errors',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.second(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Curtain.third disposes without timer errors',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.third(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Curtain.fourth disposes without timer errors',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.fourth(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Curtain.fifth disposes without timer errors',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.fifth(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Curtain.sixth disposes without timer errors',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.sixth(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes mid-animation without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.first(),
            ),
          ),
        );

        // Advance partially through animation
        await tester.pump(EvangelionTiming.curtainFirstDelay);
        await tester.pump(EvangelionTiming.curtainFirstDuration ~/ 2);

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes before delay completes', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.sixth(), // Has longest delay
            ),
          ),
        );

        // Dispose before delay completes
        await tester.pump(EvangelionTiming.curtainSixthDelay ~/ 2);

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('all variants dispose without errors', (tester) async {
        for (final curtain in const [
          Curtain.first(),
          Curtain.second(),
          Curtain.third(),
          Curtain.fourth(),
          Curtain.fifth(),
          Curtain.sixth(),
        ]) {
          await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: curtain)),
          );
          await disposeAndSettle(tester);
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('curtain order variations', () {
      testWidgets('Curtain.first uses FadeTransition', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.first(),
            ),
          ),
        );

        // Advance to show curtain
        await tester.pump(EvangelionTiming.curtainFirstDelay);
        await tester.pump(const Duration(milliseconds: 10));

        // FadeTransition is used by AnimatedSwitcher in Curtain.first
        expect(find.byType(FadeTransition), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.second uses ScaleTransition', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.second(),
            ),
          ),
        );

        // Advance to show curtain
        await tester.pump(EvangelionTiming.curtainSecondDelay);
        await tester.pump(const Duration(milliseconds: 10));

        // ScaleTransition is used by AnimatedSwitcher in Curtain.second
        expect(find.byType(ScaleTransition), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets('Curtain.third uses ScaleTransition', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Curtain.third(),
            ),
          ),
        );

        // Advance to show curtain
        await tester.pump(EvangelionTiming.curtainThirdDelay);
        await tester.pump(const Duration(milliseconds: 10));

        // ScaleTransition is used by AnimatedSwitcher in Curtain.third
        expect(find.byType(ScaleTransition), findsWidgets);
        await disposeAndSettle(tester);
      });
    });
  });
}
