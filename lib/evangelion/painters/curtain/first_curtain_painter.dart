import 'package:flutter/rendering.dart';

/// Painter for the first curtain in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class FirstCurtainPainter extends CustomPainter {
  /// Creates a first curtain painter.
  const FirstCurtainPainter();

  // Static cache for path and size
  static Path? _cachedPath;
  static Size? _cachedSize;

  // Pre-created paint objects (fully static)
  static final _paintFill = Paint()
    ..color = const Color(0xFF000000)
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.butt
    ..strokeJoin = StrokeJoin.miter;

  static final _paintStroke = Paint()
    ..color = const Color(0xFF000000)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0
    ..strokeCap = StrokeCap.butt
    ..strokeJoin = StrokeJoin.miter;

  static Path _buildPath(Size size) {
    return Path()
      ..moveTo(size.width * -0.0175000, size.height * 0.4271429)
      ..lineTo(size.width * 0.2166667, size.height * -0.0628571)
      ..lineTo(size.width * 1.0158333, size.height * -0.0157143)
      ..lineTo(size.width * 1.0083333, size.height * 1.0542857)
      ..lineTo(size.width * -0.0300000, size.height * 1.0600000);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Rebuild cache if size changed
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = _buildPath(size);
    }

    canvas
      ..drawPath(_cachedPath!, _paintFill)
      ..drawPath(_cachedPath!, _paintStroke);
  }

  @override
  bool shouldRepaint(covariant FirstCurtainPainter oldDelegate) {
    // Path is static, no need to repaint
    return false;
  }

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
