import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/sonic_mania/widgets/text_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextBar', () {
    /// Helper to dispose widget and settle all animations
    Future<void> disposeAndSettle(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(SonicManiaTiming.totalDuration);
    }

    group('instantiation', () {
      testWidgets('can be instantiated with required parameters',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'TEST',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with TextBar.black', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextBar.black(
                text: 'BLACK TEXT',
                beginOffset: const Offset(-2, 0),
                endOffset: const Offset(2, 0),
                stopOffset: const Offset(-0.2, 0),
                stopEndOffset: const Offset(-2, 0),
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with TextBar.white', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextBar.white(
                text: 'WHITE TEXT',
                beginOffset: const Offset(-2, 0),
                endOffset: const Offset(2, 0),
                stopOffset: const Offset(-0.2, 0),
                stopEndOffset: const Offset(-2, 0),
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('accepts custom offsets', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.red,
                text: 'CUSTOM',
                textColor: Colors.white,
                beginOffset: Offset(-3, 0),
                endOffset: Offset(3, 0),
                stopOffset: Offset(-0.5, 0),
                stopEndOffset: Offset(-3, 0),
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('accepts custom text border color', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'BORDERED',
                textColor: Colors.white,
                textBorderColor: Colors.black,
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('accepts bounceUp parameter', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'BOUNCE',
                textColor: Colors.white,
                bounceUp: false,
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('accepts isWhite parameter', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.white,
                text: 'WHITE',
                textColor: Colors.black,
                isWhite: true,
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);
        await disposeAndSettle(tester);
      });
    });

    group('animation', () {
      testWidgets('starts animation on mount', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'ANIMATE',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        // Widget should be present
        expect(find.byType(TextBar), findsOneWidget);

        // Advance animation slightly
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(TextBar), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('shows colored box initially', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'TEST',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        // Initially should show ColoredBox (bar)
        expect(find.byType(ColoredBox), findsWidgets);

        await disposeAndSettle(tester);
      });

      testWidgets('transitions to show text after slide in', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'TRANSITION',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        // Advance through slide in animation (600ms * 2 for forward + reverse)
        await tester.pump(SonicManiaTiming.slideIn);
        await tester.pump(SonicManiaTiming.slideIn);

        // Widget should still exist
        expect(find.byType(TextBar), findsOneWidget);

        await disposeAndSettle(tester);
      });

      testWidgets('handles slide out after delay', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'SLIDEOUT',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        // Advance past slide in + slide out delay
        await tester.pump(SonicManiaTiming.slideIn * 2);
        await tester.pump(SonicManiaTiming.slideOutDelay);

        expect(find.byType(TextBar), findsOneWidget);

        await disposeAndSettle(tester);
      });
    });

    group('orientation handling', () {
      testWidgets('handles portrait orientation', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'PORTRAIT',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);

        await disposeAndSettle(tester);
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('handles landscape orientation', (tester) async {
        tester.view.physicalSize = const Size(800, 400);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'LANDSCAPE',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);

        await disposeAndSettle(tester);
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('disposal', () {
      testWidgets('disposes without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'DISPOSE',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes mid-animation without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'MID-DISPOSE',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        // Advance partially through animation
        await tester.pump(const Duration(milliseconds: 300));

        // Dispose widget
        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('disposes after text is shown without errors',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar(
                color: Colors.blue,
                text: 'LATE-DISPOSE',
                textColor: Colors.white,
              ),
            ),
          ),
        );

        // Advance to text shown phase
        await tester.pump(SonicManiaTiming.slideIn * 2);
        await tester.pump(const Duration(milliseconds: 100));

        // Dispose widget
        await disposeAndSettle(tester);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
