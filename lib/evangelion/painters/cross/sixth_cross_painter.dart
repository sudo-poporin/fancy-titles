import 'package:flutter/rendering.dart';

/// Painter for the sixth cross in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class SixthCrossPainter extends CustomPainter {
  /// Creates a sixth cross painter.
  const SixthCrossPainter();

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
      ..moveTo(size.width * 0.5102750, size.height * 0.5323000)
      ..lineTo(size.width * 0.4833333, size.height * 0.5403000)
      ..lineTo(size.width * 0.2492500, size.height * 0.9691714)
      ..lineTo(size.width * 0.4653333, size.height * 0.5207143)
      ..lineTo(size.width * 0.4608333, size.height * 0.4942857)
      ..lineTo(size.width * 0.4625000, size.height * 0.4571429)
      ..lineTo(size.width * 0.3966667, size.height * 0.3542857)
      ..lineTo(size.width * 0.2813833, size.height * 0.1757714)
      ..lineTo(size.width * 0.4103500, size.height * 0.3313429)
      ..lineTo(size.width * 0.4758333, size.height * 0.4257143)
      ..lineTo(size.width * 0.5016667, size.height * 0.4185714)
      ..lineTo(size.width * 0.5850000, size.height * 0.2228571)
      ..lineTo(size.width * 0.6742000, size.height * 0.0269571)
      ..lineTo(size.width * 0.5991083, size.height * 0.2441714)
      ..lineTo(size.width * 0.5225000, size.height * 0.4342857)
      ..lineTo(size.width * 0.5283083, size.height * 0.4744000)
      ..lineTo(size.width * 0.7150000, size.height * 0.7200000)
      ..lineTo(size.width * 0.5291667, size.height * 0.5071571);
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
  bool shouldRepaint(covariant SixthCrossPainter oldDelegate) {
    // Path is static, no need to repaint
    return false;
  }
}
