import 'package:flutter/rendering.dart';

/// Dibuja la barra de texto grande para el título principal.
///
/// Este painter dibuja un polígono inclinado que sirve como fondo
/// para el texto del título en la animación Sonic Mania.
class LargeBGDraw extends CustomPainter {
  /// Crea un painter para la barra de fondo grande.
  ///
  /// [color] es el color de relleno del polígono.
  LargeBGDraw(Color color)
      : painter = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  /// El Paint usado para dibujar el fondo.
  final Paint painter;

  // Cache estático del path por size
  static Path? _cachedPath;
  static Size? _cachedSize;

  static Path _buildPath(Size size) {
    return Path()
      ..moveTo(-48, size.height * 0.6)
      ..lineTo(0, size.height * 0.6)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width + 48, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = _buildPath(size);
    }

    canvas.drawPath(_cachedPath!, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  /// Debug getter for cached path (used in performance tests).
  /// Returns null if no path has been cached yet.
  static Path? get debugCachedPath => _cachedPath;

  /// Debug getter for cached size (used in performance tests).
  /// Returns null if no size has been cached yet.
  static Size? get debugCachedSize => _cachedSize;

  /// Resets the cache (used in performance tests).
  static void debugResetCache() {
    _cachedPath = null;
    _cachedSize = null;
  }
}

/// Dibuja la barra de texto pequeña para el subtítulo.
///
/// Este painter dibuja un polígono inclinado más pequeño que sirve
/// como fondo para el subtítulo en la animación Sonic Mania.
class SmallBGDraw extends CustomPainter {
  /// Crea un painter para la barra de fondo pequeña.
  ///
  /// [color] es el color de relleno del polígono.
  SmallBGDraw(Color color)
      : painter = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  /// El Paint usado para dibujar el fondo.
  final Paint painter;

  // Cache estático del path por size
  static Path? _cachedPath;
  static Size? _cachedSize;

  static Path _buildPath(Size size) {
    return Path()
      ..moveTo(-24, size.height * 0.8)
      ..lineTo(0, size.height * 0.8)
      ..lineTo(size.width, size.height * 0.8)
      ..lineTo(size.width + 24, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = _buildPath(size);
    }

    canvas.drawPath(_cachedPath!, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  /// Debug getter for cached path (used in performance tests).
  /// Returns null if no path has been cached yet.
  static Path? get debugCachedPath => _cachedPath;

  /// Debug getter for cached size (used in performance tests).
  /// Returns null if no size has been cached yet.
  static Size? get debugCachedSize => _cachedSize;

  /// Resets the cache (used in performance tests).
  static void debugResetCache() {
    _cachedPath = null;
    _cachedSize = null;
  }
}
