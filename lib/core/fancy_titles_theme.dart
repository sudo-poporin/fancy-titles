import 'package:flutter/foundation.dart';

/// Clase base abstracta para temas de fancy_titles.
///
/// Los temas permiten personalizar los colores de los widgets de animación
/// sin necesidad de crear subclases personalizadas.
///
/// Cada widget tiene su propio tema específico que extiende esta clase:
/// - `SonicManiaTheme` para `SonicManiaSplash`
/// - `Persona5Theme` para `Persona5Title` (futuro)
/// - `EvangelionTheme` para `EvangelionTitle` (futuro)
/// - `MarioMakerTheme` para `MarioMakerTitle` (futuro)
///
/// ## Ejemplo de uso
///
/// ```dart
/// SonicManiaSplash(
///   baseText: 'LEVEL 1',
///   theme: SonicManiaTheme(
///     redBarColor: Colors.purple,
///     blueCurtainColor: Colors.indigo,
///   ),
/// )
/// ```
@immutable
abstract class FancyTitleTheme {
  /// Crea un tema base para widgets de fancy_titles.
  const FancyTitleTheme();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FancyTitleTheme && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
