import 'package:flutter/rendering.dart';

/// Clipper para la cortina izquierda en la animacion Sonic Mania.
///
/// Crea un poligono trapezoidal que recorta el contenido para mostrar
/// la cortina amarilla que se desliza desde el borde izquierdo de la pantalla.
/// La forma trapezoidal crea el efecto visual de perspectiva caracteristico.
///
/// El path se cachea estaticamente para evitar recreaciones innecesarias
/// y mejorar el rendimiento durante las animaciones.
///
/// Se utiliza internamente en `SonicManiaSplash` como parte de la
/// secuencia de cortinas animadas que abren y cierran la transicion.
///
/// ## Ejemplo
///
/// ```dart
/// ClipPath(
///   clipper: LeftCurtainClipper(),
///   child: Container(color: Colors.yellow),
/// )
/// ```
///
/// Ver tambien:
/// - [RightCurtainClipper] para la cortina del lado derecho
/// - `OrangeBarClipper` para las barras diagonales
class LeftCurtainClipper extends CustomClipper<Path> {
  // Cache estático del path por size
  static Path? _cachedPath;
  static Size? _cachedSize;

  @override
  Path getClip(Size size) {
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = Path()
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width * 0.65, size.height)
        ..lineTo(size.width * 0.5, 0);
    }
    return _cachedPath!;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Clipper para la cortina derecha en la animacion Sonic Mania.
///
/// Crea un poligono trapezoidal que recorta el contenido para mostrar
/// la cortina amarilla que se desliza desde el borde derecho de la pantalla.
/// La forma trapezoidal crea el efecto visual de perspectiva caracteristico.
///
/// El path se cachea estaticamente para evitar recreaciones innecesarias
/// y mejorar el rendimiento durante las animaciones.
///
/// Se utiliza internamente en `SonicManiaSplash` como parte de la
/// secuencia de cortinas animadas que abren y cierran la transicion.
///
/// ## Ejemplo
///
/// ```dart
/// ClipPath(
///   clipper: RightCurtainClipper(),
///   child: Container(color: Colors.yellow),
/// )
/// ```
///
/// Ver tambien:
/// - [LeftCurtainClipper] para la cortina del lado izquierdo
/// - `OrangeBarClipper` para las barras diagonales
class RightCurtainClipper extends CustomClipper<Path> {
  // Cache estático del path por size
  static Path? _cachedPath;
  static Size? _cachedSize;

  @override
  Path getClip(Size size) {
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = Path()
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width * 0.65, size.height)
        ..lineTo(size.width * 0.5, 0);
    }
    return _cachedPath!;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
