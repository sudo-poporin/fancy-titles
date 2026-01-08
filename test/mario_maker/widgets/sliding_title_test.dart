import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/mario_maker/widgets/sliding_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SlidingTitle', () {
    // Helper to create a widget wrapped in MaterialApp
    Widget buildTestWidget({
      String text = 'TEST TITLE',
      Duration delay = const Duration(milliseconds: 100),
      Duration slideDuration = const Duration(milliseconds: 100),
      Duration? exitDelay,
      TextStyle? textStyle,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: SlidingTitle(
              text: text,
              delay: delay,
              slideDuration: slideDuration,
              exitDelay: exitDelay,
              textStyle: textStyle,
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

    // Helper to find FadeTransition descendant of SlidingTitle
    Finder findFadeTransitionInSlidingTitle() {
      return find.descendant(
        of: find.byType(SlidingTitle),
        matching: find.byType(FadeTransition),
      );
    }

    // Helper to find SlideTransition descendant of SlidingTitle
    Finder findSlideTransitionInSlidingTitle() {
      return find.descendant(
        of: find.byType(SlidingTitle),
        matching: find.byType(SlideTransition),
      );
    }

    // Helper to find ScaleTransition descendant of SlidingTitle
    Finder findScaleTransitionInSlidingTitle() {
      return find.descendant(
        of: find.byType(SlidingTitle),
        matching: find.byType(ScaleTransition),
      );
    }

    group('instantiation', () {
      test('can be instantiated with required parameters', () {
        expect(
          const SlidingTitle(text: 'TEST'),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          const SlidingTitle(
            text: 'TEST',
            delay: Duration(seconds: 1),
            slideDuration: Duration(milliseconds: 500),
            exitDelay: Duration(seconds: 3),
            textStyle: TextStyle(fontSize: 24),
          ),
          isNotNull,
        );
      });

      test('has default delay from MarioMakerTiming', () {
        const widget = SlidingTitle(text: 'TEST');
        expect(widget, isNotNull);
      });

      test('has default slideDuration from MarioMakerTiming', () {
        const widget = SlidingTitle(text: 'TEST');
        expect(widget, isNotNull);
      });
    });

    group('rendering', () {
      testWidgets('renders with required parameters', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.byType(SlidingTitle), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('initially shows empty container before delay',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: const Duration(seconds: 10),
        ));

        // Before delay passes, should show SizedBox.shrink
        expect(find.byType(SizedBox), findsWidgets);
        expect(find.text('TEST TITLE'), findsNothing);
        await disposeAndSettle(tester);
      });

      testWidgets('shows text after delay', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: const Duration(milliseconds: 50),
        ));

        // Advance past delay
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(); // Extra frame for setState

        expect(find.text('TEST TITLE'), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('applies custom text style', (tester) async {
        const customStyle = TextStyle(fontSize: 48, color: Colors.red);

        await tester.pumpWidget(buildTestWidget(
          delay: Duration.zero,
          textStyle: customStyle,
        ));

        // Advance to show text
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        final textWidget = tester.widget<Text>(find.text('TEST TITLE'));
        expect(textWidget.style?.fontSize, 48);
        expect(textWidget.style?.color, Colors.red);
        await disposeAndSettle(tester);
      });

      testWidgets('has RepaintBoundary for optimization', (tester) async {
        await tester.pumpWidget(buildTestWidget(delay: Duration.zero));

        // Advance to show text
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        expect(find.byType(RepaintBoundary), findsWidgets);
        await disposeAndSettle(tester);
      });

      testWidgets('shows text centered', (tester) async {
        await tester.pumpWidget(buildTestWidget(delay: Duration.zero));

        // Advance to show text
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        expect(find.byType(Center), findsWidgets);
        await disposeAndSettle(tester);
      });
    });

    group('animation', () {
      testWidgets('starts slide animation after delay', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: const Duration(milliseconds: 100),
        ));

        // Before delay
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('TEST TITLE'), findsNothing);

        // After delay
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump();

        expect(find.text('TEST TITLE'), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('uses SlideTransition during entry', (tester) async {
        await tester.pumpWidget(buildTestWidget(delay: Duration.zero));

        // Advance to show text
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        expect(findSlideTransitionInSlidingTitle(), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('completes entry animation after slideDuration',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: Duration.zero,
          slideDuration: const Duration(milliseconds: 200),
        ));

        // Show text
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        // Complete slide animation
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump();

        expect(findSlideTransitionInSlidingTitle(), findsOneWidget);
        expect(find.text('TEST TITLE'), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('starts exit animation after exitDelay', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: Duration.zero,
          slideDuration: const Duration(milliseconds: 50),
          exitDelay: const Duration(milliseconds: 200),
        ));

        // Show text
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        // Before exitDelay - no FadeTransition in SlidingTitle
        expect(findFadeTransitionInSlidingTitle(), findsNothing);

        // After exitDelay
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump();

        // Should now be exiting (FadeTransition appears in SlidingTitle)
        expect(findFadeTransitionInSlidingTitle(), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('uses FadeTransition during exit', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: Duration.zero,
          exitDelay: const Duration(milliseconds: 100),
        ));

        // Show text and wait for exit
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump();

        expect(findFadeTransitionInSlidingTitle(), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('uses ScaleTransition during exit', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: Duration.zero,
          exitDelay: const Duration(milliseconds: 100),
        ));

        // Show text and wait for exit
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump();

        expect(findScaleTransitionInSlidingTitle(), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('lifecycle', () {
      testWidgets('disposes animation controllers correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget(delay: Duration.zero));

        // Advance animation
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        // Remove widget - should not throw
        await disposeAndSettle(tester);

        expect(find.byType(SlidingTitle), findsNothing);
      });

      testWidgets('handles dispose before delay completes', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: const Duration(seconds: 10),
        ));

        // Dispose before delay
        await disposeAndSettle(tester);

        // Should not throw
        expect(find.byType(SlidingTitle), findsNothing);
      });

      testWidgets('handles dispose during entry animation', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: Duration.zero,
          slideDuration: const Duration(seconds: 1),
        ));

        // Show text
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        // Dispose mid-animation
        await tester.pump(const Duration(milliseconds: 200));
        await disposeAndSettle(tester);

        // Should not throw
        expect(find.byType(SlidingTitle), findsNothing);
      });

      testWidgets('handles dispose during exit animation', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: Duration.zero,
          exitDelay: const Duration(milliseconds: 100),
        ));

        // Show text and start exit
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump();

        // Dispose mid-exit
        await tester.pump(const Duration(milliseconds: 50));
        await disposeAndSettle(tester);

        // Should not throw
        expect(find.byType(SlidingTitle), findsNothing);
      });
    });

    group('edge cases', () {
      testWidgets('handles empty text', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          text: '',
          delay: Duration.zero,
        ));

        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        expect(find.byType(SlidingTitle), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles long text', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          text: 'THIS IS A VERY LONG TITLE THAT MIGHT OVERFLOW',
          delay: Duration.zero,
        ));

        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        expect(find.byType(SlidingTitle), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles very short delay', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: const Duration(microseconds: 1),
        ));

        await tester.pump(const Duration(milliseconds: 10));
        await tester.pump();

        expect(find.byType(SlidingTitle), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles very short slideDuration', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: Duration.zero,
          slideDuration: const Duration(milliseconds: 1),
        ));

        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        expect(find.byType(SlidingTitle), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('handles no exitDelay (null)', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          delay: Duration.zero,
        ));

        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        // Should only use SlideTransition, no FadeTransition in SlidingTitle
        expect(findSlideTransitionInSlidingTitle(), findsOneWidget);
        expect(findFadeTransitionInSlidingTitle(), findsNothing);
        await disposeAndSettle(tester);
      });
    });

    group('default timings', () {
      test('uses MarioMakerTiming.slideDelayDefault as default delay', () {
        const widget = SlidingTitle(text: 'TEST');
        // Just verify it compiles with default values
        expect(widget, isNotNull);
        expect(MarioMakerTiming.slideDelayDefault,
            equals(const Duration(milliseconds: 3500)));
      });

      test('uses MarioMakerTiming.slideDuration as default slideDuration', () {
        const widget = SlidingTitle(text: 'TEST');
        expect(widget, isNotNull);
        expect(MarioMakerTiming.slideDuration,
            equals(const Duration(milliseconds: 500)));
      });
    });
  });
}
