import 'package:flutter/rendering.dart';

/// Painter for the third curtain in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class ThirdCurtainPainter extends CustomPainter {
  /// Creates a third curtain painter.
  const ThirdCurtainPainter();

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
      ..moveTo(size.width * -0.0108333, size.height * 0.4085714)
      ..lineTo(size.width * 0.2900000, size.height * -0.0228571)
      ..lineTo(size.width * 1.0166667, size.height * -0.0400000)
      ..lineTo(size.width * 0.5575000, size.height * 0.5057143)
      ..lineTo(size.width * 0.6250000, size.height * 0.6128571)
      ..lineTo(size.width * 1.0066667, size.height * 0.1642857)
      ..lineTo(size.width * 1.0075000, size.height * 0.6271429)
      ..lineTo(size.width * 0.6466667, size.height * 0.6914286)
      ..lineTo(size.width * 0.5683333, size.height * 0.8014286)
      ..lineTo(size.width * 0.4183333, size.height * 0.7728571)
      ..lineTo(size.width * 0.5508333, size.height * 1.0428571)
      ..lineTo(size.width * 0.4133333, size.height * 1.0657143)
      ..lineTo(size.width * 0.3583333, size.height * 0.8385714)
      ..lineTo(size.width * 0.3200000, size.height * 1.0557143)
      ..lineTo(size.width * 0.1575000, size.height * 1.0628571)
      ..lineTo(size.width * 0.2708333, size.height * 0.8257143)
      ..lineTo(size.width * 0.2425000, size.height * 0.5757143)
      ..lineTo(size.width * 0.1216667, size.height * 0.5185714)
      ..lineTo(size.width * -0.0025000, size.height * 0.6185714)
      ..lineTo(size.width * -0.0083333, size.height * 0.5700000)
      ..lineTo(size.width * 0.1033333, size.height * 0.4200000)
      ..lineTo(size.width * 0.1766667, size.height * 0.3257143)
      ..lineTo(size.width * 0.1633333, size.height * 0.2971429)
      ..lineTo(size.width * -0.0091667, size.height * 0.4700000);
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
  bool shouldRepaint(covariant ThirdCurtainPainter oldDelegate) {
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
