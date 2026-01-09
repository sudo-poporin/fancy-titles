import 'package:flutter/rendering.dart';

/// Painter for the third cross in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class ThirdCrossPainter extends CustomPainter {
  /// Creates a third cross painter.
  const ThirdCrossPainter();

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
      ..moveTo(size.width * 0.4108333, size.height * 1.0314286)
      ..lineTo(size.width * 0.7115250, size.height * 0.3015286)
      ..lineTo(size.width * 0.7290000, size.height * 0.3159429)
      ..lineTo(size.width * 0.7516667, size.height * 0.3000000)
      ..lineTo(size.width * 1.0071167, size.height * 0.5977286)
      ..lineTo(size.width * 1.0089750, size.height * 0.5615143)
      ..lineTo(size.width * 0.7575000, size.height * 0.2728571)
      ..lineTo(size.width * 0.7516667, size.height * 0.2342857)
      ..lineTo(size.width * 0.8788167, size.height * -0.0230714)
      ..lineTo(size.width * 0.8555500, size.height * -0.0197429)
      ..lineTo(size.width * 0.7342750, size.height * 0.2204429)
      ..lineTo(size.width * 0.7108167, size.height * 0.2224000)
      ..lineTo(size.width * 0.5200000, size.height * -0.0328571)
      ..lineTo(size.width * 0.4975000, size.height * -0.0214286)
      ..lineTo(size.width * 0.7008333, size.height * 0.2528571)
      ..lineTo(size.width * 0.6997500, size.height * 0.2793429)
      ..lineTo(size.width * 0.3941667, size.height * 1.0228571);
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
  bool shouldRepaint(covariant ThirdCrossPainter oldDelegate) {
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
