import 'package:flutter/rendering.dart';

/// Painter for the second curtain in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class SecondCurtainPainter extends CustomPainter {
  /// Creates a second curtain painter.
  const SecondCurtainPainter();

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
      ..moveTo(size.width * -0.0075000, size.height * 0.4357143)
      ..lineTo(size.width * 0.3059083, size.height * -0.0100857)
      ..lineTo(size.width * 1.0108333, size.height * -0.0457143)
      ..lineTo(size.width * 1.0140083, size.height * 1.3599286)
      ..lineTo(size.width * 0.2228083, size.height * 0.5967429)
      ..lineTo(size.width * -0.0133333, size.height * 0.9414286);
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
  bool shouldRepaint(covariant SecondCurtainPainter oldDelegate) {
    // Path is static, no need to repaint
    return false;
  }
}
