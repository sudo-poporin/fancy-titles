import 'package:fancy_titles/persona_5/consts/const.dart';
import 'package:flutter/material.dart';

/// Persona 5 text with stroke effect
class Persona5Text extends StatelessWidget {
  /// Shows a text with a stroke effect
  /// The text is "Take your heart" by default
  const Persona5Text({super.key, String text = 'HADOKEN\n\n\ntakes your heart'})
    : _text = text;

  final String _text;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(-0.15),
      child: Stack(
        children: [
          FittedBox(
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Persona',
                height: 1.4,
                decoration: TextDecoration.none,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = whiteColor,
              ),
            ),
          ),
          FittedBox(
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                height: 1.4,
                decoration: TextDecoration.none,
                color: blackColor,
                fontFamily: 'Persona',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
