import 'package:fancy_titles/core/animation_phase.dart';
import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/fancy_title_controller_scope.dart';
import 'package:fancy_titles/core/pausable_animation_mixin.dart';
import 'package:fancy_titles/evangelion/evangelion_theme.dart';
import 'package:fancy_titles/evangelion/evangelion_theme_scope.dart';
import 'package:fancy_titles/evangelion/evangelion_title_controller.dart';
import 'package:fancy_titles/evangelion/widgets/widgets.dart';
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
/// ## Control programático
///
/// Se puede controlar la animación usando un [EvangelionTitleController]:
///
/// ```dart
/// final controller = EvangelionTitleController();
///
/// EvangelionTitle(
///   firstText: 'NEON',
///   secondText: 'GENESIS',
///   controller: controller,
/// )
///
/// // Pausar/reanudar
/// controller.pause();
/// controller.resume();
///
/// // Saltar al final
/// controller.skipToEnd();
/// ```
///
/// ## Callbacks de ciclo de vida
///
/// El widget proporciona callbacks para sincronizar acciones externas:
/// - `onAnimationStart`: cuando la animación comienza
/// - `onAnimationComplete`: cuando la animación termina
/// - `onPhaseChange`: cuando cambia la fase de animación
///
/// ```dart
/// EvangelionTitle(
///   firstText: 'EPISODE:25',
///   onAnimationComplete: () => Navigator.pushReplacement(...),
///   onPhaseChange: (phase) {
///     if (phase == AnimationPhase.active) {
///       audioPlayer.play('cruel_angel_thesis.mp3');
///     }
///   },
/// )
/// ```
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
  ///
  /// Ejemplo con callbacks:
  /// ```dart
  /// EvangelionTitle(
  ///   onAnimationStart: () => print('Animación iniciada'),
  ///   onAnimationComplete: () => print('Animación completada'),
  ///   onPhaseChange: (phase) => print('Fase: $phase'),
  /// )
  /// ```
  ///
  /// Ejemplo con controller:
  /// ```dart
  /// final controller = EvangelionTitleController();
  ///
  /// EvangelionTitle(
  ///   firstText: 'NEON',
  ///   controller: controller,
  /// )
  ///
  /// // Luego puedes controlar la animación:
  /// controller.pause();
  /// controller.resume();
  /// controller.skipToEnd();
  /// ```
  ///
  /// Ejemplo con tema personalizado:
  /// ```dart
  /// EvangelionTitle(
  ///   firstText: 'NEON',
  ///   theme: EvangelionTheme(
  ///     backgroundColor: Colors.deepPurple.shade900,
  ///     textColor: Colors.amber,
  ///   ),
  /// )
  /// ```
  const EvangelionTitle({
    String? firstText,
    String? secondText,
    String? thirdText,
    String? fourthText,
    String? fifthText,
    EvangelionTitleController? controller,
    EvangelionTheme? theme,
    VoidCallback? onAnimationStart,
    VoidCallback? onAnimationComplete,
    void Function(AnimationPhase phase)? onPhaseChange,
    super.key,
  }) : _firstText = firstText ?? 'NEON',
       _secondText = secondText ?? 'GENESIS',
       _thirdText = thirdText ?? 'EVANGELION',
       _fourthText = fourthText ?? 'EPISODE:1',
       _fifthText = fifthText ?? 'ANGEL ATTACK',
       _controller = controller,
       _theme = theme,
       _onAnimationStart = onAnimationStart,
       _onAnimationComplete = onAnimationComplete,
       _onPhaseChange = onPhaseChange;

  final String _firstText;
  final String _secondText;
  final String _thirdText;
  final String _fourthText;
  final String _fifthText;

  /// Controller opcional para control programático de la animación.
  final EvangelionTitleController? _controller;

  /// Tema personalizado para colores.
  /// Si es null, usa los colores por defecto de Evangelion.
  final EvangelionTheme? _theme;

  /// Callback ejecutado cuando la animación comienza.
  final VoidCallback? _onAnimationStart;

  /// Callback ejecutado cuando la animación termina completamente.
  final VoidCallback? _onAnimationComplete;

  /// Callback ejecutado cuando cambia la fase de la animación.
  final void Function(AnimationPhase phase)? _onPhaseChange;

  @override
  State<EvangelionTitle> createState() => _EvangelionTitleState();
}

