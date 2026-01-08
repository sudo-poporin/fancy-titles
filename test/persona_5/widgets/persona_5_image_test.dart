import 'package:fancy_titles/persona_5/widgets/persona_5_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Persona5Image', () {
    group('with null imagePath', () {
      testWidgets('can be instantiated with null imagePath', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: false,
              ),
            ),
          ),
        );

        expect(find.byType(Persona5Image), findsOneWidget);
      });

      testWidgets('shows SizedBox.shrink when imagePath is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: false,
              ),
            ),
          ),
        );

        // When imagePath is null, should render SizedBox.shrink
        // No Transform.rotate (from Persona5Image) should be present within
        expect(
          find.descendant(
            of: find.byType(Persona5Image),
            matching: find.byType(Transform),
          ),
          findsNothing,
        );

        // Find the actual SizedBox that is the root of Persona5Image build
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('shows no Transform when imagePath is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: false,
              ),
            ),
          ),
        );

        expect(
          find.descendant(
            of: find.byType(Persona5Image),
            matching: find.byType(Transform),
          ),
          findsNothing,
        );
      });

      testWidgets('shows no Stack when imagePath is null', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: false,
              ),
            ),
          ),
        );

        // Stack only appears inside Persona5Image when imagePath is not null
        expect(
          find.descendant(
            of: find.byType(Persona5Image),
            matching: find.byType(Stack),
          ),
          findsNothing,
        );
      });

      testWidgets('shows no Image when imagePath is null', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: false,
              ),
            ),
          ),
        );

        expect(
          find.descendant(
            of: find.byType(Persona5Image),
            matching: find.byType(Image),
          ),
          findsNothing,
        );
      });

      testWidgets('blend mode has no effect when imagePath is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: true,
              ),
            ),
          ),
        );

        // Still no Image widgets
        expect(
          find.descendant(
            of: find.byType(Persona5Image),
            matching: find.byType(Image),
          ),
          findsNothing,
        );
      });
    });

    group('with key', () {
      testWidgets('can be instantiated with key', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                key: Key('test-key'),
                imagePath: null,
                withImageBlendMode: false,
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('test-key')), findsOneWidget);
      });
    });

    group('multiple instances', () {
      testWidgets('can render multiple null instances', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Persona5Image(
                    key: Key('image1'),
                    imagePath: null,
                    withImageBlendMode: false,
                  ),
                  Persona5Image(
                    key: Key('image2'),
                    imagePath: null,
                    withImageBlendMode: true,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Persona5Image), findsNWidgets(2));
        expect(find.byKey(const Key('image1')), findsOneWidget);
        expect(find.byKey(const Key('image2')), findsOneWidget);
      });
    });

    group('in different contexts', () {
      testWidgets('renders in Center', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Persona5Image(
                  imagePath: null,
                  withImageBlendMode: false,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(Persona5Image), findsOneWidget);
      });

      testWidgets('renders in Stack with other widgets', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(),
                  Persona5Image(
                    imagePath: null,
                    withImageBlendMode: true,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Persona5Image), findsOneWidget);
      });

      testWidgets('renders in Column', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Persona5Image(
                    imagePath: null,
                    withImageBlendMode: false,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Persona5Image), findsOneWidget);
      });

      testWidgets('renders in Expanded', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: Persona5Image(
                      imagePath: null,
                      withImageBlendMode: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Persona5Image), findsOneWidget);
      });
    });

    group('stateless behavior', () {
      testWidgets('rebuilds correctly when parameters change', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: false,
              ),
            ),
          ),
        );

        expect(
          find.descendant(
            of: find.byType(Persona5Image),
            matching: find.byType(Transform),
          ),
          findsNothing,
        );

        // Rebuild with different blend mode
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: true,
              ),
            ),
          ),
        );

        // Still no transform since imagePath is null
        expect(
          find.descendant(
            of: find.byType(Persona5Image),
            matching: find.byType(Transform),
          ),
          findsNothing,
        );
      });

      testWidgets('disposes without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: false,
              ),
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

    group('widget type verification', () {
      testWidgets('is a StatelessWidget', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Persona5Image(
                imagePath: null,
                withImageBlendMode: false,
              ),
            ),
          ),
        );

        final widget = tester.widget<Persona5Image>(
          find.byType(Persona5Image),
        );
        expect(widget, isA<StatelessWidget>());
      });
    });
  });
}
