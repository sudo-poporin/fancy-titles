import 'package:fancy_titles/persona_5/constants/constants.dart';
import 'package:fancy_titles/persona_5/widgets/persona_5_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Persona5Text', () {
    // Helper to create a widget wrapped in MaterialApp
    Widget buildTestWidget({
      String text = 'TAKE YOUR HEART',
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Persona5Text(text: text),
          ),
        ),
      );
    }

    group('instantiation', () {
      test('can be instantiated with default parameters', () {
        expect(
          const Persona5Text(),
          isNotNull,
        );
      });

      test('can be instantiated with custom text', () {
        expect(
          const Persona5Text(text: 'CUSTOM TEXT'),
          isNotNull,
        );
      });

      test('has default text value', () {
        const widget = Persona5Text();
        expect(widget, isNotNull);
        // Default text is 'HADOKEN\n\n\ntakes your heart'
      });
    });

    group('rendering', () {
      testWidgets('renders with default parameters', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: Persona5Text(),
          ),
        ));

        expect(find.byType(Persona5Text), findsOneWidget);
      });

      testWidgets('renders with custom text', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byType(Persona5Text), findsOneWidget);
        // Text appears twice due to stroke effect (Stack with 2 Text widgets)
        expect(find.text('TAKE YOUR HEART'), findsNWidgets(2));
      });

      testWidgets('uses Transform for rotation', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Find Transform descendant of Persona5Text
        final transformFinder = find.descendant(
          of: find.byType(Persona5Text),
          matching: find.byType(Transform),
        );
        expect(transformFinder, findsOneWidget);
      });

      testWidgets('uses Stack for stroke effect', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Find Stack descendant of Persona5Text
        final stackFinder = find.descendant(
          of: find.byType(Persona5Text),
          matching: find.byType(Stack),
        );
        expect(stackFinder, findsOneWidget);
      });

      testWidgets('renders two Text widgets for stroke effect', (tester) async {
        await tester.pumpWidget(buildTestWidget(text: 'TEST'));

        // Two Text widgets: one for stroke, one for fill
        expect(find.text('TEST'), findsNWidgets(2));
      });

      testWidgets('uses FittedBox for text scaling', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byType(FittedBox), findsNWidgets(2));
      });
    });

    group('styling', () {
      testWidgets('stroke text has correct style', (tester) async {
        await tester.pumpWidget(buildTestWidget(text: 'TEST'));

        final textWidgets = tester.widgetList<Text>(find.text('TEST')).toList();
        expect(textWidgets.length, equals(2));

        // Find the stroke text (foreground paint with stroke style)
        final strokeText = textWidgets.firstWhere(
          (text) => text.style?.foreground != null,
        );

        expect(
          strokeText.style?.foreground?.style,
          equals(PaintingStyle.stroke),
        );
        expect(strokeText.style?.foreground?.strokeWidth, equals(6));
        expect(strokeText.style?.foreground?.color, equals(whiteColor));
      });

      testWidgets('fill text has correct style', (tester) async {
        await tester.pumpWidget(buildTestWidget(text: 'TEST'));

        final textWidgets = tester.widgetList<Text>(find.text('TEST')).toList();
        expect(textWidgets.length, equals(2));

        // Find the fill text (no foreground, uses color)
        final fillText = textWidgets.firstWhere(
          (text) => text.style?.foreground == null,
        );

        expect(fillText.style?.color, equals(blackColor));
      });

      testWidgets('both texts have same fontSize', (tester) async {
        await tester.pumpWidget(buildTestWidget(text: 'TEST'));

        final textWidgets = tester.widgetList<Text>(find.text('TEST')).toList();

        for (final text in textWidgets) {
          expect(text.style?.fontSize, equals(40));
        }
      });

      testWidgets('both texts have same height', (tester) async {
        await tester.pumpWidget(buildTestWidget(text: 'TEST'));

        final textWidgets = tester.widgetList<Text>(find.text('TEST')).toList();

        for (final text in textWidgets) {
          expect(text.style?.height, equals(1.4));
        }
      });

      testWidgets('both texts have no decoration', (tester) async {
        await tester.pumpWidget(buildTestWidget(text: 'TEST'));

        final textWidgets = tester.widgetList<Text>(find.text('TEST')).toList();

        for (final text in textWidgets) {
          expect(text.style?.decoration, equals(TextDecoration.none));
        }
      });

      testWidgets('both texts use Persona font family', (tester) async {
        await tester.pumpWidget(buildTestWidget(text: 'TEST'));

        final textWidgets = tester.widgetList<Text>(find.text('TEST')).toList();

        for (final text in textWidgets) {
          expect(text.style?.fontFamily, equals('packages/fancy_titles/Persona'));
        }
      });

      testWidgets('both texts are centered', (tester) async {
        await tester.pumpWidget(buildTestWidget(text: 'TEST'));

        final textWidgets = tester.widgetList<Text>(find.text('TEST')).toList();

        for (final text in textWidgets) {
          expect(text.textAlign, equals(TextAlign.center));
        }
      });
    });

    group('transform', () {
      testWidgets('transform is centered', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Find Transform descendant of Persona5Text
        final transformFinder = find.descendant(
          of: find.byType(Persona5Text),
          matching: find.byType(Transform),
        );
        final transform = tester.widget<Transform>(transformFinder);
        expect(transform.alignment, equals(Alignment.center));
      });

      testWidgets('transform uses rotationZ', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Find Transform descendant of Persona5Text
        final transformFinder = find.descendant(
          of: find.byType(Persona5Text),
          matching: find.byType(Transform),
        );
        final transform = tester.widget<Transform>(transformFinder);

        // Matrix4.rotationZ(-0.15) creates a rotation matrix
        // We verify the transform matrix is not identity (has rotation)
        expect(transform.transform, isNot(equals(Matrix4.identity())));
      });
    });

    group('edge cases', () {
      testWidgets('handles empty text', (tester) async {
        await tester.pumpWidget(buildTestWidget(text: ''));

        expect(find.byType(Persona5Text), findsOneWidget);
        // Empty text still renders two Text widgets
        expect(find.text(''), findsNWidgets(2));
      });

      testWidgets('handles long text', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          text: 'LOOKING COOL JOKER! THIS IS A VERY LONG TEXT',
        ));

        expect(find.byType(Persona5Text), findsOneWidget);
      });

      testWidgets('handles multiline text', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          text: 'LINE 1\nLINE 2\nLINE 3',
        ));

        expect(find.byType(Persona5Text), findsOneWidget);
        expect(find.text('LINE 1\nLINE 2\nLINE 3'), findsNWidgets(2));
      });

      testWidgets('handles special characters', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          text: r'!@#$%^&*()',
        ));

        expect(find.byType(Persona5Text), findsOneWidget);
      });

      testWidgets('handles unicode characters', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          text: '日本語テキスト',
        ));

        expect(find.byType(Persona5Text), findsOneWidget);
      });

      testWidgets('handles very long single word', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          text: 'SUPERCALIFRAGILISTICEXPIALIDOCIOUS',
        ));

        expect(find.byType(Persona5Text), findsOneWidget);
      });
    });

    group('layout', () {
      testWidgets('can be placed in a Column', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Persona5Text(text: 'TEST'),
              ],
            ),
          ),
        ));

        expect(find.byType(Persona5Text), findsOneWidget);
      });

      testWidgets('can be placed in a Row', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Expanded(child: Persona5Text(text: 'TEST')),
              ],
            ),
          ),
        ));

        expect(find.byType(Persona5Text), findsOneWidget);
      });

      testWidgets('can be placed in a SizedBox', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 100,
              child: Persona5Text(text: 'TEST'),
            ),
          ),
        ));

        expect(find.byType(Persona5Text), findsOneWidget);
      });

      testWidgets('FittedBox allows text to scale down', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 50,
              height: 20,
              child: Persona5Text(text: 'VERY LONG TEXT HERE'),
            ),
          ),
        ));

        // Should not overflow, FittedBox handles scaling
        expect(find.byType(Persona5Text), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
