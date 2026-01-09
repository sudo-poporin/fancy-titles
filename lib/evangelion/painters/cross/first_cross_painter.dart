import 'package:flutter/rendering.dart';

/// Painter for the first cross in Evangelion animation.
///
/// Uses static path caching to improve performance by avoiding
/// repeated Path object creation on each paint call.
class FirstCrossPainter extends CustomPainter {
  /// Creates a first cross painter.
  const FirstCrossPainter();

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
      ..moveTo(size.width * 0.9996833, size.height * 0.7345143)
      ..lineTo(size.width * 0.8673750, size.height * 0.5348857)
      ..lineTo(size.width * 0.6687250, size.height * 0.4389714)
      ..lineTo(size.width * 0.6666667, size.height * 0.4342857)
      ..lineTo(size.width * 0.6896250, size.height * 0.4252714)
      ..lineTo(size.width * 0.6651250, size.height * 0.4092857)
      ..lineTo(size.width * 0.7345167, size.height * 0.3315143)
      ..lineTo(size.width * 0.8374167, size.height * 0.2574714)
      ..lineTo(size.width * 0.9745333, size.height * 0.0416000)
      ..lineTo(size.width * 0.7948167, size.height * 0.1424286)
      ..lineTo(size.width * 0.7041667, size.height * 0.2785714)
      ..lineTo(size.width * 0.6494000, size.height * 0.3502857)
      ..lineTo(size.width * 0.6408250, size.height * 0.3553429)
      ..lineTo(size.width * 0.6274833, size.height * 0.3227571)
      ..lineTo(size.width * 0.6155833, size.height * 0.3573286)
      ..lineTo(size.width * 0.6133333, size.height * 0.3571429)
      ..lineTo(size.width * 0.4007083, size.height * 0.1334857)
      ..lineTo(size.width * 0.1533333, size.height * 0.0600000)
      ..lineTo(size.width * 0.3372500, size.height * 0.2722857)
      ..lineTo(size.width * 0.5797417, size.height * 0.4123714)
      ..lineTo(size.width * 0.5775000, size.height * 0.4160714)
      ..lineTo(size.width * 0.5426250, size.height * 0.4277286)
      ..lineTo(size.width * 0.5784250, size.height * 0.4411714)
      ..lineTo(size.width * 0.4516667, size.height * 0.6657143)
      ..lineTo(size.width * 0.3325000, size.height * 0.9700000)
      ..lineTo(size.width * 0.5250000, size.height * 0.7171429)
      ..lineTo(size.width * 0.6075000, size.height * 0.4757143)
      ..lineTo(size.width * 0.6161250, size.height * 0.4804714)
      ..lineTo(size.width * 0.6272250, size.height * 0.5092000)
      ..lineTo(size.width * 0.6358333, size.height * 0.4757143)
      ..lineTo(size.width * 0.6430417, size.height * 0.4761000)
      ..lineTo(size.width * 0.8375000, size.height * 0.6471429)
      ..lineTo(size.width * 1.0077833, size.height * 0.7601143);
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
  bool shouldRepaint(covariant FirstCrossPainter oldDelegate) {
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
