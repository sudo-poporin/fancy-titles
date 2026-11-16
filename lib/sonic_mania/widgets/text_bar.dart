import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/cancelable_timers.dart';
import 'package:fancy_titles/sonic_mania/animations/diagonal_slide_animation.dart';
import 'package:fancy_titles/sonic_mania/clippers/bar_clipper.dart';
import 'package:fancy_titles/sonic_mania/painters/text_bg_painters.dart';
import 'package:fancy_titles/sonic_mania/widgets/bouncing_text.dart';
import 'package:flutter/widgets.dart';

const Color _kDefaultBlackColor = Color(0xFF212121);
const Color _kDefaultWhiteColor = Color(0xFFF3F3F3);

/// Barra de texto
class TextBar extends StatefulWidget {
  /// Barra de texto
  // coverage:ignore-start
  const new({
    required this._color,
    required this._text,
    required this._textColor,
    this._textBorderColor = const Color(0x00000000),
    this._beginOffset = const Offset(-2, 0),
    this._endOffset = const Offset(2, 0),
    this._stopOffset = const Offset(-0.2, 0),
    this._stopEndOffset = const Offset(-2, 0),
    this._painter,
    this._bounceUp = true,
    bool isWhite = false,
    super.key,
  }) : _isWhiteText = isWhite,
       _slantedBar = false,
       _stripeArea = null;
  // coverage:ignore-end

  /// Barra negra, con el título principal.
  ///
  /// Sus extremos se inclinan con la pendiente de las franjas del fondo:
  /// [stripeSlope] de `stripeArea`, el área que ocupan las franjas, o de la
  /// pantalla si es `null`. Se rearman cuando cambia ese tamaño, por ejemplo
  /// al rotar. `color` rellena la barra.
  const new black({
    required this._text,
    required this._beginOffset,
    required this._endOffset,
    required this._stopOffset,
    required this._stopEndOffset,
    this._color = _kDefaultBlackColor,
    this._textColor = _kDefaultWhiteColor,
    this._textBorderColor = _kDefaultBlackColor,
    this._bounceUp = true,
    this._stripeArea,
    super.key,
  }) : _painter = null,
       _isWhiteText = false,
       _slantedBar = true;

  /// Barra blanca, con el subtítulo.
  ///
  /// Sus extremos se inclinan con la pendiente de las franjas del fondo:
  /// [stripeSlope] de `stripeArea`, el área que ocupan las franjas, o de la
  /// pantalla si es `null`. Se rearman cuando cambia ese tamaño, por ejemplo
  /// al rotar. `color` rellena la barra.
  const new white({
    required this._text,
    required this._beginOffset,
    required this._endOffset,
    required this._stopOffset,
    required this._stopEndOffset,
    this._color = _kDefaultWhiteColor,
    this._textColor = _kDefaultBlackColor,
    this._textBorderColor = _kDefaultWhiteColor,
    this._bounceUp = false,
    this._stripeArea,
    super.key,
  }) : _painter = null,
       _isWhiteText = true,
       _slantedBar = true;

  final String _text;
  final Color _color;
  final Color _textColor;
  final Color _textBorderColor;
  final Offset _beginOffset;
  final Offset _endOffset;
  final Offset _stopOffset;
  final Offset _stopEndOffset;
  final CustomPainter? _painter;
  final bool _bounceUp;
  final bool _isWhiteText;

  // true en .black y .white: el painter lo arma el estado con la pendiente
  // de [_stripeArea]. En el constructor genérico se usa [_painter] tal cual.
  final bool _slantedBar;

  // Tamaño del área de las franjas; si es null, el de la pantalla.
  final Size? _stripeArea;

  @override
  State<TextBar> createState() => _TextBarState();
}

class _TextBarState extends State<TextBar>
    with SingleTickerProviderStateMixin, CancelableTimersMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late Offset _beginOffset;
  late Offset _endOffset;
  late bool _canShowText;

  double? _cachedFontSize;
  double? _cachedStrokeWidth;
  Orientation? _cachedOrientation;
  Size? _cachedScreenSize;

  @override
  void initState() {
    super.initState();
    _canShowText = false;
    _beginOffset = widget._beginOffset;
    _endOffset = widget._endOffset;

    _controller = AnimationController(
      duration: SonicManiaTiming.slideIn,
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _startAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCachedSizes();
  }

  void _updateCachedSizes() {
    final orientation = MediaQuery.orientationOf(context);
    final screenSize = MediaQuery.sizeOf(context);

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

  CustomPainter? _buildBarPainter(double slope) {
    if (!widget._slantedBar) return widget._painter;
    return widget._isWhiteText
        ? SmallBGDraw(widget._color, slope: slope)
        : LargeBGDraw(widget._color, slope: slope);
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

  void _slideIn() {
    setState(() => _beginOffset = widget._stopOffset);
    _controller.reverse();
  }

  void _slideOut() {
    setState(() => _canShowText = true);
    delayed(SonicManiaTiming.slideOutDelay, () {
      setState(() => _endOffset = widget._stopEndOffset);
      _controller.forward();
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
    final screenWidth =
        _cachedScreenSize?.width ?? MediaQuery.sizeOf(context).width;
    final fontSize = _cachedFontSize ?? 24.0;
    final strokeWidth = _cachedStrokeWidth ?? 4.0;

    return HorizontalSlideTransition(
      animation: _animation,
      beginOffset: _beginOffset,
      endOffset: _endOffset,
      child: Stack(
        children: [
          if (!_canShowText)
            _PlaceholderBar(
              color: widget._color,
              minWidth: screenWidth * 0.5,
              minHeight: fontSize,
            ),
          if (_canShowText)
            _TextContent(
              text: widget._text,
              textColor: widget._textColor,
              textBorderColor: widget._textBorderColor,
              fontSize: fontSize,
              strokeWidth: strokeWidth,
              painter: _buildBarPainter(
                stripeSlope(widget._stripeArea ?? _cachedScreenSize!),
              ),
              bounceUp: widget._bounceUp,
              isWhiteText: widget._isWhiteText,
            ),
        ],
      ),
    );
  }
}

class _PlaceholderBar extends StatelessWidget {
  const new({
    required this.color,
    required this.minWidth,
    required this.minHeight,
  });

  final Color color;
  final double minWidth;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
        child: ColoredBox(color: color),
      ),
    );
  }
}

class _TextContent extends StatelessWidget {
  const new({
    required this.text,
    required this.textColor,
    required this.textBorderColor,
    required this.fontSize,
    required this.strokeWidth,
    required this.painter,
    required this.bounceUp,
    required this.isWhiteText,
  });

  final String text;
  final Color textColor;
  final Color textBorderColor;
  final double fontSize;
  final double strokeWidth;
  final CustomPainter? painter;
  final bool bounceUp;
  final bool isWhiteText;

  @override
  Widget build(BuildContext context) {
    final scaleY = isWhiteText ? 1.0 : 1.23;

    return CustomPaint(
      painter: painter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: RepaintBoundary(
          child: Stack(
            children: [
              Transform.scale(
                scaleY: scaleY,
                alignment: Alignment.bottomCenter,
                child: BouncingText(
                  text: text,
                  bounceUp: bounceUp,
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    letterSpacing: 5,
                    fontFamily: 'packages/fancy_titles/ManiaZoneCard',
                    decoration: TextDecoration.none,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = strokeWidth
                      ..color = textBorderColor,
                  ),
                ),
              ),
              Transform.scale(
                scaleY: scaleY,
                alignment: Alignment.bottomCenter,
                child: BouncingText(
                  text: text,
                  bounceUp: bounceUp,
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
  }
}
