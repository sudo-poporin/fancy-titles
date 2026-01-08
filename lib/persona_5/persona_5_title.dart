import 'dart:async';

import 'package:fancy_titles/core/animation_phase.dart';
import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/cancelable_timers.dart';
import 'package:fancy_titles/persona_5/constants/constants.dart';
import 'package:fancy_titles/persona_5/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Pantalla de título inspirada en Persona 5.
///
/// Muestra una pantalla con fondo rojo y un círculo negro con espiral
/// que se expande, revelando una imagen y texto con el estilo visual
/// característico de Persona 5.
///
/// ## Ejemplo de uso
///
/// ```dart
/// Persona5Title(
///   text: 'TAKE YOUR TIME',
///   imagePath: 'assets/images/joker.png',
/// )
/// ```
///
/// ## Timeline de animación (4 segundos por defecto)
///
/// | Tiempo    | Evento                                |
/// |-----------|---------------------------------------|
/// | 0-125ms   | Delay inicial (configurable)         |
/// | 125ms     | Fondo rojo desaparece                 |
/// | 200ms     | Círculo negro con espiral aparece     |
/// | 400ms     | Texto e imagen entran deslizándose    |
/// | 3525ms    | Contenido comienza a desvanecerse     |
/// | 4000ms    | Widget se auto-destruye               |
///
/// ## Personalización
///
/// - `delay`: Tiempo antes de iniciar la animación principal
/// - `duration`: Duración de la fase principal de la animación
/// - `withImageBlendMode`: Aplica efecto de mezcla a la imagen
///
/// Los tiempos por defecto están definidos en [Persona5Timing].
///
/// ## Consideraciones de rendimiento
///
/// - La imagen se precachea automáticamente en `didChangeDependencies`
/// - En pantallas pequeñas (altura < 600px), el texto se oculta
///
/// ## Callbacks de ciclo de vida
///
/// El widget proporciona callbacks para sincronizar acciones externas:
/// - `onAnimationStart`: cuando la animación comienza
/// - `onAnimationComplete`: cuando la animación termina
/// - `onPhaseChange`: cuando cambia la fase de animación
///
/// ```dart
/// Persona5Title(
///   text: 'ALL OUT ATTACK',
///   onPhaseChange: (phase) {
///     if (phase == AnimationPhase.active) {
///       audioPlayer.play('reveal.mp3');
///     }
///   },
/// )
/// ```
///
/// Ver también:
/// - `SonicManiaSplash` para estilo Sonic Mania
/// - `EvangelionTitle` para estilo Evangelion
/// - `MarioMakerTitle` para estilo Mario Maker
class Persona5Title extends StatefulWidget {
  /// Crea una pantalla de título estilo Persona 5.
  ///
  /// [text] es requerido y se muestra debajo de la imagen con el estilo
  /// de fuente característico de Persona 5.
  ///
  /// [imagePath] es opcional. Si se proporciona, la imagen se muestra
  /// dentro del círculo animado. Soporta PNG, JPG y otros formatos de asset.
  ///
  /// [withImageBlendMode] si es `true`, aplica un modo de mezcla a la imagen
  /// para integrarla mejor con el fondo rojo. Por defecto es `false`.
  ///
  /// [delay] es el tiempo de espera antes de iniciar la animación.
  /// Por defecto es [Persona5Timing.initialDelay] (125ms).
  ///
  /// [duration] es la duración de la fase principal de la animación.
  /// Por defecto es [Persona5Timing.mainDuration] (3400ms).
  ///
  /// Ejemplo básico:
  /// ```dart
  /// Persona5Title(text: 'LOOKING COOL JOKER!')
  /// ```
  ///
  /// Ejemplo con imagen:
  /// ```dart
  /// Persona5Title(
  ///   text: 'ALL OUT ATTACK',
  ///   imagePath: 'assets/phantom_thieves.png',
  ///   withImageBlendMode: true,
  /// )
  /// ```
  ///
  /// Ejemplo con tiempos personalizados:
  /// ```dart
  /// Persona5Title(
  ///   text: 'SHOW TIME',
  ///   delay: const Duration(milliseconds: 500),
  ///   duration: const Duration(seconds: 5),
  /// )
  /// ```
  ///
  /// Ejemplo con callbacks:
  /// ```dart
  /// Persona5Title(
  ///   text: 'LOOKING COOL JOKER',
  ///   onAnimationStart: () => print('Animación iniciada'),
  ///   onAnimationComplete: () => print('Animación completada'),
  ///   onPhaseChange: (phase) => print('Fase: $phase'),
  /// )
  /// ```
  const Persona5Title({
    required String text,
    String? imagePath,
    bool withImageBlendMode = false,
    Duration delay = Persona5Timing.initialDelay,
    Duration duration = Persona5Timing.mainDuration,
    VoidCallback? onAnimationStart,
    VoidCallback? onAnimationComplete,
    void Function(AnimationPhase phase)? onPhaseChange,
    super.key,
  }) : _text = text,
       _imagePath = imagePath,
       _delay = delay,
       _duration = duration,
       _withImageBlendMode = withImageBlendMode,
       _onAnimationStart = onAnimationStart,
       _onAnimationComplete = onAnimationComplete,
       _onPhaseChange = onPhaseChange;

