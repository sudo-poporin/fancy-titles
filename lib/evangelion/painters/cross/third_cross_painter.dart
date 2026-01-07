import 'package:flutter/rendering.dart';

/// Painter for the third cross in Evangelion animation.
class ThirdCrossPainter extends CustomPainter {
  /// Creates a third cross painter.
  const ThirdCrossPainter();

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
  bool shouldRepaint(covariant ThirdCrossPainter oldDelegate) {
    // Path is static, no need to repaint
    return false;
  }
}
