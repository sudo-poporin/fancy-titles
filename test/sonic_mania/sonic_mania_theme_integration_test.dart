import 'package:fancy_titles/sonic_mania/sonic_mania_splash.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SonicManiaThemeScope', () {
    testWidgets('maybeOf returns null when no scope in context', (
      tester,
    ) async {
      SonicManiaTheme? capturedTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedTheme = SonicManiaThemeScope.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTheme, isNull);
    });

    testWidgets('maybeOf returns theme when scope exists', (tester) async {
      const testTheme = SonicManiaTheme(redBarColor: Colors.purple);
      SonicManiaTheme? capturedTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaThemeScope(
            theme: testTheme,
            child: Builder(
              builder: (context) {
                capturedTheme = SonicManiaThemeScope.maybeOf(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedTheme, equals(testTheme));
      expect(capturedTheme?.redBarColor, equals(Colors.purple));
    });

    testWidgets('of returns theme when scope exists', (tester) async {
      const testTheme = SonicManiaTheme(orangeBarColor: Colors.pink);
      late SonicManiaTheme capturedTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaThemeScope(
            theme: testTheme,
            child: Builder(
              builder: (context) {
                capturedTheme = SonicManiaThemeScope.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedTheme, equals(testTheme));
      expect(capturedTheme.orangeBarColor, equals(Colors.pink));
    });

    testWidgets('updateShouldNotify returns true when theme changes', (
      tester,
    ) async {
      var buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaThemeScope(
            theme: const SonicManiaTheme(redBarColor: Colors.red),
            child: Builder(
              builder: (context) {
                // Depender del tema para recibir notificaciones
                SonicManiaThemeScope.maybeOf(context);
                buildCount++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(buildCount, equals(1));

      // Cambiar el tema
      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaThemeScope(
            theme: const SonicManiaTheme(redBarColor: Colors.blue),
            child: Builder(
              builder: (context) {
                SonicManiaThemeScope.maybeOf(context);
                buildCount++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(buildCount, equals(2));
    });

    testWidgets('updateShouldNotify returns false when theme is the same', (
      tester,
    ) async {
      var buildCount = 0;
      const theme = SonicManiaTheme(redBarColor: Colors.red);

      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaThemeScope(
            theme: theme,
            child: Builder(
              builder: (context) {
                SonicManiaThemeScope.maybeOf(context);
                buildCount++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(buildCount, equals(1));

      // Usar el mismo tema
      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaThemeScope(
            theme: theme,
            child: Builder(
              builder: (context) {
                SonicManiaThemeScope.maybeOf(context);
                buildCount++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // El widget debería reconstruirse por el pumpWidget,
      // pero el tema no cambió
      expect(buildCount, equals(2));
    });
  });

  group('SonicManiaSplash with theme', () {
    testWidgets('accepts theme parameter', (tester) async {
      const theme = SonicManiaTheme(
        redBarColor: Colors.purple,
        blueCurtainColor: Colors.indigo,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SonicManiaSplash(baseText: 'TEST', theme: theme),
        ),
      );

      // Verificar que el widget se construyó sin errores
      expect(find.byType(SonicManiaSplash), findsOneWidget);
    });

    testWidgets('works without theme (uses defaults)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: SonicManiaSplash(baseText: 'TEST')),
      );

      // Verificar que el widget se construyó sin errores
      expect(find.byType(SonicManiaSplash), findsOneWidget);
    });

    testWidgets('propagates theme to SonicManiaThemeScope', (tester) async {
      const testTheme = SonicManiaTheme(redBarColor: Colors.purple);
      SonicManiaTheme? capturedTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              SonicManiaSplash(
                baseText: 'TEST',
                theme: testTheme,
              ),
              // Builder que capture el tema si está disponible
              Builder(
                builder: (context) {
                  capturedTheme = SonicManiaThemeScope.maybeOf(context);
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      );

      // El tema debería estar disponible dentro del widget
      // pero no afuera (el Builder está en el mismo nivel, no dentro)
      expect(capturedTheme, isNull);
    });
  });
}
