import 'package:fancy_titles/sonic_mania/widgets/bounce_vertically.dart';
import 'package:flutter/material.dart';

/// A Romantic Bouncing Text
/// Ideally it is a [RichText] to control the paragraph easier.
/// The helper method [_createBouncingSpans] is used to create its
/// child spans.
/// [_text] : the text to animate.
/// [_textStyle] : see [Text.style].
class BouncingText extends StatelessWidget {
  /// Constructor.
  const BouncingText({
    required String text,
    required TextStyle textStyle,
    bool bounceUp = true,
    super.key,
  }) : _textStyle = textStyle,
       _text = text,
       _bounceUp = bounceUp;

  final String _text;
  final TextStyle _textStyle;
  final bool _bounceUp;

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary aísla los repintados del texto animado
    // evitando que afecten a widgets padres
    return RepaintBoundary(
      child: RichText(
        text: TextSpan(
          style: _textStyle,
          children: _createBouncingSpans(
            text: _text,
            textStyle: _textStyle,
            bounceUp: _bounceUp,
          ),
        ),
      ),
    );
  }
}

/// Basically, [BouncingText] is a [RichText].
/// So this a helper method is used to create a list of [WidgetSpan].
/// [text] : the text to animate.
/// [textStyle] : see [Text.style].
List<InlineSpan> _createBouncingSpans({
  required String text,
  required TextStyle textStyle,
  required bool bounceUp,
}) {
  final spans = <InlineSpan>[];
  var wordIndex = 0;

  for (var i = 0; i < text.length; ++i) {
    final letter = text[i];

    final delayDuration = Duration(milliseconds: wordIndex + i + 20);

    spans.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: BounceVertically(
          delay: delayDuration * (i * 3),
          bounceUp: bounceUp,
          child: Text(letter, style: textStyle),
        ),
      ),
    );
    wordIndex += letter.length;
  }

  return spans.toList(growable: false);
}
