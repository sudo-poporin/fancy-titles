import 'package:fancy_titles/sonic_mania/sonic_mania_theme.dart';
import 'package:flutter/widgets.dart';

/// InheritedWidget que propaga el tema de Sonic Mania a los widgets hijos.
///
/// Este widget permite que los widgets internos de `SonicManiaSplash`
/// accedan al tema personalizado sin necesidad de pasar parámetros
/// explícitamente a cada widget.
///
/// ## Uso interno
///
/// Este widget es usado internamente por `SonicManiaSplash` para propagar
/// el tema. Los widgets internos como `ClippedBar`, `Curtain`, etc.
/// pueden acceder al tema usando:
///
/// ```dart
/// final theme = SonicManiaThemeScope.maybeOf(context);
/// final color = theme?.redBarColor ?? SonicManiaBarColors.red;
/// ```
///
/// ## Nota
///
/// Este es un widget de uso interno. Los usuarios del paquete deben
/// pasar el tema directamente al constructor de `SonicManiaSplash`.
class SonicManiaThemeScope extends InheritedWidget {
  /// Crea un scope de tema para Sonic Mania.
  const SonicManiaThemeScope({
    required this.theme,
    required super.child,
    super.key,
  });

  /// El tema que se propaga a los widgets hijos.
  final SonicManiaTheme theme;

  /// Obtiene el tema del contexto más cercano, o `null` si no hay ninguno.
  ///
  /// Usar este método cuando el tema es opcional y se tienen
  /// valores por defecto.
  ///
  /// ```dart
  /// final theme = SonicManiaThemeScope.maybeOf(context);
  /// final color = theme?.redBarColor ?? SonicManiaBarColors.red;
  /// ```
  static SonicManiaTheme? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SonicManiaThemeScope>();
    return scope?.theme;
  }

  /// Obtiene el tema del contexto más cercano.
  ///
  /// Lanza una excepción si no hay un [SonicManiaThemeScope] ancestro.
  ///
  /// ```dart
  /// final theme = SonicManiaThemeScope.of(context);
  /// final color = theme.redBarColor;
  /// ```
  static SonicManiaTheme of(BuildContext context) {
    final theme = maybeOf(context);
    assert(
      theme != null,
      'No SonicManiaThemeScope found in context. '
      'Make sure to wrap the widget with SonicManiaThemeScope.',
    );
    return theme!;
  }

  @override
  bool updateShouldNotify(SonicManiaThemeScope oldWidget) {
    return theme != oldWidget.theme;
  }
}
