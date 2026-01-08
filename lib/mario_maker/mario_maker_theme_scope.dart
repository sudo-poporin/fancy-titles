import 'package:fancy_titles/mario_maker/mario_maker_theme.dart';
import 'package:flutter/widgets.dart';

/// InheritedWidget que propaga el tema de Mario Maker a los widgets hijos.
///
/// Este widget permite que los widgets internos de `MarioMakerTitle`
/// accedan al tema personalizado sin necesidad de pasar parámetros
/// explícitamente a cada widget.
///
/// ## Uso interno
///
/// Este widget es usado internamente por `MarioMakerTitle` para propagar
/// el tema. Los widgets internos como `BouncingCircle`, `SlidingTitle`, etc.
/// pueden acceder al tema usando:
///
/// ```dart
/// final theme = MarioMakerThemeScope.maybeOf(context);
/// final color = theme?.backgroundColor ?? MarioMakerColors.black;
/// ```
///
/// ## Nota
///
/// Este es un widget de uso interno. Los usuarios del paquete deben
/// pasar el tema directamente al constructor de `MarioMakerTitle`.
class MarioMakerThemeScope extends InheritedWidget {
  /// Crea un scope de tema para Mario Maker.
  const MarioMakerThemeScope({
    required this.theme,
    required super.child,
    super.key,
  });

  /// El tema que se propaga a los widgets hijos.
  final MarioMakerTheme theme;

  /// Obtiene el tema del contexto más cercano, o `null` si no hay ninguno.
  ///
  /// Usar este método cuando el tema es opcional y se tienen
  /// valores por defecto.
  ///
  /// ```dart
  /// final theme = MarioMakerThemeScope.maybeOf(context);
  /// final color = theme?.backgroundColor ?? MarioMakerColors.black;
  /// ```
  static MarioMakerTheme? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<MarioMakerThemeScope>();
    return scope?.theme;
  }

  /// Obtiene el tema del contexto más cercano.
  ///
  /// Lanza una excepción si no hay un [MarioMakerThemeScope] ancestro.
  ///
  /// ```dart
  /// final theme = MarioMakerThemeScope.of(context);
  /// final color = theme.backgroundColor;
  /// ```
  static MarioMakerTheme of(BuildContext context) {
    final theme = maybeOf(context);
    assert(
      theme != null,
      'No MarioMakerThemeScope found in context. '
      'Make sure to wrap the widget with MarioMakerThemeScope.',
    );
    return theme!;
  }

  @override
  bool updateShouldNotify(MarioMakerThemeScope oldWidget) {
    return theme != oldWidget.theme;
  }
}
