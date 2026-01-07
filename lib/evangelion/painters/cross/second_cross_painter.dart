import 'package:flutter/rendering.dart';

/// Painter for the second cross in Evangelion animation.
class SecondCrossPainter extends CustomPainter {
  /// Creates a second cross painter.
  const SecondCrossPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1

    final paintFill0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    final path_0 = Path()
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

    canvas.drawPath(path_0, paintFill0);

    // Layer 1

    final paintStroke0 = Paint()
      ..color = const Color(0x352195F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paintStroke0);
  }

  @override
  bool shouldRepaint(covariant SecondCrossPainter oldDelegate) {
    // Path is static, no need to repaint
    return false;
  }
}
