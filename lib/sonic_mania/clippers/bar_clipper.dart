import 'package:flutter/rendering.dart';

/// Clipper para la barra naranja en la animacion Sonic Mania.
///
/// Crea un poligono inclinado que recorta el contenido para mostrar
/// la barra diagonal naranja en la parte inferior izquierda de la pantalla.
///
/// El path se cachea estaticamente para evitar recreaciones innecesarias
/// y mejorar el rendimiento durante las animaciones.
///
/// Se utiliza internamente en `SonicManiaSplash` como parte de la
/// secuencia de barras diagonales animadas.
///
/// ## Ejemplo
///
/// ```dart
/// ClipPath(
///   clipper: OrangeBarClipper(),
///   child: Container(color: Colors.orange),
/// )
/// ```
///
/// Ver tambien:
/// - [GreenBarClipper], [RedBarClipper], [BlueBarClipper] otros clippers
/// - `LeftCurtainClipper` para las cortinas laterales
class OrangeBarClipper extends CustomClipper<Path> {
  // Cache estático del path por size
  static Path? _cachedPath;
  static Size? _cachedSize;

  @override
  Path getClip(Size size) {
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = Path()
        ..moveTo(size.width * 0.15, size.height * 0.3)
        ..lineTo(size.width * 0.5, size.height)
        ..lineTo(size.width * 0.7, size.height)
        ..lineTo(size.width * 0.35, size.height * 0.3);
    }
    return _cachedPath!;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Clipper para la barra verde en la animacion Sonic Mania.
///
/// Crea un poligono inclinado que recorta el contenido para mostrar
/// la barra diagonal verde en la parte inferior derecha de la pantalla.
///
/// El path se cachea estaticamente para evitar recreaciones innecesarias
/// y mejorar el rendimiento durante las animaciones.
///
/// Se utiliza internamente en `SonicManiaSplash` como parte de la
/// secuencia de barras diagonales animadas.
///
/// ## Ejemplo
///
/// ```dart
/// ClipPath(
///   clipper: GreenBarClipper(),
///   child: Container(color: Colors.green),
/// )
/// ```
///
/// Ver tambien:
/// - [OrangeBarClipper], [RedBarClipper], [BlueBarClipper] otros clippers
class GreenBarClipper extends CustomClipper<Path> {
  // Cache estático del path por size
  static Path? _cachedPath;
  static Size? _cachedSize;

  @override
  Path getClip(Size size) {
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = Path()
        ..moveTo(size.width * 0.7, size.height * 0.5)
        ..lineTo(size.width * 0.95, size.height)
        ..lineTo(size.width * 0.85, size.height)
        ..lineTo(size.width * 0.6, size.height * 0.5);
    }
    return _cachedPath!;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Clipper para la barra roja en la animacion Sonic Mania.
///
/// Crea un poligono inclinado que recorta el contenido para mostrar
/// la barra diagonal roja en la parte inferior central de la pantalla.
///
/// El path se cachea estaticamente para evitar recreaciones innecesarias
/// y mejorar el rendimiento durante las animaciones.
///
/// Se utiliza internamente en `SonicManiaSplash` como parte de la
/// secuencia de barras diagonales animadas.
///
/// ## Ejemplo
///
/// ```dart
/// ClipPath(
///   clipper: RedBarClipper(),
///   child: Container(color: Colors.red),
/// )
/// ```
///
/// Ver tambien:
/// - [OrangeBarClipper], [GreenBarClipper], [BlueBarClipper] otros clippers
class RedBarClipper extends CustomClipper<Path> {
  // Cache estático del path por size
  static Path? _cachedPath;
  static Size? _cachedSize;

  @override
  Path getClip(Size size) {
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = Path()
        ..moveTo(size.width * 0.1, size.height * 0.6)
        ..lineTo(size.width * 0.3, size.height)
        ..lineTo(size.width * 0.65, size.height)
        ..lineTo(size.width * 0.45, size.height * 0.6);
    }
    return _cachedPath!;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Clipper para la barra azul en la animacion Sonic Mania.
///
/// Crea un poligono inclinado que recorta el contenido para mostrar
/// la barra diagonal azul que cruza toda la pantalla diagonalmente.
///
/// El path se cachea estaticamente para evitar recreaciones innecesarias
/// y mejorar el rendimiento durante las animaciones.
///
/// Se utiliza internamente en `SonicManiaSplash` como parte de la
/// secuencia de barras diagonales animadas.
///
/// ## Ejemplo
///
/// ```dart
/// ClipPath(
///   clipper: BlueBarClipper(),
///   child: Container(color: Colors.blue),
/// )
/// ```
///
/// Ver tambien:
/// - [OrangeBarClipper], [GreenBarClipper], [RedBarClipper] otros clippers
class BlueBarClipper extends CustomClipper<Path> {
  // Cache estático del path por size
  static Path? _cachedPath;
  static Size? _cachedSize;

  @override
  Path getClip(Size size) {
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = Path()
        ..moveTo(size.width * 0.2, 0)
        ..lineTo(size.width * 0.7, size.height)
        ..lineTo(size.width * 0.9, size.height)
        ..lineTo(size.width * 0.4, 0);
    }
    return _cachedPath!;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
