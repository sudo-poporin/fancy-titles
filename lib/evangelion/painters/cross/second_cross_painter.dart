import 'package:flutter/rendering.dart';

/// Painter for the second cross in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class SecondCrossPainter extends CustomPainter {
  /// Creates a second cross painter.
  const SecondCrossPainter();

  // Static cache for path and size
  static Path? _cachedPath;
  static Size? _cachedSize;

  // Pre-created fill paint (immutable)
  static final _paintFill = Paint()
    ..color = const Color.fromARGB(255, 255, 255, 255)
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.butt
    ..strokeJoin = StrokeJoin.miter;

  // Base stroke paint (shader updated when size changes)
  static final _paintStroke = Paint()
    ..color = const Color(0x352195F3)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.miter;

  static Path _buildPath(Size size) {
    return Path()
      ..moveTo(size.width * 0.0711000, size.height * 1.0297429)
      ..lineTo(size.width * 0.2044000, size.height * 0.7139000)
      ..lineTo(size.width * -0.0357667, size.height * 0.5443429)
      ..lineTo(size.width * -0.0367167, size.height * 0.3144143)
      ..lineTo(size.width * 0.2485333, size.height * 0.6310857)
      ..lineTo(size.width * 0.6037083, size.height * -0.0325857)
      ..lineTo(size.width * 0.8942833, size.height * -0.0251286)
      ..lineTo(size.width * 0.2968917, size.height * 0.7108714)
      ..lineTo(size.width * 0.5111667, size.height * 1.0158571)
      ..lineTo(size.width * 0.3395250, size.height * 1.0105714)
      ..lineTo(size.width * 0.2476917, size.height * 0.7757714)
      ..lineTo(size.width * 0.2017083, size.height * 1.0272000);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Rebuild cache if size changed
    if (_cachedPath == null || _cachedSize != size) {
      _cachedSize = size;
      _cachedPath = _buildPath(size);

      // Update stroke width and shader that depend on size
      _paintStroke
        ..strokeWidth = size.width * 0.02
        ..shader = const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    canvas
      ..drawPath(_cachedPath!, _paintFill)
      ..drawPath(_cachedPath!, _paintStroke);
  }

  @override
  bool shouldRepaint(covariant SecondCrossPainter oldDelegate) {
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
