import 'package:fancy_titles/core/fancy_titles_theme.dart';
import 'package:flutter/material.dart';

/// Colores por defecto para Persona 5.
class Persona5Colors {
  const Persona5Colors._();

  /// Color rojo por defecto para el fondo.
  static const Color red = Color(0xFFFF1518);

  /// Color negro por defecto para los círculos alternos.
  static const Color black = Colors.black;

  /// Color blanco por defecto para el stroke del texto.
  static const Color white = Colors.white;

  /// Color negro por defecto para el texto principal.
  static const Color textFill = Colors.black;
}

/// Tema personalizable para `Persona5Title`.
///
/// Permite personalizar todos los colores del widget sin necesidad
/// de modificar los widgets internos directamente.
///
/// ## Colores personalizables
///
/// ### Fondo
/// - [backgroundColor]: Color de fondo rojo principal
///
/// ### Círculos concéntricos (BackgroundCircle)
/// - [primaryCircleColor]: Círculos pares (por defecto rojo)
/// - [secondaryCircleColor]: Círculos impares (por defecto negro)
///
/// ### Texto (Persona5Text)
/// - [textStrokeColor]: Color del trazo/borde del texto
/// - [textFillColor]: Color de relleno del texto
///
/// ## Ejemplo de uso
///
/// ```dart
/// Persona5Title(
///   text: 'TAKE YOUR HEART',
///   theme: Persona5Theme(
///     backgroundColor: Colors.purple,
///     primaryCircleColor: Colors.deepPurple,
///     secondaryCircleColor: Colors.black87,
///   ),
/// )
/// ```
///
/// ## Tema con colores por defecto
///
/// ```dart
/// // Crear tema con valores por defecto
/// final theme = Persona5Theme.defaults();
///
/// // Copiar tema modificando solo algunos valores
/// final customTheme = theme.copyWith(
///   backgroundColor: Colors.deepOrange,
/// );
/// ```
@immutable
class Persona5Theme extends FancyTitleTheme {
  /// Crea un tema personalizado para `Persona5Title`.
  ///
  /// Todos los parámetros son opcionales. Los valores `null` indican
  /// que se debe usar el color por defecto definido en el widget.
  const Persona5Theme({
    this.backgroundColor,
    this.primaryCircleColor,
    this.secondaryCircleColor,
    this.textStrokeColor,
    this.textFillColor,
  });

  /// Crea un tema con todos los colores por defecto de Persona 5.
  ///
  /// Este factory proporciona valores explícitos para todos los colores,
  /// a diferencia del constructor principal que usa `null` para indicar
  /// que se debe usar el color por defecto.
  factory Persona5Theme.defaults() => const Persona5Theme(
        backgroundColor: Persona5Colors.red,
        primaryCircleColor: Persona5Colors.red,
        secondaryCircleColor: Persona5Colors.black,
        textStrokeColor: Persona5Colors.white,
        textFillColor: Persona5Colors.textFill,
      );

  // --- Fondo ---

  /// Color de fondo principal.
  ///
  /// Por defecto: `Color(0xFFFF1518)` (rojo Persona 5).
  final Color? backgroundColor;

  // --- Círculos concéntricos (BackgroundCircle) ---

  /// Color de los círculos pares (primarios).
  ///
  /// Por defecto: `Color(0xFFFF1518)` (rojo Persona 5).
  final Color? primaryCircleColor;

  /// Color de los círculos impares (secundarios).
  ///
  /// Por defecto: `Colors.black`.
  final Color? secondaryCircleColor;

  // --- Texto (Persona5Text) ---

  /// Color del trazo/borde del texto.
  ///
  /// Por defecto: `Colors.white`.
  final Color? textStrokeColor;

  /// Color de relleno del texto.
  ///
  /// Por defecto: `Colors.black`.
  final Color? textFillColor;

  /// Crea una copia de este tema con los valores especificados reemplazados.
  ///
  /// ```dart
  /// final theme = Persona5Theme(backgroundColor: Colors.red);
  /// final newTheme = theme.copyWith(primaryCircleColor: Colors.orange);
  /// // newTheme tiene backgroundColor=Colors.red y
  /// // primaryCircleColor=Colors.orange
  /// ```
  Persona5Theme copyWith({
    Color? backgroundColor,
    Color? primaryCircleColor,
    Color? secondaryCircleColor,
    Color? textStrokeColor,
    Color? textFillColor,
  }) {
    return Persona5Theme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      primaryCircleColor: primaryCircleColor ?? this.primaryCircleColor,
      secondaryCircleColor: secondaryCircleColor ?? this.secondaryCircleColor,
      textStrokeColor: textStrokeColor ?? this.textStrokeColor,
      textFillColor: textFillColor ?? this.textFillColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Persona5Theme &&
        other.backgroundColor == backgroundColor &&
        other.primaryCircleColor == primaryCircleColor &&
        other.secondaryCircleColor == secondaryCircleColor &&
        other.textStrokeColor == textStrokeColor &&
        other.textFillColor == textFillColor;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        primaryCircleColor,
        secondaryCircleColor,
        textStrokeColor,
        textFillColor,
      );

  @override
  String toString() => 'Persona5Theme('
      'backgroundColor: $backgroundColor, '
      'primaryCircleColor: $primaryCircleColor, '
      'secondaryCircleColor: $secondaryCircleColor, '
      'textStrokeColor: $textStrokeColor, '
      'textFillColor: $textFillColor'
      ')';
}
