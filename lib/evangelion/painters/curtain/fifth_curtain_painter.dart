import 'package:flutter/rendering.dart';

/// Painter for the fifth curtain in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class FifthCurtainPainter extends CustomPainter {
  /// Creates a fifth curtain painter.
  const FifthCurtainPainter();

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
    ..color = const Color.fromARGB(255, 22, 22, 22)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0
    ..strokeCap = StrokeCap.butt
    ..strokeJoin = StrokeJoin.miter;

  static Path _buildPath(Size size) {
    return Path()
      ..moveTo(size.width * 0.5569083, size.height * 0.6831714)
      ..lineTo(size.width * 0.4068417, size.height * 0.4750000)
      ..lineTo(size.width * 0.6205667, size.height * 0.3341714)
      ..lineTo(size.width * 0.6709917, size.height * 0.4868143);
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
  bool shouldRepaint(covariant FifthCurtainPainter oldDelegate) {
    // Path is static, no need to repaint
    return false;
  }
}
