import 'package:flutter/rendering.dart';

/// Dibuja la barra de texto grande para el título principal.
///
/// Este painter dibuja un paralelogramo en la banda inferior (`0.4` del alto)
/// que sirve como fondo para el texto del título en la animación Sonic Mania.
/// Sus extremos se inclinan en `\` con la pendiente [slope].
class LargeBGDraw extends CustomPainter {
  /// Crea un painter para la barra de fondo grande.
  ///
  /// [color] es el color de relleno del polígono. [slope] es la pendiente
  /// `dx/dy` de los extremos; para que queden paralelos a las franjas del
  /// fondo, `stripeSlope` del tamaño de la pantalla.
  LargeBGDraw(Color color, {required this.slope})
    : painter = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

  /// El Paint usado para dibujar el fondo.
  final Paint painter;

  /// Pendiente `dx/dy` de los extremos inclinados.
  final double slope;

  // Cache estático del path por size y pendiente
  static Path? _cachedPath;
  static Size? _cachedSize;
  static double? _cachedSlope;

  static Path _buildPath(Size size, double slope) {
    final dx = size.height * 0.4 * slope;
    return Path()
      ..moveTo(-dx, size.height * 0.6)
      ..lineTo(0, size.height * 0.6)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width + dx, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedPath == null || _cachedSize != size || _cachedSlope != slope) {
      _cachedSize = size;
      _cachedSlope = slope;
      _cachedPath = _buildPath(size, slope);
    }

    canvas.drawPath(_cachedPath!, painter);
  }

  @override
  bool shouldRepaint(covariant LargeBGDraw oldDelegate) =>
      oldDelegate.slope != slope || oldDelegate.painter.color != painter.color;

  /// Debug getter for cached path (used in performance tests).
  /// Returns null if no path has been cached yet.
  static Path? get debugCachedPath => _cachedPath;

  /// Debug getter for cached size (used in performance tests).
  /// Returns null if no size has been cached yet.
  static Size? get debugCachedSize => _cachedSize;

  /// Debug getter for cached slope (used in performance tests).
  /// Returns null if no slope has been cached yet.
  static double? get debugCachedSlope => _cachedSlope;

  /// Resets the cache (used in performance tests).
  static void debugResetCache() {
    _cachedPath = null;
    _cachedSize = null;
    _cachedSlope = null;
  }
}

/// Dibuja la barra de texto pequeña para el subtítulo.
///
/// Este painter dibuja un paralelogramo más bajo, en la banda inferior (`0.2`
/// del alto), que sirve como fondo para el subtítulo en la animación Sonic
/// Mania.
/// Sus extremos se inclinan en `\` con la pendiente [slope].
class SmallBGDraw extends CustomPainter {
  /// Crea un painter para la barra de fondo pequeña.
  ///
  /// [color] es el color de relleno del polígono. [slope] es la pendiente
  /// `dx/dy` de los extremos; para que queden paralelos a las franjas del
  /// fondo, `stripeSlope` del tamaño de la pantalla.
  SmallBGDraw(Color color, {required this.slope})
    : painter = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

  /// El Paint usado para dibujar el fondo.
  final Paint painter;

  /// Pendiente `dx/dy` de los extremos inclinados.
  final double slope;

  // Cache estático del path por size y pendiente
  static Path? _cachedPath;
  static Size? _cachedSize;
  static double? _cachedSlope;

  static Path _buildPath(Size size, double slope) {
    final dx = size.height * 0.2 * slope;
    return Path()
      ..moveTo(-dx, size.height * 0.8)
      ..lineTo(0, size.height * 0.8)
      ..lineTo(size.width, size.height * 0.8)
      ..lineTo(size.width + dx, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedPath == null || _cachedSize != size || _cachedSlope != slope) {
      _cachedSize = size;
      _cachedSlope = slope;
      _cachedPath = _buildPath(size, slope);
    }

    canvas.drawPath(_cachedPath!, painter);
  }

  @override
  bool shouldRepaint(covariant SmallBGDraw oldDelegate) =>
      oldDelegate.slope != slope || oldDelegate.painter.color != painter.color;

  /// Debug getter for cached path (used in performance tests).
  /// Returns null if no path has been cached yet.
  static Path? get debugCachedPath => _cachedPath;

  /// Debug getter for cached size (used in performance tests).
  /// Returns null if no size has been cached yet.
  static Size? get debugCachedSize => _cachedSize;

  /// Debug getter for cached slope (used in performance tests).
  /// Returns null if no slope has been cached yet.
  static double? get debugCachedSlope => _cachedSlope;

  /// Resets the cache (used in performance tests).
  static void debugResetCache() {
    _cachedPath = null;
    _cachedSize = null;
    _cachedSlope = null;
  }
}
