import 'package:flutter/rendering.dart';

/// Painter for the fourth cross in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class FourthCrossRenderer extends CustomPainter {
  /// Creates a fourth cross painter.
  const FourthCrossRenderer();

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
      ..moveTo(size.width * 0.3565917, size.height * 0.5499429)
      ..lineTo(size.width * 0.4045167, size.height * 0.5256143)
      ..lineTo(size.width * 0.4535500, size.height * 0.4841429)
      ..lineTo(size.width * 1.0169833, size.height * 0.9659000)
      ..lineTo(size.width * 1.0133333, size.height * 0.7214286)
      ..lineTo(size.width * 0.5019917, size.height * 0.3400286)
      ..lineTo(size.width * 0.5055250, size.height * 0.2865000)
      ..lineTo(size.width * 0.7323000, size.height * -0.0441714)
      ..lineTo(size.width * 0.6076500, size.height * -0.0458143)
      ..lineTo(size.width * 0.4681167, size.height * 0.2264857)
      ..lineTo(size.width * 0.4380417, size.height * 0.1779429)
      ..lineTo(size.width * 0.3994667, size.height * 0.1596143)
      ..lineTo(size.width * 0.4967667, size.height * -0.1131143)
      ..lineTo(size.width * 0.3731167, size.height * -0.1422286)
      ..lineTo(size.width * 0.3016667, size.height * 0.1300000)
      ..lineTo(size.width * 0.2574333, size.height * 0.1464143)
      ..lineTo(size.width * 0.2258333, size.height * 0.1771429)
      ..lineTo(size.width * 0.0035417, size.height * -0.1999143)
      ..lineTo(size.width * -0.0151083, size.height * 0.1446143)
      ..lineTo(size.width * 0.1808333, size.height * 0.2742857)
      ..lineTo(size.width * 0.1660167, size.height * 0.3306714)
      ..lineTo(size.width * 0.1688833, size.height * 0.3953571)
      ..lineTo(size.width * 0.1800000, size.height * 0.4328571)
      ..lineTo(size.width * -0.0125000, size.height * 0.6585714)
      ..lineTo(size.width * -0.0125000, size.height * 0.9400000)
      ..lineTo(size.width * 0.2137500, size.height * 0.5157000)
      ..lineTo(size.width * 0.2308917, size.height * 0.5381714)
      ..lineTo(size.width * 0.2680083, size.height * 0.5321857)
      ..lineTo(size.width * 0.0025000, size.height * 1.0271429)
      ..lineTo(size.width * 0.1472000, size.height * 1.0278000);
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
  bool shouldRepaint(covariant FourthCrossRenderer oldDelegate) {
    // Path is static, no need to repaint
    return false;
  }
}
