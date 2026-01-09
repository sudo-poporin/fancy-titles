import 'package:flutter/rendering.dart';

/// Painter for the fifth cross in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class FifthCrossPainter extends CustomPainter {
  /// Creates a fifth cross painter.
  const FifthCrossPainter();

  // Static cache for path and size
  static Path? _cachedPath;
  static Size? _cachedSize;

  // Pre-created fill paint (immutable)
  static final _paintFill = Paint()
    ..color = const Color(0xFFFFFFFF)
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
      ..moveTo(size.width * 0.6444583, size.height * 0.6821714)
      ..lineTo(size.width * 0.9325000, size.height * 1.0685714)
      ..lineTo(size.width * 1.0200000, size.height * 1.0342857)
      ..lineTo(size.width * 1.0200000, size.height * 0.8828571)
      ..lineTo(size.width * 0.6753000, size.height * 0.6136143)
      ..lineTo(size.width * 0.6764000, size.height * 0.5890429)
      ..lineTo(size.width * 0.6716750, size.height * 0.5628857)
      ..lineTo(size.width * 0.6640250, size.height * 0.5452000)
      ..lineTo(size.width * 0.9291667, size.height * -0.0371429)
      ..lineTo(size.width * 0.8191667, size.height * -0.0385714)
      ..lineTo(size.width * 0.6291667, size.height * 0.5085714)
      ..lineTo(size.width * 0.6091667, size.height * 0.5085714)
      ..lineTo(size.width * 0.5950000, size.height * 0.5114286)
      ..lineTo(size.width * 0.5890333, size.height * 0.5178429)
      ..lineTo(size.width * 0.5739167, size.height * 0.5185714)
      ..lineTo(size.width * 0.0666000, size.height * -0.0295429)
      ..lineTo(size.width * -0.0301167, size.height * -0.0589000)
      ..lineTo(size.width * -0.0266667, size.height * 0.0657143)
      ..lineTo(size.width * 0.5025000, size.height * 0.5571429)
      ..lineTo(size.width * 0.5389000, size.height * 0.5889714)
      ..lineTo(size.width * 0.5402500, size.height * 0.6181143)
      ..lineTo(size.width * 0.5480833, size.height * 0.6547857)
      ..lineTo(size.width * 0.3816667, size.height * 1.0385714)
      ..lineTo(size.width * 0.4852833, size.height * 1.0403143)
      ..lineTo(size.width * 0.5858333, size.height * 0.6971429)
      ..lineTo(size.width * 0.6150000, size.height * 0.7042857);
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
  bool shouldRepaint(covariant FifthCrossPainter oldDelegate) {
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
