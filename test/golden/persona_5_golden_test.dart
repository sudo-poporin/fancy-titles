import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Persona5Title golden tests', () {
    testWidgets('initial state', (tester) async {
      const goldenKey = Key('persona_5_golden');

      await tester.pumpWidget(
        const MaterialApp(
          home: RepaintBoundary(
            key: goldenKey,
            child: SizedBox(
              width: 400,
              height: 300,
              child: Persona5Title(
                text: 'LOOKING COOL',
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byKey(goldenKey),
        matchesGoldenFile('goldens/persona_5_initial.png'),
      );
    });

    testWidgets('active state', (tester) async {
      const goldenKey = Key('persona_5_golden');

      await tester.pumpWidget(
        const MaterialApp(
          home: RepaintBoundary(
            key: goldenKey,
            child: SizedBox(
              width: 400,
              height: 300,
              child: Persona5Title(
                text: 'LOOKING COOL',
              ),
            ),
          ),
        ),
      );

      // Advance to active phase
      await tester.pump(Persona5Timing.initialDelay);
      await tester.pump(const Duration(milliseconds: 500));

      await expectLater(
        find.byKey(goldenKey),
        matchesGoldenFile('goldens/persona_5_active.png'),
      );
    });
  });
}
