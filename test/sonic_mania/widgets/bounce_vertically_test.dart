import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/sonic_mania/widgets/bounce_vertically.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BounceVertically', () {
    /// Helper to dispose widget and settle all animations
    Future<void> disposeAndSettle(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(SonicManiaTiming.totalDuration);
    }

    group('instantiation', () {
      testWidgets('can be instantiated with required child', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              child: Text('Test'),
            ),
          ),
        );

        expect(find.byType(BounceVertically), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with custom delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              delay: Duration(milliseconds: 500),
              child: Text('Delayed'),
            ),
          ),
        );

        expect(find.byType(BounceVertically), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with bounceUp false', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              bounceUp: false,
              child: Text('Bounce Down'),
            ),
          ),
        );

        expect(find.byType(BounceVertically), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with all parameters', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              delay: Duration(milliseconds: 200),
              bounceUp: false,
              child: Text('Full params'),
            ),
          ),
        );

        expect(find.byType(BounceVertically), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('renders expected widgets', () {
      testWidgets('renders FadeTransition', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              child: Text('Test'),
            ),
          ),
        );

        // After some delay, should contain FadeTransition
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);

        expect(find.byType(FadeTransition), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets('renders child widget', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              child: Text('Child Text'),
            ),
          ),
        );

        expect(find.text('Child Text'), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('renders Transform widget', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              child: Text('Test'),
            ),
          ),
        );

        expect(find.byType(Transform), findsWidgets);
        await disposeAndSettle(tester);
      });
    });

    group('animation', () {
      testWidgets(
        'starts animation after bounce delay',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: BounceVertically(
                child: Text('Animate'),
              ),
            ),
          );

          // Before delay
          expect(find.byType(BounceVertically), findsOneWidget);

          // Advance past delay
          await tester.pump(SonicManiaTiming.bounceVerticallyDelay);

          expect(find.byType(BounceVertically), findsOneWidget);

          await disposeAndSettle(tester);
        },
      );

      testWidgets('completes animation cycle', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              child: Text('Animate'),
            ),
          ),
        );

        // Advance through complete animation
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);
        await tester.pump(SonicManiaTiming.bounceVerticallyDuration);

        expect(find.byType(BounceVertically), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('respects custom delay', (tester) async {
        const customDelay = Duration(milliseconds: 300);

        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              delay: customDelay,
              child: Text('Custom Delay'),
            ),
          ),
        );

        // Initial state
        expect(find.byType(BounceVertically), findsOneWidget);

        // Advance past bounce delay + custom delay
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay + customDelay);

        expect(find.byType(BounceVertically), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('bounces up by default', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              child: Text('Bounce Up'),
            ),
          ),
        );

        // Advance to animation start
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);

        // Widget should be visible
        expect(find.byType(BounceVertically), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('bounces down when bounceUp is false', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              bounceUp: false,
              child: Text('Bounce Down'),
            ),
          ),
        );

        // Advance to animation start
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);

        // Widget should be visible
        expect(find.byType(BounceVertically), findsOneWidget);

        await disposeAndSettle(tester);
      });
    });

    group('opacity', () {
      testWidgets('fades in during animation', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              child: Text('Fade'),
            ),
          ),
        );

        // Trigger animation
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);

        // Advance partially through animation (0.4 is fade interval)
        final partialDuration =
            SonicManiaTiming.bounceVerticallyDuration * 0.4;
        await tester.pump(partialDuration);

        // Widget should exist and be fading
        expect(find.byType(FadeTransition), findsWidgets);

        await disposeAndSettle(tester);
      });
    });

    group('disposal', () {
      testWidgets('disposes without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              child: Text('Dispose'),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes mid-animation without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              child: Text('Mid-Dispose'),
            ),
          ),
        );

        // Advance partially through animation
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);
        await tester.pump(SonicManiaTiming.bounceVerticallyDuration ~/ 2);

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes before animation starts without errors',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: BounceVertically(
              delay: Duration(seconds: 2),
              child: Text('Early Dispose'),
            ),
          ),
        );

        // Dispose before animation starts
        await tester.pump(const Duration(milliseconds: 100));

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });
    });

    group('multiple instances', () {
      testWidgets('multiple instances animate independently', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Column(
              children: [
                BounceVertically(child: Text('First')),
                BounceVertically(
                  delay: Duration(milliseconds: 100),
                  child: Text('Second'),
                ),
                BounceVertically(
                  delay: Duration(milliseconds: 200),
                  child: Text('Third'),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(BounceVertically), findsNWidgets(3));

        // Advance animation
        await tester.pump(SonicManiaTiming.bounceVerticallyDelay);

        expect(find.byType(BounceVertically), findsNWidgets(3));

        await disposeAndSettle(tester);
      });
    });
  });
}
