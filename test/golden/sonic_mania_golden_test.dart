import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SonicManiaSplash golden tests', () {
    testWidgets('initial state', (tester) async {
      const goldenKey = Key('sonic_mania_golden');

      await tester.pumpWidget(
        MaterialApp(
          home: RepaintBoundary(
            key: goldenKey,
            child: SizedBox(
              width: 400,
              height: 300,
              child: SonicManiaSplash(
                baseText: 'STUDIOPOLIS',
                secondaryText: 'ZONE',
                lastText: 'ACT1',
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byKey(goldenKey),
        matchesGoldenFile('goldens/sonic_mania_initial.png'),
      );
    });

    testWidgets('active state (after slide in)', (tester) async {
      const goldenKey = Key('sonic_mania_golden');

      await tester.pumpWidget(
        MaterialApp(
          home: RepaintBoundary(
            key: goldenKey,
            child: SizedBox(
              width: 400,
              height: 300,
              child: SonicManiaSplash(
                baseText: 'STUDIOPOLIS',
                secondaryText: 'ZONE',
                lastText: 'ACT1',
              ),
            ),
          ),
        ),
      );

      // Advance past slide-in animation
      await tester.pump(SonicManiaTiming.slideIn);
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byKey(goldenKey),
        matchesGoldenFile('goldens/sonic_mania_active.png'),
      );
    });
  });
}
