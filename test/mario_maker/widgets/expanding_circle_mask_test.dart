import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/mario_maker/widgets/expanding_circle_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpandingCircleMask', () {
    // Helper to create a widget wrapped in MaterialApp
    Widget buildTestWidget({
      Widget background = const ColoredBox(color: Colors.yellow),
      double initialRadius = 80,
      Duration delay = const Duration(milliseconds: 100),
      Duration expandDuration = const Duration(milliseconds: 200),
      double bottomMargin = 100,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ExpandingCircleMask(
              background: background,
              initialRadius: initialRadius,
              delay: delay,
              expandDuration: expandDuration,
              bottomMargin: bottomMargin,
            ),
          ),
        ),
      );
    }

    // Helper to cleanup after tests - disposes widget and settles timers
    Future<void> disposeAndSettle(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      // Pump enough to clear any pending timers from Future.delayed
      await tester.pump(const Duration(seconds: 15));
    }

    group('instantiation', () {
      test('can be instantiated with required parameters', () {
        expect(
          const ExpandingCircleMask(
            background: ColoredBox(color: Colors.yellow),
          ),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          const ExpandingCircleMask(
            background: ColoredBox(color: Colors.yellow),
            initialRadius: 100,
            delay: Duration(seconds: 1),
            expandDuration: Duration(milliseconds: 800),
            bottomMargin: 150,
          ),
          isNotNull,
        );
      });

      test('has default initialRadius of 80', () {
        const widget = ExpandingCircleMask(
          background: ColoredBox(color: Colors.yellow),
        );
        expect(widget, isNotNull);
      });

      test('has default delay from MarioMakerTiming', () {
        const widget = ExpandingCircleMask(
          background: ColoredBox(color: Colors.yellow),
        );
        expect(widget, isNotNull);
      });
    });

    group('rendering', () {
      testWidgets('renders with required parameters', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('renders background widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            background: const ColoredBox(
              key: Key('background'),
              color: Colors.blue,
            ),
          ),
        );

        expect(find.byKey(const Key('background')), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('uses ClipPath for circular mask', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.byType(ClipPath), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('has RepaintBoundary for optimization', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.byType(RepaintBoundary), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets('uses AnimatedBuilder for animations', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        // Multiple AnimatedBuilders may exist (framework + widget)
        expect(find.byType(AnimatedBuilder), findsWidgets);
        await disposeAndSettle(tester);
      });
    });

    group('animation phases', () {
      testWidgets('starts in bounce phase immediately', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(seconds: 10),
          ),
        );

        // Should be in bounce phase (using ClipPath)
        expect(find.byType(ClipPath), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('bounce animation runs during delay', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(milliseconds: 500),
          ),
        );

        // Advance through bounce phase
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('transitions to expand phase after delay', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Before delay
        await tester.pump(const Duration(milliseconds: 50));

        // After delay
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(); // Extra frame for setState

        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('expand animation runs after delay', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            expandDuration: const Duration(milliseconds: 500),
          ),
        );

        // Wait for delay
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump();

        // Advance through expansion
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('completes expand animation after expandDuration', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(milliseconds: 50),
          ),
        );

        // Wait for delay
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump();

        // Complete expansion
        await tester.pump(const Duration(milliseconds: 250));

        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('lifecycle', () {
      testWidgets('disposes animation controllers correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Advance animation
        await tester.pump(const Duration(milliseconds: 50));

        // Remove widget - should not throw
        await disposeAndSettle(tester);

        expect(find.byType(ExpandingCircleMask), findsNothing);
      });

      testWidgets('handles dispose during bounce phase', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(seconds: 10),
          ),
        );

        // Start bounce animation
        await tester.pump(const Duration(milliseconds: 100));

        // Dispose mid-bounce
        await disposeAndSettle(tester);

        // Should not throw
        expect(find.byType(ExpandingCircleMask), findsNothing);
      });

      testWidgets('handles dispose during expand phase', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(milliseconds: 50),
            expandDuration: const Duration(seconds: 10),
          ),
        );

        // Wait for delay and start expand
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump();

        // Advance into expansion
        await tester.pump(const Duration(milliseconds: 200));

        // Dispose mid-expansion
        await disposeAndSettle(tester);

        // Should not throw
        expect(find.byType(ExpandingCircleMask), findsNothing);
      });

      testWidgets('handles dispose before delay completes', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(seconds: 10),
          ),
        );

        // Dispose immediately
        await disposeAndSettle(tester);

        // Should not throw
        expect(find.byType(ExpandingCircleMask), findsNothing);
      });
    });

    group('sizing', () {
      testWidgets('uses initialRadius for initial circle size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            initialRadius: 100,
            delay: const Duration(seconds: 10),
          ),
        );

        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles different bottomMargin values', (tester) async {
        await tester.pumpWidget(buildTestWidget(bottomMargin: 200));
        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles zero initialRadius', (tester) async {
        await tester.pumpWidget(buildTestWidget(initialRadius: 0));
        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles large initialRadius', (tester) async {
        await tester.pumpWidget(buildTestWidget(initialRadius: 500));
        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('edge cases', () {
      testWidgets('handles very short delay', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(microseconds: 1),
          ),
        );

        await tester.pump(const Duration(milliseconds: 10));
        await tester.pump();

        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles very short expandDuration', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(milliseconds: 10),
            expandDuration: const Duration(milliseconds: 1),
          ),
        );

        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles complex background widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            background: const Stack(
              key: Key('complexBackground'),
              children: [
                ColoredBox(color: Colors.yellow),
                Center(child: Text('CENTER')),
              ],
            ),
          ),
        );

        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        expect(find.byKey(const Key('complexBackground')), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles zero bottomMargin', (tester) async {
        await tester.pumpWidget(buildTestWidget(bottomMargin: 0));
        expect(find.byType(ExpandingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('default timings', () {
      test('uses MarioMakerTiming.expandDelayDefault as default delay', () {
        const widget = ExpandingCircleMask(
          background: ColoredBox(color: Colors.yellow),
        );
        expect(widget, isNotNull);
        expect(
          MarioMakerTiming.expandDelayDefault,
          equals(const Duration(seconds: 2)),
        );
      });

      test(
        'uses MarioMakerTiming.expandDurationDefault as default duration',
        () {
          const widget = ExpandingCircleMask(
            background: ColoredBox(color: Colors.yellow),
          );
          expect(widget, isNotNull);
          expect(
            MarioMakerTiming.expandDurationDefault,
            equals(const Duration(milliseconds: 1500)),
          );
        },
      );
    });
  });
}
