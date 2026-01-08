import 'package:fancy_titles/core/fancy_titles_theme.dart';
import 'package:flutter/material.dart';

/// Colores por defecto para las barras clippeadas.
class SonicManiaBarColors {
  const SonicManiaBarColors._();

  /// Color rojo por defecto para la barra roja.
  static const Color red = Color(0xFFD15529);

  /// Color naranja por defecto para la barra naranja.
  static const Color orange = Color(0xFFFB9B0F);

  /// Color azul por defecto para la barra azul.
  static const Color blue = Color(0xFF456EBD);

  /// Color verde por defecto para la barra verde.
  static const Color green = Color(0xFF4E9B89);
}

/// Colores por defecto para las cortinas.
class SonicManiaCurtainColors {
  const SonicManiaCurtainColors._();

  /// Color azul por defecto para la cortina azul.
  static const Color blue = Color(0xFF3D62AA);

  /// Color naranja por defecto para la cortina naranja.
  static const Color orange = Color(0xFFFE6933);

  /// Color ámbar por defecto para la cortina ámbar.
  static const Color amber = Color(0xFFCA7C0B);

  /// Color verde por defecto para la cortina verde.
  static const Color green = Color(0xFF5DB4A1);

  /// Color amarillo por defecto para la cortina amarilla.
  static const Color yellow = Color(0xFFF7C700);

  /// Color negro por defecto para la cortina negra.
  static const Color black = Color(0xFF040404);
}

/// Colores por defecto para las barras de texto.
class SonicManiaTextBarColors {
  const SonicManiaTextBarColors._();

  /// Color negro por defecto para el fondo de la barra de texto negra.
  static const Color blackBackground = Color(0xFF212121);

  /// Color blanco por defecto para el texto sobre fondo negro.
  static const Color whiteText = Color(0xFFF3F3F3);

  /// Color blanco por defecto para el fondo de la barra de texto blanca.
  static const Color whiteBackground = Color(0xFFF3F3F3);

  /// Color negro por defecto para el texto sobre fondo blanco.
  static const Color blackText = Color(0xFF212121);
}

/// Tema personalizable para `SonicManiaSplash`.
///
/// Permite personalizar todos los colores del widget sin necesidad
/// de modificar los widgets internos directamente.
///
/// ## Colores personalizables
///
/// ### Barras (ClippedBar)
/// - [redBarColor]: Barra roja diagonal
/// - [orangeBarColor]: Barra naranja diagonal
/// - [blueBarColor]: Barra azul diagonal
/// - [greenBarColor]: Barra verde diagonal
///
/// ### Cortinas (Curtain)
/// - [blueCurtainColor]: Cortina azul central
/// - [orangeCurtainColor]: Cortina naranja central
/// - [amberCurtainColor]: Cortina ámbar central
/// - [greenCurtainColor]: Cortina verde central
/// - [yellowCurtainColor]: Cortina amarilla central
///
/// ### Cortinas Clippeadas (ClippedCurtain)
/// - [clippedCurtainColor]: Cortinas laterales clippeadas
///
/// ### Barras de Texto (TextBar)
/// - [textBarBlackColor]: Fondo de la barra de texto negra
/// - [textBarWhiteColor]: Fondo de la barra de texto blanca
/// - [textOnBlackColor]: Color del texto sobre fondo negro
/// - [textOnWhiteColor]: Color del texto sobre fondo blanco
///
/// ## Ejemplo de uso
///
/// ```dart
/// SonicManiaSplash(
///   baseText: 'STUDIOPOLIS',
///   secondaryText: 'ZONE',
///   theme: SonicManiaTheme(
///     redBarColor: Colors.purple,
///     orangeBarColor: Colors.pink,
///     blueBarColor: Colors.indigo,
///     greenBarColor: Colors.teal,
///   ),
/// )
/// ```
///
/// ## Tema con colores por defecto
///
/// ```dart
/// // Crear tema con valores por defecto
/// final theme = SonicManiaTheme.defaults();
///
/// // Copiar tema modificando solo algunos valores
/// final customTheme = theme.copyWith(
///   redBarColor: Colors.deepOrange,
/// );
/// ```
@immutable
class SonicManiaTheme extends FancyTitleTheme {
  /// Crea un tema personalizado para `SonicManiaSplash`.
  ///
  /// Todos los parámetros son opcionales. Los valores `null` indican
  /// que se debe usar el color por defecto definido en el widget.
  const SonicManiaTheme({
    this.redBarColor,
    this.orangeBarColor,
    this.blueBarColor,
    this.greenBarColor,
    this.blueCurtainColor,
    this.orangeCurtainColor,
    this.amberCurtainColor,
    this.greenCurtainColor,
    this.yellowCurtainColor,
    this.clippedCurtainColor,
    this.textBarBlackColor,
    this.textBarWhiteColor,
    this.textOnBlackColor,
    this.textOnWhiteColor,
  });

