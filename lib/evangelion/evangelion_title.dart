import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/evangelion/const/shadows.dart';
import 'package:fancy_titles/evangelion/flashlights/curtain.dart';
import 'package:fancy_titles/evangelion/flashlights/spark.dart';
import 'package:flutter/material.dart';

/// Pantalla de título inspirada en Neon Genesis Evangelion.
///
/// Muestra un título con el estilo visual icónico de Evangelion,
/// incluyendo la tipografía característica, destellos de luz (sparks)
/// y cortinas animadas que revelan el texto progresivamente.
///
/// ## Ejemplo de uso
///
/// ```dart
/// EvangelionTitle(
///   firstText: 'NEON',
///   secondText: 'GENESIS',
///   thirdText: 'EVANGELION',
///   fourthText: 'EPISODE:1',
///   fifthText: 'ANGEL ATTACK',
/// )
/// ```
///
/// ## Timeline de animación (5 segundos)
///
/// | Tiempo    | Evento                                |
/// |-----------|---------------------------------------|
/// | 0-450ms   | Fondo negro, preparación              |
/// | 450ms     | Texto aparece                         |
/// | 500-2500ms| Secuencia de sparks (destellos)       |
/// | 500-2500ms| Cortinas se deslizan revelando cruces |
/// | 3000ms    | Fondo se vuelve transparente          |
/// | 5000ms    | Widget se auto-destruye               |
///
/// ## Estructura del texto
///
/// El widget muestra 5 líneas de texto con diferentes tamaños:
/// - Líneas 1-2: Títulos cortos con fuente EVA Matisse Classic
/// - Línea 3: Título largo/principal con fuente EVA Matisse Classic
/// - Líneas 4-5: Subtítulos con fuente Arial
///
/// ## Valores por defecto
///
/// Si no se proporcionan textos, se usan los valores clásicos:
/// - firstText: 'NEON'
/// - secondText: 'GENESIS'
/// - thirdText: 'EVANGELION'
/// - fourthText: 'EPISODE:1'
/// - fifthText: 'ANGEL ATTACK'
///
/// ## Responsive
///
/// El widget ajusta automáticamente el tamaño de fuente basándose en
/// el tamaño de pantalla y orientación del dispositivo.
///
/// Los tiempos de animación están definidos en [EvangelionTiming].
///
/// Ver también:
/// - `SonicManiaSplash` para estilo Sonic Mania
/// - `Persona5Title` para estilo Persona 5
/// - `MarioMakerTitle` para estilo Mario Maker
class EvangelionTitle extends StatefulWidget {
  /// Crea una pantalla de título estilo Evangelion.
  ///
  /// Todos los parámetros de texto son opcionales y tienen valores
  /// por defecto que replican el título clásico de la serie.
  ///
  /// [firstText] primera línea del título (por defecto: 'NEON').
  /// Se muestra con fuente EVA Matisse Classic.
  ///
  /// [secondText] segunda línea del título (por defecto: 'GENESIS').
  /// Se muestra con fuente EVA Matisse Classic.
  ///
  /// [thirdText] línea principal/más grande (por defecto: 'EVANGELION').
  /// Se muestra con fuente EVA Matisse Classic en tamaño mayor.
  ///
  /// [fourthText] primera línea del subtítulo (por defecto: 'EPISODE:1').
  /// Se muestra con fuente Arial.
  ///
  /// [fifthText] segunda línea del subtítulo (por defecto: 'ANGEL ATTACK').
  /// Se muestra con fuente Arial, alineado a la derecha.
  ///
  /// Ejemplo con valores por defecto (título clásico):
  /// ```dart
  /// const EvangelionTitle()
  /// ```
  ///
  /// Ejemplo personalizado:
  /// ```dart
  /// const EvangelionTitle(
  ///   firstText: 'SHIN',
  ///   secondText: 'EVANGELION',
  ///   thirdText: 'MOVIE',
  ///   fourthText: '3.0+1.0',
  ///   fifthText: 'THRICE UPON A TIME',
  /// )
  /// ```
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

    Future.delayed(EvangelionTiming.textAppearDelay, () {
      if (!mounted) return;
      setState(() {
        _canShowText = true;
      });
    });

    Future.delayed(EvangelionTiming.backgroundFadeTime, () {
      if (!mounted) return;
      setState(() {
        _showTransparentBg = true;
      });
    });

    Future.delayed(EvangelionTiming.totalDuration, () {
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
      duration: EvangelionTiming.fadeTransition,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: _animationCompleted
          ? const SizedBox.shrink()
          : Stack(
              fit: StackFit.expand,
              children: [
                AnimatedContainer(
                  duration: EvangelionTiming.containerTransition,
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
