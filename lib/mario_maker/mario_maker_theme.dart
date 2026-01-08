import 'package:fancy_titles/core/fancy_titles_theme.dart';
import 'package:flutter/material.dart';

/// Colores por defecto para Mario Maker.
class MarioMakerColors {
  const MarioMakerColors._();

  /// Color amarillo por defecto para el fondo expandido.
  static const Color yellow = Color(0xFFFFC800);

  /// Color negro por defecto para el fondo inicial.
  static const Color black = Color(0xFF000000);

  /// Color negro por defecto para el texto del título.
  static const Color titleText = Colors.black;

  /// Color transparente por defecto para el círculo.
  static const Color circleBackground = Colors.transparent;
}

/// Tema personalizable para `MarioMakerTitle`.
///
/// Permite personalizar todos los colores del widget sin necesidad
/// de modificar los widgets internos directamente.
///
/// ## Colores personalizables
///
/// ### Fondos
/// - [backgroundColor]: Color de fondo inicial (negro)
/// - [expandedBackgroundColor]: Color del fondo cuando se expande (amarillo)
///
/// ### Círculo
/// - [circleColor]: Color del círculo que rebota
///
/// ### Título
/// - [titleColor]: Color del texto del título
///
/// ## Ejemplo de uso
///
/// ```dart
/// MarioMakerTitle(
///   title: 'WORLD 1-1',
///   imagePath: 'assets/mario.gif',
///   theme: MarioMakerTheme(
///     expandedBackgroundColor: Colors.orange,
///     titleColor: Colors.white,
///   ),
/// )
/// ```
///
/// ## Tema con colores por defecto
///
/// ```dart
/// // Crear tema con valores por defecto
/// final theme = MarioMakerTheme.defaults();
///
/// // Copiar tema modificando solo algunos valores
/// final customTheme = theme.copyWith(
///   expandedBackgroundColor: Colors.amber,
/// );
/// ```
@immutable
class MarioMakerTheme extends FancyTitleTheme {
  /// Crea un tema personalizado para `MarioMakerTitle`.
  ///
  /// Todos los parámetros son opcionales. Los valores `null` indican
  /// que se debe usar el color por defecto definido en el widget.
  const MarioMakerTheme({
    this.backgroundColor,
    this.expandedBackgroundColor,
    this.circleColor,
    this.titleColor,
  });

  /// Crea un tema con todos los colores por defecto de Mario Maker.
  ///
  /// Este factory proporciona valores explícitos para todos los colores,
  /// a diferencia del constructor principal que usa `null` para indicar
  /// que se debe usar el color por defecto.
  factory MarioMakerTheme.defaults() => const MarioMakerTheme(
        backgroundColor: MarioMakerColors.black,
        expandedBackgroundColor: MarioMakerColors.yellow,
        circleColor: MarioMakerColors.circleBackground,
        titleColor: MarioMakerColors.titleText,
      );

  // --- Fondos ---

  /// Color de fondo inicial.
  ///
  /// Por defecto: `Color(0xFF000000)` (negro).
  final Color? backgroundColor;

  /// Color del fondo cuando se expande el círculo.
  ///
  /// Por defecto: `Color(0xFFFFC800)` (amarillo Mario Maker).
  final Color? expandedBackgroundColor;

  // --- Círculo ---

  /// Color de fondo del círculo que rebota.
  ///
  /// Por defecto: `Colors.transparent`.
  final Color? circleColor;

  // --- Título ---

  /// Color del texto del título.
  ///
  /// Por defecto: `Colors.black`.
  final Color? titleColor;

  /// Crea una copia de este tema con los valores especificados reemplazados.
  ///
  /// ```dart
  /// final theme = MarioMakerTheme(backgroundColor: Colors.black);
  /// final newTheme = theme.copyWith(expandedBackgroundColor: Colors.orange);
  /// // newTheme tiene backgroundColor=Colors.black y
  /// // expandedBackgroundColor=Colors.orange
  /// ```
  MarioMakerTheme copyWith({
    Color? backgroundColor,
    Color? expandedBackgroundColor,
    Color? circleColor,
    Color? titleColor,
  }) {
    return MarioMakerTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      expandedBackgroundColor:
          expandedBackgroundColor ?? this.expandedBackgroundColor,
      circleColor: circleColor ?? this.circleColor,
      titleColor: titleColor ?? this.titleColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarioMakerTheme &&
        other.backgroundColor == backgroundColor &&
        other.expandedBackgroundColor == expandedBackgroundColor &&
        other.circleColor == circleColor &&
        other.titleColor == titleColor;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        expandedBackgroundColor,
        circleColor,
        titleColor,
      );

  @override
  String toString() => 'MarioMakerTheme('
      'backgroundColor: $backgroundColor, '
      'expandedBackgroundColor: $expandedBackgroundColor, '
      'circleColor: $circleColor, '
      'titleColor: $titleColor'
      ')';
}
