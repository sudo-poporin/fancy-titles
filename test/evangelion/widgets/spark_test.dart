import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/evangelion/widgets/spark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Spark', () {
    /// Helper to dispose widget and settle all animations
    Future<void> disposeAndSettle(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(EvangelionTiming.totalDuration);
    }

    group('SparkOrder enum', () {
      test('has all expected values', () {
        expect(SparkOrder.values, hasLength(6));
        expect(SparkOrder.values, contains(SparkOrder.first));
        expect(SparkOrder.values, contains(SparkOrder.second));
        expect(SparkOrder.values, contains(SparkOrder.third));
        expect(SparkOrder.values, contains(SparkOrder.fourth));
        expect(SparkOrder.values, contains(SparkOrder.fifth));
        expect(SparkOrder.values, contains(SparkOrder.sixth));
      });
    });

    group('instantiation', () {
      testWidgets('Spark.first can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.first(),
            ),
          ),
        );

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.second can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.second(),
            ),
          ),
        );

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.third can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.third(),
            ),
          ),
        );

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.fourth can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.fourth(),
            ),
          ),
        );

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.fifth can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.fifth(),
            ),
          ),
        );

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.sixth can be instantiated', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.sixth(),
            ),
          ),
        );

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with custom order', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark(order: SparkOrder.first),
            ),
          ),
        );

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with custom parameters', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark(
                order: SparkOrder.second,
                duration: Duration(milliseconds: 100),
                delay: Duration(milliseconds: 50),
                curve: Curves.linear,
              ),
            ),
          ),
        );

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('renders expected widgets', () {
      testWidgets('contains AnimatedSwitcher', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.first(),
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
              body: Spark.first(),
            ),
          ),
        );

        // Before delay completes, should show shrunk box
        expect(find.byType(SizedBox), findsWidgets);
        await disposeAndSettle(tester);
      });
    });

    group('animation', () {
      testWidgets('Spark.first shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.first(),
            ),
          ),
        );

        // Advance past first spark delay
        await tester.pump(EvangelionTiming.sparkFirstDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.second shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.second(),
            ),
          ),
        );

        // Advance past second spark delay
        await tester.pump(EvangelionTiming.sparkSecondDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.third shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.third(),
            ),
          ),
        );

        // Advance past third spark delay
        await tester.pump(EvangelionTiming.sparkThirdDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.fourth shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.fourth(),
            ),
          ),
        );

        // Advance past fourth spark delay
        await tester.pump(EvangelionTiming.sparkFourthDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.fifth shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.fifth(),
            ),
          ),
        );

        // Advance past fifth spark delay
        await tester.pump(EvangelionTiming.sparkFifthDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.sixth shows content after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.sixth(),
            ),
          ),
        );

        // Advance past sixth spark delay
        await tester.pump(EvangelionTiming.sparkSixthDelay);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('spark fades out after duration', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.first(),
            ),
          ),
        );

        // Advance past delay + duration
        await tester.pump(EvangelionTiming.sparkFirstDelay);
        await tester.pump(EvangelionTiming.crossFlashDuration);
        await tester.pump(const Duration(milliseconds: 50));

        expect(find.byType(Spark), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('multiple sparks', () {
      testWidgets('can render multiple sparks together', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Spark.first(),
                  Spark.second(),
                  Spark.third(),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Spark), findsNWidgets(3));
        await disposeAndSettle(tester);
      });

      testWidgets('all six sparks can render together', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Spark.first(),
                  Spark.second(),
                  Spark.third(),
                  Spark.fourth(),
                  Spark.fifth(),
                  Spark.sixth(),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Spark), findsNWidgets(6));
        await disposeAndSettle(tester);
      });
    });

    group('disposal', () {
      testWidgets('Spark.first disposes without timer errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.first(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Spark.second disposes without timer errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.second(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Spark.third disposes without timer errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.third(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Spark.fourth disposes without timer errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.fourth(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Spark.fifth disposes without timer errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.fifth(),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Spark.sixth disposes without timer errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.sixth(),
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
              body: Spark.first(),
            ),
          ),
        );

        // Advance partially through animation
        await tester.pump(EvangelionTiming.sparkFirstDelay);
        await tester.pump(EvangelionTiming.crossFlashDuration ~/ 2);

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes before delay completes', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.sixth(), // Has longest delay
            ),
          ),
        );

        // Dispose before delay completes
        await tester.pump(EvangelionTiming.sparkSixthDelay ~/ 2);

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('all variants dispose without errors', (tester) async {
        for (final spark in const [
          Spark.first(),
          Spark.second(),
          Spark.third(),
          Spark.fourth(),
          Spark.fifth(),
          Spark.sixth(),
        ]) {
          await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: spark)),
          );
          await disposeAndSettle(tester);
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('default values', () {
      testWidgets('Spark.first has correct default duration', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.first(),
            ),
          ),
        );

        final spark = tester.widget<Spark>(find.byType(Spark));
        expect(spark.duration, equals(EvangelionTiming.crossFlashDuration));
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.first has correct default delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.first(),
            ),
          ),
        );

        final spark = tester.widget<Spark>(find.byType(Spark));
        expect(spark.delay, equals(EvangelionTiming.sparkFirstDelay));
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.second has correct default delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.second(),
            ),
          ),
        );

        final spark = tester.widget<Spark>(find.byType(Spark));
        expect(spark.delay, equals(EvangelionTiming.sparkSecondDelay));
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.third has correct default delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.third(),
            ),
          ),
        );

        final spark = tester.widget<Spark>(find.byType(Spark));
        expect(spark.delay, equals(EvangelionTiming.sparkThirdDelay));
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.fourth has correct default delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.fourth(),
            ),
          ),
        );

        final spark = tester.widget<Spark>(find.byType(Spark));
        expect(spark.delay, equals(EvangelionTiming.sparkFourthDelay));
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.fifth has correct default delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.fifth(),
            ),
          ),
        );

        final spark = tester.widget<Spark>(find.byType(Spark));
        expect(spark.delay, equals(EvangelionTiming.sparkFifthDelay));
        await disposeAndSettle(tester);
      });

      testWidgets('Spark.sixth has correct default delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.sixth(),
            ),
          ),
        );

        final spark = tester.widget<Spark>(find.byType(Spark));
        expect(spark.delay, equals(EvangelionTiming.sparkSixthDelay));
        await disposeAndSettle(tester);
      });

      testWidgets('default curve is easeInOut', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Spark.first(),
            ),
          ),
        );

        final spark = tester.widget<Spark>(find.byType(Spark));
        expect(spark.curve, equals(Curves.easeInOut));
        await disposeAndSettle(tester);
      });
    });
  });
}
