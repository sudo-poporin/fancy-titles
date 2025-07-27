import 'package:flutter/rendering.dart';

/// Clipper para dibujar la barra amarilla izquierda
class LeftCurtainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.65, size.height)
      ..lineTo(size.width * 0.5, 0);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Clipper para dibujar la barra amarilla derecha
class RightCurtainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.65, size.height)
      ..lineTo(size.width * 0.5, 0);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
