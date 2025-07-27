import 'package:flutter/rendering.dart';

///
class SixthCrossPainter extends CustomPainter {
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
