import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EvangelionTitle golden tests', () {
    testWidgets('initial state', (tester) async {
      const goldenKey = Key('evangelion_golden');

      await tester.pumpWidget(
        const MaterialApp(
          home: RepaintBoundary(
            key: goldenKey,
            child: SizedBox(
              width: 400,
              height: 300,
              child: EvangelionTitle(
                firstText: 'EPISODE',
                secondText: '01',
                thirdText: 'ANGEL',
                fourthText: 'ATTACK',
                fifthText: '',
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byKey(goldenKey),
        matchesGoldenFile('goldens/evangelion_initial.png'),
      );
    });

    testWidgets('text visible state', (tester) async {
      const goldenKey = Key('evangelion_golden');

      await tester.pumpWidget(
        const MaterialApp(
          home: RepaintBoundary(
            key: goldenKey,
            child: SizedBox(
              width: 400,
              height: 300,
              child: EvangelionTitle(
                firstText: 'EPISODE',
                secondText: '01',
                thirdText: 'ANGEL',
                fourthText: 'ATTACK',
                fifthText: '',
              ),
            ),
          ),
        ),
      );

      // Advance past text appear delay
      await tester.pump(EvangelionTiming.textAppearDelay);
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byKey(goldenKey),
        matchesGoldenFile('goldens/evangelion_text_visible.png'),
      );
    });
  });
}
