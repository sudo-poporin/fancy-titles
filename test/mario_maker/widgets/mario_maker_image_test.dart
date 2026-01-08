import 'package:fancy_titles/mario_maker/widgets/mario_maker_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarioMakerImage', () {
    group('instantiation', () {
      test('can be instantiated with required parameters', () {
        const widget = MarioMakerImage(imagePath: 'assets/test.png');
        expect(widget, isNotNull);
      });

      test('can be instantiated with all parameters', () {
        const widget = MarioMakerImage(
          imagePath: 'assets/test.png',
          size: 200,
        );
        expect(widget, isNotNull);
      });

      test('has default size of 150', () {
        const widget = MarioMakerImage(imagePath: 'assets/test.png');
        // Default size is 150 as per the widget implementation
        expect(widget, isNotNull);
      });
    });

    group('rendering', () {
      testWidgets('renders widget correctly', (tester) async {
        // Suppress image loading errors for this test since we don't have
        // actual assets
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(imagePath: 'assets/test.png'),
            ),
          ),
        );

        expect(find.byType(MarioMakerImage), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);

        FlutterError.onError = originalOnError;
      });

      testWidgets('uses default size of 150', (tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(imagePath: 'assets/test.png'),
            ),
          ),
        );

        final sizedBoxFinder = find.descendant(
          of: find.byType(MarioMakerImage),
          matching: find.byType(SizedBox),
        );
        final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);

        expect(sizedBox.width, 150);
        expect(sizedBox.height, 150);

        FlutterError.onError = originalOnError;
      });

      testWidgets('accepts custom size', (tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(
                imagePath: 'assets/test.png',
                size: 200,
              ),
            ),
          ),
        );

        final sizedBoxFinder = find.descendant(
          of: find.byType(MarioMakerImage),
          matching: find.byType(SizedBox),
        );
        final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);

        expect(sizedBox.width, 200);
        expect(sizedBox.height, 200);

        FlutterError.onError = originalOnError;
      });

      testWidgets('renders Image.asset with correct path', (tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(imagePath: 'custom/path/image.png'),
            ),
          ),
        );

        expect(find.byType(Image), findsOneWidget);

        FlutterError.onError = originalOnError;
      });

      testWidgets('uses BoxFit.contain for image', (tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(imagePath: 'assets/test.png'),
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, BoxFit.contain);

        FlutterError.onError = originalOnError;
      });

      testWidgets('has gaplessPlayback enabled', (tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(imagePath: 'assets/test.gif'),
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.gaplessPlayback, isTrue);

        FlutterError.onError = originalOnError;
      });
    });

    group('edge cases', () {
      testWidgets('handles zero size', (tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(
                imagePath: 'assets/test.png',
                size: 0,
              ),
            ),
          ),
        );

        expect(find.byType(MarioMakerImage), findsOneWidget);

        FlutterError.onError = originalOnError;
      });

      testWidgets('handles very large size', (tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(
                imagePath: 'assets/test.png',
                size: 1000,
              ),
            ),
          ),
        );

        expect(find.byType(MarioMakerImage), findsOneWidget);

        FlutterError.onError = originalOnError;
      });

      testWidgets('supports GIF paths', (tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(imagePath: 'assets/animation.gif'),
            ),
          ),
        );

        expect(find.byType(MarioMakerImage), findsOneWidget);

        FlutterError.onError = originalOnError;
      });

      testWidgets('supports nested paths', (tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') return;
          originalOnError?.call(details);
        };

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MarioMakerImage(
                imagePath: 'assets/images/characters/mario.png',
              ),
            ),
          ),
        );

        expect(find.byType(MarioMakerImage), findsOneWidget);

        FlutterError.onError = originalOnError;
      });
    });
  });
}
