import 'package:flutter/rendering.dart';

/// Painter for the fourth curtain in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class FourthCurtainPainter extends CustomPainter {
  /// Creates a fourth curtain painter.
  const FourthCurtainPainter();

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
      ..moveTo(size.width * 0.2875000, size.height * 0.6400000)
      ..lineTo(size.width * 0.5491667, size.height * 0.3385714)
      ..lineTo(size.width * 0.6591667, size.height * 0.5142857)
      ..lineTo(size.width * 0.6308333, size.height * 0.6100000)
      ..lineTo(size.width * 1.0016667, size.height * 0.2514286)
      ..lineTo(size.width * 1.0116667, size.height * 0.6114286)
      ..lineTo(size.width * 0.7350000, size.height * 0.7585714)
      ..lineTo(size.width * 0.5825000, size.height * 0.7057143)
      ..lineTo(size.width * 0.5350000, size.height * 0.7842857)
      ..lineTo(size.width * 0.6616667, size.height * 1.0328571)
      ..lineTo(size.width * 0.4313667, size.height * 1.0395143)
      ..lineTo(size.width * 0.4241667, size.height * 0.8000000)
      ..lineTo(size.width * 0.3816667, size.height * 1.0228571)
      ..lineTo(size.width * 0.0533333, size.height * 1.0400000)
      ..lineTo(size.width * 0.3291667, size.height * 0.8171429);
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
  bool shouldRepaint(covariant FourthCurtainPainter oldDelegate) {
    // Path is static, no need to repaint
    return false;
  }
}
