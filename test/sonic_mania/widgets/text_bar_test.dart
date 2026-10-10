import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/sonic_mania/clippers/bar_clipper.dart';
import 'package:fancy_titles/sonic_mania/painters/text_bg_painters.dart';
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
      testWidgets('can be instantiated with required parameters', (
        tester,
      ) async {
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
          const MaterialApp(
            home: Scaffold(
              body: TextBar.black(
                text: 'BLACK TEXT',
                beginOffset: Offset(-2, 0),
                endOffset: Offset(2, 0),
                stopOffset: Offset(-0.2, 0),
                stopEndOffset: Offset(-2, 0),
              ),
            ),
          ),
        );

        expect(find.byType(TextBar), findsOneWidget);
        await disposeAndSettle(tester);
      });

      testWidgets('can be instantiated with TextBar.white', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar.white(
                text: 'WHITE TEXT',
                beginOffset: Offset(-2, 0),
                endOffset: Offset(2, 0),
                stopOffset: Offset(-0.2, 0),
                stopEndOffset: Offset(-2, 0),
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

    group('barra inclinada', () {
      T barPainter<T extends CustomPainter>(WidgetTester tester) => tester
          .widgetList<CustomPaint>(
            find.descendant(
              of: find.byType(TextBar),
              matching: find.byType(CustomPaint),
            ),
          )
          .map((paint) => paint.painter)
          .whereType<T>()
          .single;

      // El ticker arranca en el primer frame después de pumpWidget, así que
      // el forward termina en el segundo pump.
      Future<void> showText(WidgetTester tester) async {
        await tester.pump(SonicManiaTiming.slideIn);
        await tester.pump(SonicManiaTiming.slideIn);
        await tester.pump();
      }

      testWidgets('la negra toma la pendiente de las franjas y rota', (
        tester,
      ) async {
        addTearDown(tester.view.reset);
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(844, 390);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar.black(
                text: 'ROTA',
                beginOffset: Offset(-2, 0),
                endOffset: Offset(2, 0),
                stopOffset: Offset(-0.2, 0),
                stopEndOffset: Offset(-2, 0),
              ),
            ),
          ),
        );
        await showText(tester);

        expect(
          barPainter<LargeBGDraw>(tester).slope,
          closeTo(stripeSlope(const Size(844, 390)), 1e-9),
        );

        tester.view.physicalSize = const Size(390, 844);
        await tester.pump();

        expect(
          barPainter<LargeBGDraw>(tester).slope,
          closeTo(stripeSlope(const Size(390, 844)), 1e-9),
        );

        await disposeAndSettle(tester);
      });

      testWidgets('la blanca usa SmallBGDraw con su color', (tester) async {
        addTearDown(tester.view.reset);
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(390, 844);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar.white(
                text: 'BLANCA',
                color: Colors.pink,
                beginOffset: Offset(-2, 0),
                endOffset: Offset(2, 0),
                stopOffset: Offset(-0.2, 0),
                stopEndOffset: Offset(-2, 0),
              ),
            ),
          ),
        );
        await showText(tester);

        final painter = barPainter<SmallBGDraw>(tester);
        expect(painter.slope, closeTo(stripeSlope(const Size(390, 844)), 1e-9));
        expect(painter.painter.color.toARGB32(), Colors.pink.toARGB32());

        await disposeAndSettle(tester);
      });

      testWidgets('cambiar el color sin cambiar la pantalla repinta la barra', (
        tester,
      ) async {
        Widget bar(Color color) => MaterialApp(
          home: Scaffold(
            body: TextBar.black(
              text: 'COLOR',
              color: color,
              beginOffset: const Offset(-2, 0),
              endOffset: const Offset(2, 0),
              stopOffset: const Offset(-0.2, 0),
              stopEndOffset: const Offset(-2, 0),
            ),
          ),
        );

        await tester.pumpWidget(bar(Colors.red));
        await showText(tester);
        await tester.pumpWidget(bar(Colors.blue));

        expect(
          barPainter<LargeBGDraw>(tester).painter.color.toARGB32(),
          Colors.blue.toARGB32(),
        );

        await disposeAndSettle(tester);
      });

      testWidgets('la negra usa su color', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextBar.black(
                text: 'COLOR',
                color: Colors.teal,
                beginOffset: Offset(-2, 0),
                endOffset: Offset(2, 0),
                stopOffset: Offset(-0.2, 0),
                stopEndOffset: Offset(-2, 0),
              ),
            ),
          ),
        );
        await showText(tester);

        expect(
          barPainter<LargeBGDraw>(tester).painter.color.toARGB32(),
          Colors.teal.toARGB32(),
        );

        await disposeAndSettle(tester);
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

      testWidgets('disposes after text is shown without errors', (
        tester,
      ) async {
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
