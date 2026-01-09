import 'package:flutter/material.dart';

/// Clipper que crea una máscara circular para la animación Mario Maker.
///
/// Recorta el contenido en forma de círculo que puede expandirse
/// para revelar el fondo durante la transición.
///
/// El círculo se define por su [radius] y [center], permitiendo
/// animaciones de expansión desde cualquier punto de la pantalla.
class CircleMaskClipper extends CustomClipper<Path> {
  /// Crea un clipper de máscara circular.
  ///
  /// [radius] - El radio de la máscara circular
  /// [center] - El punto central del círculo
  CircleMaskClipper({
    required this.radius,
    required this.center,
  });

  /// El radio de la máscara circular
  final double radius;

  /// El punto central del círculo
  final Offset center;

  // Cache estático del path por parámetros
  static Path? _cachedPath;
  static double? _cachedRadius;
  static Offset? _cachedCenter;

  @override
  Path getClip(Size size) {
    if (_cachedPath == null ||
        _cachedRadius != radius ||
        _cachedCenter != center) {
      _cachedRadius = radius;
      _cachedCenter = center;
      _cachedPath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: radius));
    }
    return _cachedPath!;
  }

  @override
  bool shouldReclip(CircleMaskClipper oldClipper) {
    return radius != oldClipper.radius || center != oldClipper.center;
  }

  /// Debug getter for cached path (used in performance tests).
  static Path? get debugCachedPath => _cachedPath;

  /// Debug getter for cached radius (used in performance tests).
  static double? get debugCachedRadius => _cachedRadius;

  /// Debug getter for cached center (used in performance tests).
  static Offset? get debugCachedCenter => _cachedCenter;

  /// Resets the cache (used in performance tests).
  static void debugResetCache() {
    _cachedPath = null;
    _cachedRadius = null;
    _cachedCenter = null;
  }
}