class _EvangelionTitleState extends State<EvangelionTitle>
    with SingleTickerProviderStateMixin, PausableAnimationMixin {
  bool _canShowText = false;
  bool _animationCompleted = false;
  bool _showTransparentBg = false;

  // Valores cacheados para evitar recálculos
  double _shortTitleFontSize = 78;
  double _longTitleFontSize = 120;
  double _subtitle = 48;
  Size? _cachedScreenSize;
  Orientation? _cachedOrientation;

  AnimationPhase _currentPhase = AnimationPhase.idle;

  // Key para forzar rebuild cuando se hace reset
  Key _contentKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    // Escuchar cambios del controller
    widget._controller?.addListener(_onControllerChanged);

    // Start animation lifecycle
    _updatePhase(AnimationPhase.entering);
    widget._onAnimationStart?.call();

    _initAnimationSequences();
  }

  @override
  void dispose() {
    widget._controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    final controller = widget._controller;
    if (controller == null) return;

    // Manejar skipToEnd
    if (controller.isCompleted && _currentPhase != AnimationPhase.completed) {
      _handleSkipToEnd();
    }

    // Manejar reset
    if (controller.currentPhase == AnimationPhase.idle &&
        _currentPhase != AnimationPhase.idle) {
      _handleReset();
    }
  }

  void _handleSkipToEnd() {
    _updatePhase(AnimationPhase.completed);
    widget._onAnimationComplete?.call();
    setState(() {
      _animationCompleted = true;
    });
  }

  void _handleReset() {
    setState(() {
      _animationCompleted = false;
      _canShowText = false;
      _showTransparentBg = false;
      _currentPhase = AnimationPhase.idle;
      _contentKey = UniqueKey(); // Forzar rebuild de widgets hijos
    });

    // Reiniciar el ciclo de animación
    _updatePhase(AnimationPhase.entering);
    widget._onAnimationStart?.call();
    _initAnimationSequences();
  }

  /// Initializes all animation sequences
  void _initAnimationSequences() {
    delayedPausable(EvangelionTiming.textAppearDelay, () {
      _updatePhase(AnimationPhase.active);
      setState(() {
        _canShowText = true;
      });
    });

    delayedPausable(EvangelionTiming.backgroundFadeTime, () {
      _updatePhase(AnimationPhase.exiting);
      setState(() {
        _showTransparentBg = true;
      });
    });

    delayedPausable(EvangelionTiming.totalDuration, () {
      _updatePhase(AnimationPhase.completed);
      widget._onAnimationComplete?.call();
      setState(() {
        _animationCompleted = true;
      });
    });
  }

  /// Updates the current phase and notifies listeners
  void _updatePhase(AnimationPhase newPhase) {
    if (_currentPhase != newPhase) {
      _currentPhase = newPhase;
      widget._controller?.updatePhase(newPhase);
      widget._onPhaseChange?.call(newPhase);
    }
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

  /// Resuelve el color de fondo usando el theme o el color por defecto.
  Color _resolveBackgroundColor() {
    return widget._theme?.backgroundColor ?? EvangelionColors.background;
  }

  /// Resuelve el color del texto usando el theme o el color por defecto.
  Color _resolveTextColor() {
    return widget._theme?.textColor ?? EvangelionColors.text;
  }

  /// Resuelve las sombras usando el theme o los valores por defecto.
  List<Shadow> _resolveShadows() {
    final shadowColor =
        widget._theme?.textShadowColor ?? EvangelionColors.textShadow;
    return [
      Shadow(color: shadowColor, offset: const Offset(0, 1), blurRadius: 12),
      Shadow(color: shadowColor, offset: const Offset(0, -1), blurRadius: 12),
      Shadow(color: shadowColor, offset: const Offset(1, 0), blurRadius: 12),
      Shadow(color: shadowColor, offset: const Offset(-1, 0), blurRadius: 12),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _resolveBackgroundColor();
    final textColor = _resolveTextColor();
    final textShadows = _resolveShadows();

    Widget content = AnimatedSwitcher(
      duration: EvangelionTiming.fadeTransition,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: _animationCompleted
          ? const SizedBox.shrink()
          : Stack(
              key: _contentKey,
              fit: StackFit.expand,
              children: [
                AnimatedContainer(
                  duration: EvangelionTiming.containerTransition,
                  color: _showTransparentBg
                      ? Colors.transparent
                      : backgroundColor,
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
                                            color: textColor,
                                            fontSize: _shortTitleFontSize,
                                            letterSpacing: -5.9,
                                            decoration: TextDecoration.none,
                                            fontFamily:
                                                'packages/fancy_titles/EVAMatisseClassic',
                                            shadows: textShadows,
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
                                            color: textColor,
                                            fontSize: _shortTitleFontSize,
                                            letterSpacing: -5.9,
                                            decoration: TextDecoration.none,
                                            fontFamily:
                                                'packages/fancy_titles/EVAMatisseClassic',
                                            shadows: textShadows,
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
                                            color: textColor,
                                            fontSize: _longTitleFontSize,
                                            letterSpacing: -5.9,
                                            decoration: TextDecoration.none,
                                            fontFamily:
                                                'packages/fancy_titles/EVAMatisseClassic',
                                            shadows: textShadows,
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
                                            color: textColor,
                                            fontSize: _subtitle,
                                            letterSpacing: -3.5,
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Arial',
                                            shadows: textShadows,
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
                                            color: textColor,
                                            fontSize: _subtitle,
                                            letterSpacing: -3.5,
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Arial',
                                            shadows: textShadows,
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

    // Envolver con el scope del theme si existe
    if (widget._theme != null) {
      content = EvangelionThemeScope(
        theme: widget._theme!,
        child: content,
      );
    }

    // Envolver con el scope del controller si existe
    if (widget._controller != null) {
      content = FancyTitleControllerScope(
        controller: widget._controller!,
        child: content,
      );
    }

    return content;
  }
}
