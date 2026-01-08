import 'package:fancy_titles/persona_5/persona_5_theme.dart';
import 'package:flutter/widgets.dart';

/// InheritedWidget que propaga el tema de Persona 5 a los widgets hijos.
///
/// Este widget permite que los widgets internos de `Persona5Title`
/// accedan al tema personalizado sin necesidad de pasar parámetros
/// explícitamente a cada widget.
///
/// ## Uso interno
///
/// Este widget es usado internamente por `Persona5Title` para propagar
/// el tema. Los widgets internos como `BackgroundCircle`, `Persona5Text`, etc.
/// pueden acceder al tema usando:
///
/// ```dart
/// final theme = Persona5ThemeScope.maybeOf(context);
/// final color = theme?.backgroundColor ?? Persona5Colors.red;
/// ```
///
/// ## Nota
///
/// Este es un widget de uso interno. Los usuarios del paquete deben
/// pasar el tema directamente al constructor de `Persona5Title`.
class Persona5ThemeScope extends InheritedWidget {
  /// Crea un scope de tema para Persona 5.
  const Persona5ThemeScope({
    required this.theme,
    required super.child,
    super.key,
  });

  /// El tema que se propaga a los widgets hijos.
  final Persona5Theme theme;

  /// Obtiene el tema del contexto más cercano, o `null` si no hay ninguno.
  ///
  /// Usar este método cuando el tema es opcional y se tienen
  /// valores por defecto.
  ///
  /// ```dart
  /// final theme = Persona5ThemeScope.maybeOf(context);
  /// final color = theme?.backgroundColor ?? Persona5Colors.red;
  /// ```
  static Persona5Theme? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<Persona5ThemeScope>();
    return scope?.theme;
  }

  /// Obtiene el tema del contexto más cercano.
  ///
  /// Lanza una excepción si no hay un [Persona5ThemeScope] ancestro.
  ///
  /// ```dart
  /// final theme = Persona5ThemeScope.of(context);
  /// final color = theme.backgroundColor;
  /// ```
  static Persona5Theme of(BuildContext context) {
    final theme = maybeOf(context);
    assert(
      theme != null,
      'No Persona5ThemeScope found in context. '
      'Make sure to wrap the widget with Persona5ThemeScope.',
    );
    return theme!;
  }

  @override
  bool updateShouldNotify(Persona5ThemeScope oldWidget) {
    return theme != oldWidget.theme;
  }
}
