import 'package:fancy_titles/persona_5/consts/const.dart';
import 'package:flutter/material.dart';

/// Persona 5 Image that shows a hadoken
class Persona5Image extends StatelessWidget {
  /// Shows a hadoken image
  const Persona5Image({
    super.key,
    required String? imagePath,
    required bool withImageBlendMode,
  }) : _imagePath = imagePath,
       _withImageBlendMode = withImageBlendMode;

  final String? _imagePath;
  final bool _withImageBlendMode;

  @override
  Widget build(BuildContext context) {
    return _imagePath != null
        ? Transform.rotate(
            angle: -0.3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_withImageBlendMode)
                  Image.asset(
                    _imagePath,
                    fit: BoxFit.cover,
                    width: 250,
                    colorBlendMode: BlendMode.srcATop,
                    color: whiteColor,
                  ),
                Image.asset(
                  _imagePath,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
