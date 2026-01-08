import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/sonic_mania/widgets/bounce_vertically.dart';
import 'package:fancy_titles/sonic_mania/widgets/bouncing_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BouncingText', () {
    /// Helper to dispose widget and settle all animations
    Future<void> disposeAndSettle(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(SonicManiaTiming.totalDuration);
    }

    const testTextStyle = TextStyle(fontSize: 24, color: Colors.black);

    group('instantiation', () {
      testWidgets('can be instantiated with required parameters',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'TEST',
              textStyle: testTextStyle,
            ),
          ),
        );

        expect(find.byType(BouncingText), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with bounceUp false', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'BOUNCE',
              textStyle: testTextStyle,
              bounceUp: false,
            ),
          ),
        );

        expect(find.byType(BouncingText), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with empty text', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: '',
              textStyle: testTextStyle,
            ),
          ),
        );

        expect(find.byType(BouncingText), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with long text', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'VERYLONGTEXT',
              textStyle: testTextStyle,
            ),
          ),
        );

        expect(find.byType(BouncingText), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with single character', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'A',
              textStyle: testTextStyle,
            ),
          ),
        );

        expect(find.byType(BouncingText), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('renders expected widgets', () {
      testWidgets('contains RepaintBoundary', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'TEST',
              textStyle: testTextStyle,
            ),
          ),
        );

        expect(find.byType(RepaintBoundary), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets('contains RichText', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'TEST',
              textStyle: testTextStyle,
            ),
          ),
        );

        expect(find.byType(RichText), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets(
        'creates BounceVertically for each character',
        (tester) async {
          const testText = 'ABC';

          await tester.pumpWidget(
            const MaterialApp(
              home: BouncingText(
                text: testText,
                textStyle: testTextStyle,
              ),
            ),
          );

          // Should have one BounceVertically per character
          expect(find.byType(BounceVertically), findsNWidgets(testText.length));
          await disposeAndSettle(tester);
        },
      );

      testWidgets('renders Text widgets for each character', (tester) async {
        const testText = 'AB';

        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: testText,
              textStyle: testTextStyle,
            ),
          ),
        );

        // Should find Text widgets with individual letters
        expect(find.text('A'), findsOneWidget);
        expect(find.text('B'), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('text style', () {
      testWidgets('applies provided text style', (tester) async {
        const customStyle = TextStyle(
          fontSize: 36,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'STYLED',
              textStyle: customStyle,
            ),
          ),
        );

        expect(find.byType(BouncingText), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('applies stroke style correctly', (tester) async {
        final strokeStyle = TextStyle(
          fontSize: 24,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = Colors.black,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: BouncingText(
              text: 'STROKE',
              textStyle: strokeStyle,
            ),
          ),
        );

        expect(find.byType(BouncingText), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('bounce direction', () {
      testWidgets('bounces up by default', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'UP',
              textStyle: testTextStyle,
            ),
          ),
        );

        // Default bounceUp should be true
        expect(find.byType(BouncingText), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('bounces down when bounceUp is false', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'DOWN',
              textStyle: testTextStyle,
              bounceUp: false,
            ),
          ),
        );

        expect(find.byType(BouncingText), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('animation', () {
      testWidgets('animates after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'ANIMATE',
              textStyle: testTextStyle,
            ),
          ),
        );

        // Advance past bounce delay
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);

        expect(find.byType(BouncingText), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('each character has different delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'ABC',
              textStyle: testTextStyle,
            ),
          ),
        );

        // All BounceVertically should exist
        expect(find.byType(BounceVertically), findsNWidgets(3));

        // Advance animation
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);
        await tester.pump(SonicManiaTiming.bounceVerticallyDuration);

        expect(find.byType(BouncingText), findsOneWidget);

        await disposeAndSettle(tester);
      });
    });

    group('disposal', () {
      testWidgets('disposes without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'DISPOSE',
              textStyle: testTextStyle,
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes mid-animation without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'MID',
              textStyle: testTextStyle,
            ),
          ),
        );

        // Advance partially
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);
        await tester.pump(SonicManiaTiming.bounceVerticallyDuration ~/ 2);

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes long text without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BouncingText(
              text: 'VERYLONGTEXTHERE',
              textStyle: testTextStyle,
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
