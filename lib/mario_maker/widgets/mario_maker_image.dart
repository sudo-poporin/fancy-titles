import 'package:flutter/widgets.dart';

/// Widget that displays an image inside the Mario Maker circle.
///
/// Supports both static images (PNG, JPG) and animated GIFs.
class MarioMakerImage extends StatelessWidget {
  /// Creates a Mario Maker image widget.
  ///
  /// `imagePath` - Asset path for the image (supports GIFs)
  /// `size` - Size of the image container (default: 150)
  const new({required this._imagePath, this._size = 150, super.key});

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
