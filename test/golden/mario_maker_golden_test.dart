import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarioMakerTitle golden tests', () {
    // Note: MarioMakerTitle uses precacheImage which requires actual asset
    // files. These tests are skipped until asset loading can be mocked or
    // test assets are created. See OPT-002 recommendations for future work.
    testWidgets(
      'initial state',
      // Requires image asset for precacheImage
      skip: true,
      (tester) async {
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

        await expectLater(
          find.byKey(goldenKey),
          matchesGoldenFile('goldens/mario_maker_initial.png'),
        );
      },
    );

    testWidgets(
      'expanded state',
      // Requires image asset for precacheImage
      skip: true,
      (tester) async {
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

        // Advance past bounce and expand
        await tester.pump(MarioMakerTiming.bounceDuration);
        await tester.pump(MarioMakerTiming.expandDuration);
        await tester.pump(const Duration(milliseconds: 100));

        await expectLater(
          find.byKey(goldenKey),
          matchesGoldenFile('goldens/mario_maker_expanded.png'),
        );
      },
    );
  });
}