  final Duration _delay;
  final Duration _duration;
  final String _text;
  final String? _imagePath;
  final bool _withImageBlendMode;

  /// Callback ejecutado cuando la animación comienza.
  final VoidCallback? _onAnimationStart;

  /// Callback ejecutado cuando la animación termina completamente.
  final VoidCallback? _onAnimationComplete;

  /// Callback ejecutado cuando cambia la fase de la animación.
  final void Function(AnimationPhase phase)? _onPhaseChange;

  @override
  State<Persona5Title> createState() => _Persona5TitleState();
}

class _Persona5TitleState extends State<Persona5Title>
    with SingleTickerProviderStateMixin, CancelableTimersMixin {
  late bool _animationCompleted = false;
  bool _showBackground = true;
  bool _showText = false;
  bool _imagePrecached = false;

  AnimationPhase _currentPhase = AnimationPhase.idle;

  @override
  void initState() {
    super.initState();
    _showBackground = true;
    _showText = false;

    // Start animation lifecycle
    _updatePhase(AnimationPhase.entering);
    widget._onAnimationStart?.call();

    _initBackgroundAnimationSequence();
    _initTextAnimationSequence();
    _initWidgetAutoDestructionSequence();
  }

  /// Initializes the background visibility sequence
  void _initBackgroundAnimationSequence() {
    // Hide background after initial delay
    delayed(widget._delay, () {
      setState(() => _showBackground = false);
    });

    // Show background again after delay + duration (exiting phase)
    delayed(widget._delay + widget._duration, () {
      _updatePhase(AnimationPhase.exiting);
      setState(() => _showBackground = true);
    });
  }

  /// Initializes the text visibility sequence
  void _initTextAnimationSequence() {
    // Show text after textAppearDelay
    delayed(Persona5Timing.textAppearDelay, () {
      _updatePhase(AnimationPhase.active);
      setState(() => _showText = true);
    });

    // Hide text after textAppearDelay + duration
    delayed(Persona5Timing.textAppearDelay + widget._duration, () {
      setState(() => _showText = false);
    });
  }

  /// Updates the current phase and notifies listeners
  void _updatePhase(AnimationPhase newPhase) {
    if (_currentPhase != newPhase) {
      _currentPhase = newPhase;
      widget._onPhaseChange?.call(newPhase);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImageIfNeeded();
  }

  void _precacheImageIfNeeded() {
    if (!_imagePrecached && widget._imagePath != null) {
      _imagePrecached = true;
      unawaited(
        precacheImage(AssetImage(widget._imagePath!), context),
      );
    }
  }

  /// Inicializa la secuencia de autodestrucción del widget
  void _initWidgetAutoDestructionSequence() {
    delayed(Persona5Timing.totalDuration, () {
      _updatePhase(AnimationPhase.completed);
      widget._onAnimationComplete?.call();
      setState(() {
        _animationCompleted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final height = MediaQuery.sizeOf(context).height;
    final padding = orientation == Orientation.portrait
        ? height * 0.3
        : height * 0.5;

    final canShowText = height > 600;

    return AnimatedSwitcher(
      duration: Duration.zero,
      reverseDuration: Persona5Timing.fadeTransitionReverse,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _animationCompleted
          ? const SizedBox.shrink()
          : Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox.expand(child: ColoredBox(color: redColor)),
                AnimatedSwitcher(
                  reverseDuration: Persona5Timing.circleTransitionDuration,
                  duration: Persona5Timing.circleTransitionDuration,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _showBackground
                      ? const SizedBox.shrink()
                      : const BackgroundCircle(),
                ),
                AnimatedSwitcher(
                  duration: Persona5Timing.fadeTransitionReverse,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, -0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _showText
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  top: 0,
                                  child: Persona5Image(
                                    imagePath: widget._imagePath,
                                    withImageBlendMode:
                                        widget._withImageBlendMode,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: padding,
                                    right: 20,
                                    left: 20,
                                  ),
                                  child: canShowText
                                      ? Persona5Text(text: widget._text)
                                      : const SizedBox(width: 250),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
    );
  }
}
