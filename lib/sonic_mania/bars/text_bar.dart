import 'dart:async';

import 'package:fancy_titles/sonic_mania/animations/diagonal_slide_animation.dart';
import 'package:fancy_titles/sonic_mania/bars/animated_bouncing_text.dart';
import 'package:fancy_titles/sonic_mania/painters/text_bg_painters.dart';
import 'package:flutter/material.dart';

const Color _kDefaultBlackColor = Color(0xFF212121);
const Color _kDefaultWhiteColor = Color(0xFFF3F3F3);

/// Barra de texto
class TextBar extends StatefulWidget {
  /// Barra de texto
  const TextBar({
    required Color color,
    required String text,
    required Color textColor,
    Color textBorderColor = Colors.transparent,
    Offset beginOffset = const Offset(-2, 0),
    Offset endOffset = const Offset(2, 0),
    Offset stopOffset = const Offset(-0.2, 0),
    Offset stopEndOffset = const Offset(-2, 0),
    CustomPainter? painter,
    bool bounceUp = true,
    bool isWhite = false,
    super.key,
  }) : _bounceUp = bounceUp,
       _painter = painter,
       _stopEndOffset = stopEndOffset,
       _stopOffset = stopOffset,
       _endOffset = endOffset,
       _beginOffset = beginOffset,
       _textBorderColor = textBorderColor,
       _textColor = textColor,
       _color = color,
       _text = text,
       _isWhiteText = isWhite;

  /// Barra blanca
  TextBar.black({
    required String text,
    required Offset beginOffset,
    required Offset endOffset,
    required Offset stopOffset,
    required Offset stopEndOffset,
    Color color = _kDefaultBlackColor,
    Color textColor = _kDefaultWhiteColor,
    Color textBorderColor = _kDefaultBlackColor,
    bool bounceUp = true,
    super.key,
  }) : _bounceUp = bounceUp,
       _stopEndOffset = stopEndOffset,
       _stopOffset = stopOffset,
       _endOffset = endOffset,
       _beginOffset = beginOffset,
       _textBorderColor = textBorderColor,
       _textColor = textColor,
       _color = color,
       _text = text,
       _painter = LargeBGDraw(_kDefaultBlackColor),
       _isWhiteText = false;

  /// Barra negra
  TextBar.white({
    required String text,
    required Offset beginOffset,
    required Offset endOffset,
    required Offset stopOffset,
    required Offset stopEndOffset,
    Color color = _kDefaultWhiteColor,
    Color textColor = _kDefaultBlackColor,
    Color textBorderColor = _kDefaultWhiteColor,
    bool bounceUp = false,
    super.key,
  }) : _bounceUp = bounceUp,
       _stopEndOffset = stopEndOffset,
       _stopOffset = stopOffset,
       _endOffset = endOffset,
       _beginOffset = beginOffset,
       _textBorderColor = textBorderColor,
       _textColor = textColor,
       _color = color,
       _text = text,
       _painter = SmallBGDraw(_kDefaultWhiteColor),
       _isWhiteText = true;

  /// Texto de la barra
  final String _text;

  /// Color de la barra
  final Color _color;

  /// Color del texto
  final Color _textColor;

  /// Color del borde del texto
  final Color _textBorderColor;

  /// Offset de inicio de la animación
  final Offset _beginOffset;

  /// Offset de fin de la animación
  final Offset _endOffset;

  /// Offset del texto detenido
  final Offset _stopOffset;

  /// Offset de fin del texto detenido
  final Offset _stopEndOffset;

  /// Painter de la barra
  final CustomPainter? _painter;

  /// Si el texto debe rebotar
  final bool _bounceUp;

  final bool _isWhiteText;

  @override
  State<TextBar> createState() => _TextBarState();
}

