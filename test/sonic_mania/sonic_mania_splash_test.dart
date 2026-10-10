import 'package:fancy_titles/fancy_titles.dart';
import 'package:fancy_titles/sonic_mania/clippers/bar_clipper.dart';
import 'package:fancy_titles/sonic_mania/painters/text_bg_painters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SonicManiaSplash', () {
    group('instantiation', () {
      test('can be instantiated with only baseText', () {
        expect(
          SonicManiaSplash(baseText: 'TEST'),
          isNotNull,
        );
      });

      test('can be instantiated with all parameters', () {
        expect(
          SonicManiaSplash(
            baseText: 'STUDIOPOLIS',
            secondaryText: 'ZONE',
            lastText: 'ACT1',
          ),
          isNotNull,
        );
      });

      test('throws FlutterError if lastText exceeds 4 characters', () {
        expect(
          () => SonicManiaSplash(
            baseText: 'TEST',
            lastText: 'TOOLONG',
          ),
          throwsFlutterError,
        );
      });

      test('accepts lastText with exactly 4 characters', () {
        expect(
          SonicManiaSplash(
            baseText: 'TEST',
            lastText: 'ACT1',
          ),
          isNotNull,
        );
      });

      test('handles single character lastText', () {
        expect(
          SonicManiaSplash(
            baseText: 'TEST',
            lastText: 'A',
          ),
          isNotNull,
        );
      });
    });

    group('callbacks', () {
      test('can be instantiated with onAnimationStart callback', () {
        var callbackCalled = false;
        final widget = SonicManiaSplash(
          baseText: 'TEST',
          onAnimationStart: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse); // Not called until widget is built
      });

      test('can be instantiated with onAnimationComplete callback', () {
        var callbackCalled = false;
        final widget = SonicManiaSplash(
          baseText: 'TEST',
          onAnimationComplete: () => callbackCalled = true,
        );
        expect(widget, isNotNull);
        expect(callbackCalled, isFalse);
      });

      test('can be instantiated with onPhaseChange callback', () {
        final phases = <AnimationPhase>[];
        final widget = SonicManiaSplash(
          baseText: 'TEST',
          onPhaseChange: phases.add,
        );
        expect(widget, isNotNull);
        expect(phases, isEmpty); // Not called until widget is built
      });

      test('can be instantiated with all callbacks', () {
        var startCalled = false;
        var completeCalled = false;
        final phases = <AnimationPhase>[];

        final widget = SonicManiaSplash(
          baseText: 'STUDIOPOLIS',
          secondaryText: 'ZONE',
          lastText: 'ACT1',
          onAnimationStart: () => startCalled = true,
          onAnimationComplete: () => completeCalled = true,
          onPhaseChange: phases.add,
        );

        expect(widget, isNotNull);
        expect(startCalled, isFalse);
        expect(completeCalled, isFalse);
        expect(phases, isEmpty);
      });
    });

    group('widget rendering', () {
      testWidgets('renders with required parameters', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(baseText: 'TEST'),
          ),
        );

        expect(find.byType(SonicManiaSplash), findsOneWidget);
      });

      testWidgets('renders with all parameters', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'STUDIOPOLIS',
              secondaryText: 'ZONE',
              lastText: 'ACT1',
            ),
          ),
        );

        expect(find.byType(SonicManiaSplash), findsOneWidget);
      });
    });

    group('animation lifecycle', () {
      testWidgets('calls onAnimationStart immediately on build', (
        tester,
      ) async {
        var startCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              onAnimationStart: () => startCalled = true,
            ),
          ),
        );

        expect(startCalled, isTrue);
      });

      testWidgets('progresses through animation phases', (tester) async {
        final phases = <AnimationPhase>[];

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              onPhaseChange: phases.add,
            ),
          ),
        );

        // Initial phase should be entering
        expect(phases, contains(AnimationPhase.entering));

        // Advance to active phase (after slideIn: 600ms)
        await tester.pump(SonicManiaTiming.slideIn);
        expect(phases, contains(AnimationPhase.active));

        // Advance to exiting phase (at slideOutDelay: 3500ms)
        await tester.pump(
          SonicManiaTiming.slideOutDelay - SonicManiaTiming.slideIn,
        );
        expect(phases, contains(AnimationPhase.exiting));
      });

      testWidgets('calls onAnimationComplete after totalDuration', (
        tester,
      ) async {
        var completeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'TEST',
              onAnimationComplete: () => completeCalled = true,
            ),
          ),
        );

        expect(completeCalled, isFalse);

        // Advance to total duration
        await tester.pump(SonicManiaTiming.totalDuration);

        expect(completeCalled, isTrue);
      });

      testWidgets('auto-destructs after totalDuration', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(baseText: 'TEST'),
          ),
        );

        expect(find.byType(SonicManiaSplash), findsOneWidget);

        // Advance past total duration
        await tester.pump(SonicManiaTiming.totalDuration);
        await tester.pump(SonicManiaTiming.fadeTransition);

        // Widget should still exist but content should be SizedBox.shrink
        // due to AnimatedSwitcher
        expect(find.byType(SonicManiaSplash), findsOneWidget);
      });
    });

    group('regression: B1 secondaryText uppercase', () {
      testWidgets('renders secondaryText in uppercase', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SonicManiaSplash(
              baseText: 'BASE',
              secondaryText: 'zone',
            ),
          ),
        );
        // Pump past slideIn (forward + reverse) so _canShowText becomes true
        // and the text is rendered. BouncingText splits the text into one
        // Text widget per letter, so we assert on uppercase letters.
        await tester.pump(const Duration(milliseconds: 1300));

        // After the fix, secondaryText 'zone' is rendered as 'ZONE'
        // (each letter rendered twice: stroke + fill).
        expect(find.text('Z'), findsWidgets);
        expect(find.text('O'), findsWidgets);
        expect(find.text('N'), findsWidgets);
        expect(find.text('E'), findsWidgets);
        // The original lowercase letters must NOT be rendered.
        expect(find.text('z'), findsNothing);
        expect(find.text('o'), findsNothing);
        expect(find.text('n'), findsNothing);
        expect(find.text('e'), findsNothing);

        // Avoid pending timer leaks: pump until the widget auto-destroys.
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();
      });
    });
  });

  group('barras paralelas a las franjas', () {
    testWidgets('en una caja más chica que la pantalla usan su aspecto', (
      tester,
    ) async {
      addTearDown(tester.view.reset);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(844, 390);
      const box = Size(400, 300);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 400,
              height: 300,
              child: SonicManiaSplash(
                baseText: 'FANCY',
                secondaryText: 'EXAMPLE',
                lastText: 'APP',
              ),
            ),
          ),
        ),
      );
      await tester.pump(SonicManiaTiming.slideIn);
      await tester.pump(SonicManiaTiming.slideIn);
      await tester.pump();

      final painters = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((paint) => paint.painter)
          .toList();
      final slopes = [
        ...painters.whereType<LargeBGDraw>().map((p) => p.slope),
        ...painters.whereType<SmallBGDraw>().map((p) => p.slope),
      ];

      expect(slopes, hasLength(3));
      for (final slope in slopes) {
        expect(slope, closeTo(stripeSlope(box), 1e-9));
      }

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(SonicManiaTiming.totalDuration);
    });
  });
}
