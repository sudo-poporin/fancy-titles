import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarioMakerTitle golden tests', () {
    // These tests verify the visual appearance of MarioMakerTitle.
    // The image loading errors are expected because test assets aren't
    // available in the standard asset bundle, but the widget handles
    // this gracefully with its fire-and-forget precacheImage approach.

    testWidgets(
      'initial state',
      (tester) async {
        // Suppress image loading errors for this test
        final originalOnError = FlutterError.onError;
        final imageErrors = <FlutterErrorDetails>[];
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') {
            imageErrors.add(details);
            return;
          }
          originalOnError?.call(details);
        };

        const goldenKey = Key('mario_maker_golden');

        await tester.pumpWidget(
          const MaterialApp(
            home: RepaintBoundary(
              key: goldenKey,
              child: SizedBox(
                width: 400,
                height: 300,
                child: MarioMakerTitle(
                  title: 'WORLD 1-1',
                  imagePath: 'assets/test.png',
                ),
              ),
            ),
          ),
        );

        // Allow the widget to build
        await tester.pump();

        await expectLater(
          find.byKey(goldenKey),
          matchesGoldenFile('goldens/mario_maker_initial.png'),
        );

        // Complete the animation to avoid pending timers
        await tester.pump(MarioMakerTiming.defaultTotalDuration);
        await tester.pump();

        // Restore error handler
        FlutterError.onError = originalOnError;
      },
    );

    testWidgets(
      'expanded state',
      (tester) async {
        // Suppress image loading errors for this test
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.library == 'image resource service') {
            return;
          }
          originalOnError?.call(details);
        };

        const goldenKey = Key('mario_maker_golden');

        await tester.pumpWidget(
          const MaterialApp(
            home: RepaintBoundary(
              key: goldenKey,
              child: SizedBox(
                width: 400,
                height: 300,
                child: MarioMakerTitle(
                  title: 'WORLD 1-1',
                  imagePath: 'assets/test.png',
                ),
              ),
            ),
          ),
        );

        // Allow the widget to build
        await tester.pump();

        // Advance past bounce and expand
        await tester.pump(MarioMakerTiming.bounceDuration);
        await tester.pump(MarioMakerTiming.expandDuration);
        await tester.pump(const Duration(milliseconds: 100));

        await expectLater(
          find.byKey(goldenKey),
          matchesGoldenFile('goldens/mario_maker_expanded.png'),
        );

        // Complete the animation to avoid pending timers
        await tester.pump(const Duration(milliseconds: 1900));
        await tester.pump();

        // Restore error handler
        FlutterError.onError = originalOnError;
      },
    );
  });
}
