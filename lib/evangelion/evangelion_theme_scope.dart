import 'package:fancy_titles/evangelion/evangelion_theme.dart';
import 'package:flutter/widgets.dart';

/// InheritedWidget que propaga el tema de Evangelion a los widgets hijos.
///
/// Este widget permite que los widgets internos de `EvangelionTitle`
/// accedan al tema personalizado sin necesidad de pasar parámetros
/// explícitamente a cada widget.
///
/// ## Uso interno
///
/// Este widget es usado internamente por `EvangelionTitle` para propagar
/// el tema. Los widgets internos como `Curtain`, `Spark`, etc.
/// pueden acceder al tema usando:
///
/// ```dart
/// final theme = EvangelionThemeScope.maybeOf(context);
/// final color = theme?.backgroundColor ?? EvangelionColors.background;
/// ```
///
/// ## Nota
///
/// Este es un widget de uso interno. Los usuarios del paquete deben
/// pasar el tema directamente al constructor de `EvangelionTitle`.
class EvangelionThemeScope extends InheritedWidget {
  /// Crea un scope de tema para Evangelion.
  const EvangelionThemeScope({
    required this.theme,
    required super.child,
    super.key,
  });

  /// El tema que se propaga a los widgets hijos.
  final EvangelionTheme theme;

  /// Obtiene el tema del contexto más cercano, o `null` si no hay ninguno.
  ///
  /// Usar este método cuando el tema es opcional y se tienen
  /// valores por defecto.
  ///
  /// ```dart
  /// final theme = EvangelionThemeScope.maybeOf(context);
  /// final color = theme?.backgroundColor ?? EvangelionColors.background;
  /// ```
  static EvangelionTheme? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<EvangelionThemeScope>();
    return scope?.theme;
  }

  /// Obtiene el tema del contexto más cercano.
  ///
  /// Lanza una excepción si no hay un [EvangelionThemeScope] ancestro.
  ///
  /// ```dart
  /// final theme = EvangelionThemeScope.of(context);
  /// final color = theme.backgroundColor;
  /// ```
  static EvangelionTheme of(BuildContext context) {
    final theme = maybeOf(context);
    assert(
      theme != null,
      'No EvangelionThemeScope found in context. '
      'Make sure to wrap the widget with EvangelionThemeScope.',
    );
    return theme!;
  }

  @override
  bool updateShouldNotify(EvangelionThemeScope oldWidget) {
    return theme != oldWidget.theme;
  }
}
