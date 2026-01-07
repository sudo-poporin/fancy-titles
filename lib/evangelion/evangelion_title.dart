import 'package:fancy_titles/evangelion/const/shadows.dart';
import 'package:fancy_titles/evangelion/flashlights/curtain.dart';
import 'package:fancy_titles/evangelion/flashlights/spark.dart';
import 'package:flutter/material.dart';

/// Evangelion Title
class EvangelionTitle extends StatefulWidget {
  /// Shows an Evangelion styled title
  ///
  /// The title is shown in the Evangelion font style
  const EvangelionTitle({
    String? firstText,
    String? secondText,
    String? thirdText,
    String? fourthText,
    String? fifthText,
    super.key,
  }) : _firstText = firstText ?? 'NEON',
       _secondText = secondText ?? 'GENESIS',
       _thirdText = thirdText ?? 'EVANGELION',
       _fourthText = fourthText ?? 'EPISODE:1',
       _fifthText = fifthText ?? 'ANGEL ATTACK';

  final String _firstText;
  final String _secondText;
  final String _thirdText;
  final String _fourthText;
  final String _fifthText;

  @override
  State<EvangelionTitle> createState() => _EvangelionTitleState();
}

class _EvangelionTitleState extends State<EvangelionTitle>
    with SingleTickerProviderStateMixin {
  bool _canShowText = false;
  bool _animationCompleted = false;
  bool _showTransparentBg = false;

  // Valores cacheados para evitar recálculos
  double _shortTitleFontSize = 78;
  double _longTitleFontSize = 120;
  double _subtitle = 48;
  Size? _cachedScreenSize;
  Orientation? _cachedOrientation;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      setState(() {
        _canShowText = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      setState(() {
        _showTransparentBg = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 5000), () {
      if (!mounted) return;
      setState(() {
        _animationCompleted = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCachedFontSizes();
  }

  void _updateCachedFontSizes() {
    final orientation = MediaQuery.orientationOf(context);
    final screenSize = MediaQuery.sizeOf(context);

    // Solo recalcular si cambiaron las dependencias
    if (_cachedOrientation != orientation || _cachedScreenSize != screenSize) {
      _cachedOrientation = orientation;
      _cachedScreenSize = screenSize;

      // If the screen is small, e.g. mobile devices, scale the text
      if (screenSize.shortestSide < 800) {
        final textScaler = orientation == Orientation.portrait
            ? 250 / screenSize.width
            : 200 / screenSize.height;

        _shortTitleFontSize = 78.0 * textScaler;
        _longTitleFontSize = 120.0 * textScaler;
        _subtitle = 78.0 * textScaler;
      } else {
        final textScaler = orientation == Orientation.portrait
            ? screenSize.height / screenSize.width
            : screenSize.width / screenSize.height;

        _shortTitleFontSize = 78.0 * textScaler;
        _longTitleFontSize = 120.0 * textScaler;
        _subtitle = 48.0 * textScaler;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 125),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: _animationCompleted
          ? const SizedBox.shrink()
          : Stack(
              fit: StackFit.expand,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 275),
                  color: _showTransparentBg
                      ? Colors.transparent
                      : const Color(0xFF040404),
                  child: _canShowText
                      ? SafeArea(
                          child: Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                flex: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(flex: 3),
                                    Transform.scale(
                                      scaleY: 1.37,
                                      child: FittedBox(
                                        child: Text(
                                          widget._firstText,
                                          style: TextStyle(
                                            color: const Color(0xFFF1EEFF),
                                            fontSize: _shortTitleFontSize,
                                            letterSpacing: -5.9,
                                            decoration: TextDecoration.none,
                                            fontFamily:
                                                'packages/fancy_titles/EVAMatisseClassic',
                                            shadows: shadows,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Transform.scale(
                                      scaleY: 1.37,
                                      child: FittedBox(
                                        child: Text(
                                          widget._secondText,
                                          style: TextStyle(
                                            color: const Color(0xFFF1EEFF),
                                            fontSize: _shortTitleFontSize,
                                            letterSpacing: -5.9,
                                            decoration: TextDecoration.none,
                                            fontFamily:
                                                'packages/fancy_titles/EVAMatisseClassic',
                                            shadows: shadows,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Transform.scale(
                                      scaleY: 1.52,
                                      child: FittedBox(
                                        child: Text(
                                          widget._thirdText,
                                          style: TextStyle(
                                            color: const Color(0xFFF1EEFF),
                                            fontSize: _longTitleFontSize,
                                            letterSpacing: -5.9,
                                            decoration: TextDecoration.none,
                                            fontFamily:
                                                'packages/fancy_titles/EVAMatisseClassic',
                                            shadows: shadows,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Spacer(),
                                    FittedBox(
                                      child: Transform.scale(
                                        scaleY: 1.21,
                                        child: Text(
                                          widget._fourthText,
                                          style: TextStyle(
                                            color: const Color(0xFFF1EEFF),
                                            fontSize: _subtitle,
                                            letterSpacing: -3.5,
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Arial',
                                            shadows: shadows,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Transform.scale(
                                        scaleY: 1.21,
                                        child: Text(
                                          widget._fifthText,
                                          style: TextStyle(
                                            color: const Color(0xFFF1EEFF),
                                            fontSize: _subtitle,
                                            letterSpacing: -3.5,
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Arial',
                                            shadows: shadows,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(flex: 3),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    Curtain.first(),
                    Curtain.second(),
                    Curtain.third(),
                    Curtain.fourth(),
                    Curtain.fifth(),
                    Curtain.sixth(),
                  ],
                ),
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    Spark.first(),
                    Spark.second(),
                    Spark.fourth(),
                    Spark.third(),
                    Spark.fifth(),
                    Spark.sixth(),
                  ],
                ),
              ],
            ),
    );
  }
}
