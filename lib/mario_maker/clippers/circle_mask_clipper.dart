import 'package:flutter/material.dart';

/// A custom clipper that creates a circular mask.
///
/// Used to clip content to a circular shape that can expand
/// to reveal the background.
class CircleMaskClipper extends CustomClipper<Path> {
  /// Creates a circle mask clipper.
  ///
  /// [radius] - The radius of the circular mask
  /// [center] - The center point of the circle
  CircleMaskClipper({
    required this.radius,
    required this.center,
  });

  /// The radius of the circular mask
  final double radius;

  /// The center point of the circle
  final Offset center;

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(CircleMaskClipper oldClipper) {
    return radius != oldClipper.radius || center != oldClipper.center;
  }
}
