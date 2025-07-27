import 'package:flutter/rendering.dart';

/// Clipper para dibujar la barra naranja
class OrangeBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.15, size.height * 0.3)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(size.width * 0.7, size.height)
      ..lineTo(size.width * 0.35, size.height * 0.3);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Clipper para dibujar la barra naranja
class GreenBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.7, size.height * 0.5)
      ..lineTo(size.width * 0.95, size.height)
      ..lineTo(size.width * 0.85, size.height)
      ..lineTo(size.width * 0.6, size.height * 0.5);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Clipper para dibujar la barra roja
class RedBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.1, size.height * 0.6)
      ..lineTo(size.width * 0.3, size.height)
      ..lineTo(size.width * 0.65, size.height)
      ..lineTo(size.width * 0.45, size.height * 0.6);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Clipper para dibujar la barra azul
class BlueBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.7, size.height)
      ..lineTo(size.width * 0.9, size.height)
      ..lineTo(size.width * 0.4, 0);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
