import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/pausable_animation_mixin.dart';
import 'package:fancy_titles/sonic_mania/animations/diagonal_slide_animation.dart';
import 'package:fancy_titles/sonic_mania/painters/text_bg_painters.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme_scope.dart';
import 'package:fancy_titles/sonic_mania/widgets/bouncing_text.dart';
import 'package:flutter/material.dart';

/// Tipo de barra de texto para resolver colores del tema.
enum _TextBarType {
  /// Barra con fondo negro.
  black,

  /// Barra con fondo blanco.
  white,

  /// Barra con colores personalizados.
  custom,
}

/// Barra de texto animada del splash de Sonic Mania.
///
/// Los colores pueden ser personalizados usando [SonicManiaTheme].
class TextBar extends StatefulWidget {
  /// Barra de texto con colores personalizados.
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
       _isWhiteText = isWhite,
       _textBarType = _TextBarType.custom;

  /// Barra con fondo negro y texto blanco.
  ///
  /// Los colores pueden ser personalizados con:
  /// - [SonicManiaTheme.textBarBlackColor] para el fondo
  /// - [SonicManiaTheme.textOnBlackColor] para el texto
  TextBar.black({
    required String text,
    required Offset beginOffset,
    required Offset endOffset,
    required Offset stopOffset,
    required Offset stopEndOffset,
    Color color = SonicManiaTextBarColors.blackBackground,
    Color textColor = SonicManiaTextBarColors.whiteText,
    Color textBorderColor = SonicManiaTextBarColors.blackBackground,
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
       _painter = LargeBGDraw(SonicManiaTextBarColors.blackBackground),
       _isWhiteText = false,
       _textBarType = _TextBarType.black;

  /// Barra con fondo blanco y texto negro.
  ///
  /// Los colores pueden ser personalizados con:
  /// - [SonicManiaTheme.textBarWhiteColor] para el fondo
  /// - [SonicManiaTheme.textOnWhiteColor] para el texto
  TextBar.white({
    required String text,
    required Offset beginOffset,
    required Offset endOffset,
    required Offset stopOffset,
    required Offset stopEndOffset,
    Color color = SonicManiaTextBarColors.whiteBackground,
    Color textColor = SonicManiaTextBarColors.blackText,
    Color textBorderColor = SonicManiaTextBarColors.whiteBackground,
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
       _painter = SmallBGDraw(SonicManiaTextBarColors.whiteBackground),
       _isWhiteText = true,
       _textBarType = _TextBarType.white;

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

  /// Tipo interno de barra de texto para resolución de colores del tema.
  final _TextBarType _textBarType;

  @override
  State<TextBar> createState() => _TextBarState();
}

class _TextBarState extends State<TextBar>
    with SingleTickerProviderStateMixin, PausableAnimationMixin {
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
      duration: SonicManiaTiming.slideIn,
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    registerAnimationController(_controller);

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
    delayedPausable(SonicManiaTiming.slideOutDelay, () {
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

  /// Resuelve el color de fondo de la barra basándose en el tema.
  Color _resolveBackgroundColor(BuildContext context) {
    final theme = SonicManiaThemeScope.maybeOf(context);
    if (theme == null) return widget._color;

    return switch (widget._textBarType) {
      _TextBarType.black => theme.textBarBlackColor ?? widget._color,
      _TextBarType.white => theme.textBarWhiteColor ?? widget._color,
      _TextBarType.custom => widget._color,
    };
  }

  /// Resuelve el color del texto basándose en el tema.
  Color _resolveTextColor(BuildContext context) {
    final theme = SonicManiaThemeScope.maybeOf(context);
    if (theme == null) return widget._textColor;

    return switch (widget._textBarType) {
      _TextBarType.black => theme.textOnBlackColor ?? widget._textColor,
      _TextBarType.white => theme.textOnWhiteColor ?? widget._textColor,
      _TextBarType.custom => widget._textColor,
    };
  }

  /// Resuelve el color del borde del texto basándose en el tema.
  Color _resolveBorderColor(BuildContext context) {
    final theme = SonicManiaThemeScope.maybeOf(context);
    if (theme == null) return widget._textBorderColor;

    return switch (widget._textBarType) {
      _TextBarType.black => theme.textBarBlackColor ?? widget._textBorderColor,
      _TextBarType.white => theme.textBarWhiteColor ?? widget._textBorderColor,
      _TextBarType.custom => widget._textBorderColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _resolveBackgroundColor(context);
    final textColor = _resolveTextColor(context);
    final borderColor = _resolveBorderColor(context);

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
                    child: SizedBox(child: ColoredBox(color: backgroundColor)),
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
                                  ..color = borderColor,
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
                                  ..color = textColor,
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