  /// Crea un tema con todos los colores por defecto de Sonic Mania.
  ///
  /// Este factory proporciona valores explícitos para todos los colores,
  /// a diferencia del constructor principal que usa `null` para indicar
  /// que se debe usar el color por defecto.
  factory SonicManiaTheme.defaults() => const SonicManiaTheme(
        redBarColor: SonicManiaBarColors.red,
        orangeBarColor: SonicManiaBarColors.orange,
        blueBarColor: SonicManiaBarColors.blue,
        greenBarColor: SonicManiaBarColors.green,
        blueCurtainColor: SonicManiaCurtainColors.blue,
        orangeCurtainColor: SonicManiaCurtainColors.orange,
        amberCurtainColor: SonicManiaCurtainColors.amber,
        greenCurtainColor: SonicManiaCurtainColors.green,
        yellowCurtainColor: SonicManiaCurtainColors.yellow,
        clippedCurtainColor: SonicManiaCurtainColors.yellow,
        textBarBlackColor: SonicManiaTextBarColors.blackBackground,
        textBarWhiteColor: SonicManiaTextBarColors.whiteBackground,
        textOnBlackColor: SonicManiaTextBarColors.whiteText,
        textOnWhiteColor: SonicManiaTextBarColors.blackText,
      );

  // --- Barras (ClippedBar) ---

  /// Color de la barra roja diagonal.
  ///
  /// Por defecto: `Color(0xFFD15529)` (rojo-naranja).
  final Color? redBarColor;

  /// Color de la barra naranja diagonal.
  ///
  /// Por defecto: `Color(0xFFFB9B0F)` (naranja brillante).
  final Color? orangeBarColor;

  /// Color de la barra azul diagonal.
  ///
  /// Por defecto: `Color(0xFF456EBD)` (azul medio).
  final Color? blueBarColor;

  /// Color de la barra verde diagonal.
  ///
  /// Por defecto: `Color(0xFF4E9B89)` (verde azulado).
  final Color? greenBarColor;

  // --- Cortinas (Curtain) ---

  /// Color de la cortina azul central.
  ///
  /// Por defecto: `Color(0xFF3D62AA)` (azul oscuro).
  final Color? blueCurtainColor;

  /// Color de la cortina naranja central.
  ///
  /// Por defecto: `Color(0xFFFE6933)` (naranja vivo).
  final Color? orangeCurtainColor;

  /// Color de la cortina ámbar central.
  ///
  /// Por defecto: `Color(0xFFCA7C0B)` (ámbar dorado).
  final Color? amberCurtainColor;

  /// Color de la cortina verde central.
  ///
  /// Por defecto: `Color(0xFF5DB4A1)` (verde agua).
  final Color? greenCurtainColor;

  /// Color de la cortina amarilla central.
  ///
  /// Por defecto: `Color(0xFFF7C700)` (amarillo dorado).
  final Color? yellowCurtainColor;

  // --- Cortinas Clippeadas (ClippedCurtain) ---

  /// Color de las cortinas laterales clippeadas.
  ///
  /// Por defecto: `Color(0xFFF7C700)` (amarillo dorado).
  final Color? clippedCurtainColor;

  // --- Barras de Texto (TextBar) ---

  /// Color de fondo de la barra de texto negra.
  ///
  /// Por defecto: `Color(0xFF212121)` (gris muy oscuro).
  final Color? textBarBlackColor;

  /// Color de fondo de la barra de texto blanca.
  ///
  /// Por defecto: `Color(0xFFF3F3F3)` (blanco grisáceo).
  final Color? textBarWhiteColor;

  /// Color del texto sobre fondo negro.
  ///
  /// Por defecto: `Color(0xFFF3F3F3)` (blanco grisáceo).
  final Color? textOnBlackColor;

