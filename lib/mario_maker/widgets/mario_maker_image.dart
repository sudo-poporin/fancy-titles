import 'package:flutter/material.dart';

/// Widget that displays an image inside the Mario Maker circle.
///
/// Supports both static images (PNG, JPG) and animated GIFs.
class MarioMakerImage extends StatelessWidget {
  /// Creates a Mario Maker image widget.
  ///
  /// [imagePath] - Asset path for the image (supports GIFs)
  /// [size] - Size of the image container (default: 150)
  const MarioMakerImage({
    required String imagePath,
    double size = 150,
    super.key,
  }) : _imagePath = imagePath,
       _size = size;

  final String _imagePath;
  final double _size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Image.asset(
        _imagePath,
        fit: BoxFit.contain,
        gaplessPlayback: true,
      ),
    );
  }
}