class _TextBarState extends State<TextBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late Offset _beginOffset;
  late Offset _endOffset;
  late bool _canShowText;

  // Valores cacheados para evitar recálculos
  double? _cachedFontSize;
  double? _cachedStrokeWidth;
  Orientation? _cachedOrientation;
  Size? _cachedScreenSize;

  @override
  void initState() {
    _canShowText = false;
    _beginOffset = widget._beginOffset;
    _endOffset = widget._endOffset;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _startAnimation();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCachedSizes();
  }

  void _updateCachedSizes() {
    final orientation = MediaQuery.orientationOf(context);
    final screenSize = MediaQuery.sizeOf(context);

    // Solo recalcular si cambiaron las dependencias
    if (_cachedOrientation != orientation || _cachedScreenSize != screenSize) {
      _cachedOrientation = orientation;
      _cachedScreenSize = screenSize;

      final constraints = BoxConstraints(
        maxWidth: screenSize.width,
        maxHeight: screenSize.height,
      );
      _cachedFontSize = _calculateSize(context, constraints);
      _cachedStrokeWidth = _calculateStrokeWidth(_cachedFontSize!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    unawaited(
      _controller.forward().then((_) => _slideIn()).whenComplete(_slideOut),
    );
  }

  /// Desliza la barra dentro de la pantalla
  void _slideIn() {
    setState(() => _beginOffset = widget._stopOffset);
    unawaited(_controller.reverse());
  }

  /// Desliza la barra fuera de la pantalla
  void _slideOut() {
    setState(() => _canShowText = true);
    Future<void>.delayed(const Duration(milliseconds: 3500), () {
      setState(() => _endOffset = widget._stopEndOffset);
      unawaited(_controller.forward());
    });
  }

  double _calculateSize(BuildContext context, BoxConstraints constraints) {
    final orientation = MediaQuery.orientationOf(context);

    if (orientation == Orientation.landscape) {
      return (constraints.maxHeight * 0.05).truncateToDouble();
    } else {
      return (constraints.maxWidth * 0.05).truncateToDouble();
    }
  }

  double _calculateStrokeWidth(double fontSize) => fontSize <= 28 ? 4 : 6;

  @override
  Widget build(BuildContext context) {
    return HorizontalSlideTransition(
      animation: _animation,
      beginOffset: _beginOffset,
      endOffset: _endOffset,
      child: Stack(
        children: [
          if (!_canShowText)
            Builder(
              builder: (context) {
                // Usar valores cacheados
                final screenWidth = _cachedScreenSize?.width ??
                    MediaQuery.sizeOf(context).width;
                final fontSize = _cachedFontSize ?? 24.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidth * 0.5,
                      minHeight: fontSize,
                    ),
                    child: SizedBox(child: ColoredBox(color: widget._color)),
                  ),
                );
              },
            ),
          if (_canShowText)
            Builder(
              builder: (context) {
                // Usar valores cacheados en lugar de recalcular
                final fontSize = _cachedFontSize ?? 24.0;
                final strokeWidth = _cachedStrokeWidth ?? 4.0;

                return CustomPaint(
                  painter: widget._painter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    // RepaintBoundary aísla repintados del Stack stroke + fill
                    child: RepaintBoundary(
                      child: Stack(
                        children: [
                          Transform.scale(
                            scaleY: widget._isWhiteText ? 1 : 1.23,
                            alignment: Alignment.bottomCenter,
                            child: BouncingText(
                              text: widget._text,
                              bounceUp: widget._bounceUp,
                              textStyle: TextStyle(
                                fontSize: fontSize,
                                letterSpacing: 5,
                                fontFamily: 'packages/fancy_titles/ManiaZoneCard',
                                decoration: TextDecoration.none,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = strokeWidth
                                  ..color = widget._textBorderColor,
                              ),
                            ),
                          ),
                          Transform.scale(
                            scaleY: widget._isWhiteText ? 1 : 1.23,
                            alignment: Alignment.bottomCenter,
                            child: BouncingText(
                              text: widget._text,
                              bounceUp: widget._bounceUp,
                              textStyle: TextStyle(
                                fontSize: fontSize,
                                letterSpacing: 5,
                                fontFamily: 'packages/fancy_titles/ManiaZoneCard',
                                decoration: TextDecoration.none,
                                foreground: Paint()
                                  ..style = PaintingStyle.fill
                                  ..color = widget._textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
