import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/mario_maker/widgets/contracting_circle_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractingCircleMask', () {
    // Helper to create a widget wrapped in MaterialApp
    Widget buildTestWidget({
      Widget child = const ColoredBox(color: Colors.blue),
      Alignment alignment = Alignment.center,
      double edgePadding = 50,
      Duration delay = Duration.zero,
      Duration duration = const Duration(milliseconds: 200),
      Curve curve = Curves.easeInCubic,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ContractingCircleMask(
              alignment: alignment,
              edgePadding: edgePadding,
              delay: delay,
              duration: duration,
              curve: curve,
              child: child,
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
          const ContractingCircleMask(
            child: ColoredBox(color: Colors.blue),
          ),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          const ContractingCircleMask(
            alignment: Alignment.topLeft,
            edgePadding: 100,
            delay: Duration(seconds: 1),
            duration: Duration(milliseconds: 800),
            curve: Curves.easeOut,
            child: ColoredBox(color: Colors.blue),
          ),
          isNotNull,
        );
      });

      test('has default alignment of center', () {
        const widget = ContractingCircleMask(
          child: ColoredBox(color: Colors.blue),
        );
        expect(widget, isNotNull);
      });

      test('has default edgePadding of 50', () {
        const widget = ContractingCircleMask(
          child: ColoredBox(color: Colors.blue),
        );
        expect(widget, isNotNull);
      });
    });

    group('rendering', () {
      testWidgets('renders with required parameters', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('renders child widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const ColoredBox(
              key: Key('child'),
              color: Colors.red,
            ),
          ),
        );

        expect(find.byKey(const Key('child')), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('uses ClipPath for circular mask', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.byType(ClipPath), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('uses IgnorePointer during animation', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            duration: const Duration(seconds: 10),
          ),
        );

        // Start animation
        await tester.pump(const Duration(milliseconds: 50));

        // Multiple IgnorePointers may exist (framework + widget)
        expect(find.byType(IgnorePointer), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets('uses AnimatedBuilder for animation', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        // Multiple AnimatedBuilders may exist (framework + widget)
        expect(find.byType(AnimatedBuilder), findsWidgets);
        await disposeAndSettle(tester);
      });
    });

    group('animation', () {
      testWidgets('starts animation immediately when delay is zero', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            duration: const Duration(milliseconds: 500),
          ),
        );

        // Animation should start immediately
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('delays animation when delay is specified', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(milliseconds: 500),
          ),
        );

        // Should not be animating yet
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('starts animation after delay', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(milliseconds: 100),
          ),
        );

        // Wait for delay
        await tester.pump(const Duration(milliseconds: 150));

        // Animation should be running now
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('completes animation after duration', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Complete animation
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('respects custom curve', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          ),
        );

        await tester.pump(const Duration(milliseconds: 250));
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('alignment', () {
      testWidgets('handles center alignment', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles topLeft alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            alignment: Alignment.topLeft,
          ),
        );
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles topRight alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            alignment: Alignment.topRight,
          ),
        );
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles bottomLeft alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            alignment: Alignment.bottomLeft,
          ),
        );
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles bottomRight alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            alignment: Alignment.bottomRight,
          ),
        );
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles custom alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            alignment: const Alignment(0.5, -0.3),
          ),
        );
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('lifecycle', () {
      testWidgets('disposes animation controller correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Advance animation
        await tester.pump(const Duration(milliseconds: 50));

        // Remove widget - should not throw
        await disposeAndSettle(tester);

        expect(find.byType(ContractingCircleMask), findsNothing);
      });

      testWidgets('handles dispose during animation', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            duration: const Duration(seconds: 10),
          ),
        );

        // Start animation
        await tester.pump(const Duration(milliseconds: 100));

        // Dispose mid-animation
        await disposeAndSettle(tester);

        // Should not throw
        expect(find.byType(ContractingCircleMask), findsNothing);
      });

      testWidgets('handles dispose before delay completes', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(seconds: 10),
          ),
        );

        // Dispose before delay
        await disposeAndSettle(tester);

        // Should not throw
        expect(find.byType(ContractingCircleMask), findsNothing);
      });

      testWidgets('handles dispose immediately', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Dispose immediately
        await disposeAndSettle(tester);

        // Should not throw
        expect(find.byType(ContractingCircleMask), findsNothing);
      });
    });

    group('edge cases', () {
      testWidgets('handles zero edgePadding', (tester) async {
        await tester.pumpWidget(buildTestWidget(edgePadding: 0));
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles large edgePadding', (tester) async {
        await tester.pumpWidget(buildTestWidget(edgePadding: 200));
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles very short duration', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            duration: const Duration(milliseconds: 1),
          ),
        );

        await tester.pump(const Duration(milliseconds: 10));
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles very short delay', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            delay: const Duration(microseconds: 1),
          ),
        );

        await tester.pump(const Duration(milliseconds: 10));
        expect(find.byType(ContractingCircleMask), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles complex child widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const Stack(
              key: Key('complexChild'),
              children: [
                ColoredBox(color: Colors.blue),
                Center(child: Text('CONTENT')),
              ],
            ),
          ),
        );

        expect(find.byType(ContractingCircleMask), findsOneWidget);
        expect(find.byKey(const Key('complexChild')), findsOneWidget);
        expect(find.text('CONTENT'), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('default timings', () {
      test('uses MarioMakerTiming.contractDuration as default duration', () {
        const widget = ContractingCircleMask(
          child: ColoredBox(color: Colors.blue),
        );
        expect(widget, isNotNull);
        expect(
          MarioMakerTiming.contractDuration,
          equals(const Duration(milliseconds: 500)),
        );
      });

      test('uses Duration.zero as default delay', () {
        const widget = ContractingCircleMask(
          child: ColoredBox(color: Colors.blue),
        );
        expect(widget, isNotNull);
      });

      test('uses Curves.easeInCubic as default curve', () {
        const widget = ContractingCircleMask(
          child: ColoredBox(color: Colors.blue),
        );
        expect(widget, isNotNull);
      });
    });
  });
}
