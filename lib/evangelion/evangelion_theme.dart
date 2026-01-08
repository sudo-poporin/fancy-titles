import 'package:fancy_titles/core/fancy_titles_theme.dart';
import 'package:flutter/material.dart';

/// Colores por defecto para Evangelion.
class EvangelionColors {
  const EvangelionColors._();

  /// Color negro por defecto para el fondo.
  static const Color background = Color(0xFF040404);

  /// Color blanco-lavanda por defecto para el texto.
  static const Color text = Color(0xFFF1EEFF);

  /// Color de sombra por defecto para el texto.
  static const Color textShadow = Color.fromARGB(255, 67, 48, 35);

  /// Color negro por defecto para la primera cortina.
  static const Color curtainFirst = Colors.black;
}

/// Tema personalizable para `EvangelionTitle`.
///
/// Permite personalizar todos los colores del widget sin necesidad
/// de modificar los widgets internos directamente.
///
/// ## Colores personalizables
///
/// ### Fondo
/// - [backgroundColor]: Color de fondo (por defecto negro casi puro)
///
/// ### Texto
/// - [textColor]: Color del texto principal
/// - [textShadowColor]: Color de las sombras del texto
///
/// ### Cortinas
/// - [curtainFirstColor]: Color de la primera cortina (fondo negro con fade)
///
/// ## Ejemplo de uso
///
/// ```dart
/// EvangelionTitle(
///   firstText: 'NEON',
///   secondText: 'GENESIS',
///   thirdText: 'EVANGELION',
///   theme: EvangelionTheme(
///     backgroundColor: Colors.deepPurple.shade900,
///     textColor: Colors.amber,
///   ),
/// )
/// ```
///
/// ## Tema con colores por defecto
///
/// ```dart
/// // Crear tema con valores por defecto
/// final theme = EvangelionTheme.defaults();
///
/// // Copiar tema modificando solo algunos valores
/// final customTheme = theme.copyWith(
///   textColor: Colors.orange,
/// );
/// ```
@immutable
class EvangelionTheme extends FancyTitleTheme {
  /// Crea un tema personalizado para `EvangelionTitle`.
  ///
  /// Todos los parámetros son opcionales. Los valores `null` indican
  /// que se debe usar el color por defecto definido en el widget.
  const EvangelionTheme({
    this.backgroundColor,
    this.textColor,
    this.textShadowColor,
    this.curtainFirstColor,
  });

  /// Crea un tema con todos los colores por defecto de Evangelion.
  ///
  /// Este factory proporciona valores explícitos para todos los colores,
  /// a diferencia del constructor principal que usa `null` para indicar
  /// que se debe usar el color por defecto.
  factory EvangelionTheme.defaults() => const EvangelionTheme(
        backgroundColor: EvangelionColors.background,
        textColor: EvangelionColors.text,
        textShadowColor: EvangelionColors.textShadow,
        curtainFirstColor: EvangelionColors.curtainFirst,
      );

  // --- Fondo ---

  /// Color de fondo principal.
  ///
  /// Por defecto: `Color(0xFF040404)` (negro casi puro).
  final Color? backgroundColor;

  // --- Texto ---

  /// Color del texto principal.
  ///
  /// Por defecto: `Color(0xFFF1EEFF)` (blanco-lavanda).
  final Color? textColor;

  /// Color de las sombras del texto.
  ///
  /// Por defecto: `Color.fromARGB(255, 67, 48, 35)` (marrón oscuro).
  final Color? textShadowColor;

  // --- Cortinas ---

  /// Color de la primera cortina (fade in/out).
  ///
  /// Por defecto: `Colors.black`.
  final Color? curtainFirstColor;

  /// Crea una copia de este tema con los valores especificados reemplazados.
  ///
  /// ```dart
  /// final theme = EvangelionTheme(backgroundColor: Colors.black);
  /// final newTheme = theme.copyWith(textColor: Colors.red);
  /// // newTheme tiene backgroundColor=Colors.black y textColor=Colors.red
  /// ```
  EvangelionTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? textShadowColor,
    Color? curtainFirstColor,
  }) {
    return EvangelionTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      textShadowColor: textShadowColor ?? this.textShadowColor,
      curtainFirstColor: curtainFirstColor ?? this.curtainFirstColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EvangelionTheme &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor &&
        other.textShadowColor == textShadowColor &&
        other.curtainFirstColor == curtainFirstColor;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        textColor,
        textShadowColor,
        curtainFirstColor,
      );

  @override
  String toString() => 'EvangelionTheme('
      'backgroundColor: $backgroundColor, '
      'textColor: $textColor, '
      'textShadowColor: $textShadowColor, '
      'curtainFirstColor: $curtainFirstColor'
      ')';
}