  /// Color del texto sobre fondo blanco.
  ///
  /// Por defecto: `Color(0xFF212121)` (gris muy oscuro).
  final Color? textOnWhiteColor;

  /// Crea una copia de este tema con los valores especificados reemplazados.
  ///
  /// ```dart
  /// final theme = SonicManiaTheme(redBarColor: Colors.red);
  /// final newTheme = theme.copyWith(orangeBarColor: Colors.orange);
  /// // newTheme tiene redBarColor=Colors.red y orangeBarColor=Colors.orange
  /// ```
  SonicManiaTheme copyWith({
    Color? redBarColor,
    Color? orangeBarColor,
    Color? blueBarColor,
    Color? greenBarColor,
    Color? blueCurtainColor,
    Color? orangeCurtainColor,
    Color? amberCurtainColor,
    Color? greenCurtainColor,
    Color? yellowCurtainColor,
    Color? clippedCurtainColor,
    Color? textBarBlackColor,
    Color? textBarWhiteColor,
    Color? textOnBlackColor,
    Color? textOnWhiteColor,
  }) {
    return SonicManiaTheme(
      redBarColor: redBarColor ?? this.redBarColor,
      orangeBarColor: orangeBarColor ?? this.orangeBarColor,
      blueBarColor: blueBarColor ?? this.blueBarColor,
      greenBarColor: greenBarColor ?? this.greenBarColor,
      blueCurtainColor: blueCurtainColor ?? this.blueCurtainColor,
      orangeCurtainColor: orangeCurtainColor ?? this.orangeCurtainColor,
      amberCurtainColor: amberCurtainColor ?? this.amberCurtainColor,
      greenCurtainColor: greenCurtainColor ?? this.greenCurtainColor,
      yellowCurtainColor: yellowCurtainColor ?? this.yellowCurtainColor,
      clippedCurtainColor: clippedCurtainColor ?? this.clippedCurtainColor,
      textBarBlackColor: textBarBlackColor ?? this.textBarBlackColor,
      textBarWhiteColor: textBarWhiteColor ?? this.textBarWhiteColor,
      textOnBlackColor: textOnBlackColor ?? this.textOnBlackColor,
      textOnWhiteColor: textOnWhiteColor ?? this.textOnWhiteColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SonicManiaTheme &&
        other.redBarColor == redBarColor &&
        other.orangeBarColor == orangeBarColor &&
        other.blueBarColor == blueBarColor &&
        other.greenBarColor == greenBarColor &&
        other.blueCurtainColor == blueCurtainColor &&
        other.orangeCurtainColor == orangeCurtainColor &&
        other.amberCurtainColor == amberCurtainColor &&
        other.greenCurtainColor == greenCurtainColor &&
        other.yellowCurtainColor == yellowCurtainColor &&
        other.clippedCurtainColor == clippedCurtainColor &&
        other.textBarBlackColor == textBarBlackColor &&
        other.textBarWhiteColor == textBarWhiteColor &&
        other.textOnBlackColor == textOnBlackColor &&
        other.textOnWhiteColor == textOnWhiteColor;
  }

  @override
  int get hashCode => Object.hash(
        redBarColor,
        orangeBarColor,
        blueBarColor,
        greenBarColor,
        blueCurtainColor,
        orangeCurtainColor,
        amberCurtainColor,
        greenCurtainColor,
        yellowCurtainColor,
        clippedCurtainColor,
        textBarBlackColor,
        textBarWhiteColor,
        textOnBlackColor,
        textOnWhiteColor,
      );

  @override
  String toString() => 'SonicManiaTheme('
      'redBarColor: $redBarColor, '
      'orangeBarColor: $orangeBarColor, '
      'blueBarColor: $blueBarColor, '
      'greenBarColor: $greenBarColor, '
      'blueCurtainColor: $blueCurtainColor, '
      'orangeCurtainColor: $orangeCurtainColor, '
      'amberCurtainColor: $amberCurtainColor, '
      'greenCurtainColor: $greenCurtainColor, '
      'yellowCurtainColor: $yellowCurtainColor, '
      'clippedCurtainColor: $clippedCurtainColor, '
      'textBarBlackColor: $textBarBlackColor, '
      'textBarWhiteColor: $textBarWhiteColor, '
      'textOnBlackColor: $textOnBlackColor, '
      'textOnWhiteColor: $textOnWhiteColor'
      ')';
}
