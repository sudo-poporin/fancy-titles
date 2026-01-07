import 'package:fancy_titles/sonic_mania/bars/bars.dart';
import 'package:fancy_titles/sonic_mania/bars/text_bar.dart';
import 'package:fancy_titles/sonic_mania/clippers/clippers.dart';
import 'package:fancy_titles/sonic_mania/curtains/clipped_curtain.dart';
import 'package:fancy_titles/sonic_mania/curtains/curtains.dart';
import 'package:flutter/material.dart';

/// Pantalla de inicio de Sonic Mania
class SonicManiaSplash extends StatefulWidget {
  /// Constructor de SonicManiaSplash
  SonicManiaSplash({
    required String baseText,
    String? secondaryText,
    String? lastText,
    super.key,
  }) : _baseText = baseText,
       _secondaryText = secondaryText,
       _lastText = lastText {
    if (_lastText != null && _lastText.length > 4) {
      throw FlutterError('El tercer texto no puede tener más de 4 caracteres');
    }
  }

  /// Primera línea de texto
  final String _baseText;

  /// Segunda línea de texto
  final String? _secondaryText;

  /// Tercera línea de texto (máximo 4 caracteres)
  final String? _lastText;

  @override
  State<SonicManiaSplash> createState() => _SonicManiaSplashState();
}

class _SonicManiaSplashState extends State<SonicManiaSplash>
    with SingleTickerProviderStateMixin {
  late bool _animationCompleted = false;
  late double firstTextVerticalOffset;
  late double lastTextVerticalOffset;
  late double lastTextHorizontalOffset;
  late double lastTextOriginOffset;
  late double lastTextInvertedValue;

  @override
  void initState() {
    firstTextVerticalOffset = widget._secondaryText != null ? -1.0 : -0.5;
    lastTextVerticalOffset = widget._secondaryText != null ? 0.8 : 0.5;
    lastTextHorizontalOffset = widget._secondaryText != null ? 0.7 : 0.3;
    lastTextOriginOffset = widget._secondaryText != null ? -10 : 10;

    lastTextInvertedValue = widget._secondaryText != null ? 1.0 : -1.0;

    _initWidgetAutoDestructionSecuence();
    super.initState();
  }

  /// Inicializa la secuencia de autodestrucción del widget
  void _initWidgetAutoDestructionSecuence() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (!mounted) return;
      setState(() {
        _animationCompleted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 125),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: _animationCompleted
          ? const SizedBox.shrink()
          : ColoredBox(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      ClippedCurtain.left(customClipper: LeftCurtainClipper()),
                      ClippedCurtain.right(
                        customClipper: RightCurtainClipper(),
                      ),
                      ClippedBar.orange(customClipper: OrangeBarClipper()),
                      ClippedBar.red(customClipper: RedBarClipper()),
                      ClippedBar.green(customClipper: GreenBarClipper()),
                      ClippedBar.blue(customClipper: BlueBarClipper()),
                    ],
                  ),
                  const Curtain.blue(),
                  const Curtain.orange(),
                  const Curtain.amber(),
                  const Curtain.green(),
                  const Curtain.yellow(),
                  Stack(
                    children: [
                      TextBar.black(
                        text: widget._baseText.toUpperCase(),
                        beginOffset: Offset(-10, firstTextVerticalOffset),
                        endOffset: Offset(2, firstTextVerticalOffset),
                        stopOffset: Offset(-0.2, firstTextVerticalOffset),
                        stopEndOffset: Offset(-10, firstTextVerticalOffset),
                      ),
                      if (widget._secondaryText != null)
                        TextBar.black(
                          text: widget._secondaryText!..toUpperCase(),
                          beginOffset: const Offset(10, 0),
                          endOffset: const Offset(-2, 0),
                          stopOffset: const Offset(0.2, 0),
                          stopEndOffset: const Offset(10, 0),
                        ),
                      if (widget._lastText != null)
                        TextBar.white(
                          text: widget._lastText!.toLowerCase(),
                          beginOffset: Offset(
                            lastTextOriginOffset,
                            lastTextVerticalOffset,
                          ),
                          endOffset: Offset(
                            2 * lastTextInvertedValue,
                            lastTextVerticalOffset,
                          ),
                          stopOffset: Offset(
                            lastTextHorizontalOffset,
                            lastTextVerticalOffset,
                          ),
                          stopEndOffset: Offset(
                            lastTextOriginOffset,
                            lastTextVerticalOffset,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
