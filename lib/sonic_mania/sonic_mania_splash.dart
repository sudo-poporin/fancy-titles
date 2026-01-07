import 'package:fancy_titles/core/animation_phase.dart';
import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/sonic_mania/clippers/clippers.dart';
import 'package:fancy_titles/sonic_mania/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Pantalla de título inspirada en Sonic Mania.
///
/// Muestra barras diagonales animadas con texto que rebota,
/// inspirado en las pantallas de selección de nivel de Sonic Mania.
///
/// ## Ejemplo de uso
///
/// ```dart
/// SonicManiaSplash(
///   baseText: 'STUDIOPOLIS',
///   secondaryText: 'ZONE',
///   lastText: 'ACT1',
/// )
/// ```
///
/// ## Timeline de animación (5 segundos)
///
/// | Tiempo    | Evento                                |
/// |-----------|---------------------------------------|
/// | 0-600ms   | Barras se deslizan hacia el centro   |
/// | 600ms     | Texto aparece con efecto de rebote   |
/// | 3500ms    | Barras se deslizan hacia afuera      |
/// | 5000ms    | Widget se auto-destruye              |
///
/// ## Restricciones
///
/// - `lastText` no puede exceder 4 caracteres
/// - `baseText` se muestra en MAYÚSCULAS
/// - `secondaryText` se muestra en MAYÚSCULAS
/// - `lastText` se muestra en minúsculas
///
/// ## Personalización de tiempos
///
/// Los tiempos de animación están definidos en [SonicManiaTiming].
/// Actualmente no es posible personalizarlos por instancia.
///
/// ## Callbacks de ciclo de vida
///
/// El widget proporciona callbacks para sincronizar acciones externas:
/// - `onAnimationStart`: cuando la animación comienza
/// - `onAnimationComplete`: cuando la animación termina
/// - `onPhaseChange`: cuando cambia la fase de animación
///
/// ```dart
/// SonicManiaSplash(
///   baseText: 'LEVEL 1',
///   onAnimationStart: () => audioPlayer.play('intro.mp3'),
///   onAnimationComplete: () => Navigator.pushReplacement(...),
///   onPhaseChange: (phase) {
///     if (phase == AnimationPhase.active) {
///       // Texto visible, reproducir sonido
///     }
///   },
/// )
/// ```
///
/// Ver también:
/// - `Persona5Title` para estilo Persona 5
/// - `EvangelionTitle` para estilo Evangelion
/// - `MarioMakerTitle` para estilo Mario Maker
class SonicManiaSplash extends StatefulWidget {
  /// Crea una pantalla de título estilo Sonic Mania.
  ///
  /// [baseText] es requerido y se muestra en la primera barra (MAYÚSCULAS).
  ///
  /// [secondaryText] es opcional y se muestra en la segunda barra (MAYÚSCULAS).
  /// Cuando está presente, el layout de las barras se ajusta para acomodar
  /// tres líneas de texto.
  ///
  /// [lastText] es opcional y se muestra en la tercera barra (minúsculas).
  /// Máximo 4 caracteres. Lanza [FlutterError] si excede este límite.
  ///
  /// Ejemplo con una línea:
  /// ```dart
  /// SonicManiaSplash(baseText: 'TITLE')
  /// ```
  ///
  /// Ejemplo con dos líneas:
  /// ```dart
  /// SonicManiaSplash(
  ///   baseText: 'GREEN HILL',
  ///   secondaryText: 'ZONE',
  /// )
  /// ```
  ///
  /// Ejemplo completo:
  /// ```dart
  /// SonicManiaSplash(
  ///   baseText: 'CHEMICAL PLANT',
  ///   secondaryText: 'ZONE',
  ///   lastText: 'ACT2',
  /// )
  /// ```
  ///
  /// Ejemplo con callbacks:
  /// ```dart
  /// SonicManiaSplash(
  ///   baseText: 'GREEN HILL',
  ///   onAnimationStart: () => print('Animación iniciada'),
  ///   onAnimationComplete: () => print('Animación completada'),
  ///   onPhaseChange: (phase) => print('Fase: $phase'),
  /// )
  /// ```
  SonicManiaSplash({
    required String baseText,
    String? secondaryText,
    String? lastText,
    VoidCallback? onAnimationStart,
    VoidCallback? onAnimationComplete,
    void Function(AnimationPhase phase)? onPhaseChange,
    super.key,
  }) : _baseText = baseText,
       _secondaryText = secondaryText,
       _lastText = lastText,
       _onAnimationStart = onAnimationStart,
       _onAnimationComplete = onAnimationComplete,
       _onPhaseChange = onPhaseChange {
    if (_lastText != null && _lastText.length > 4) {
      throw FlutterError('El tercer texto no puede tener más de 4 caracteres');
    }
  }

  final String _baseText;
  final String? _secondaryText;
  final String? _lastText;

  /// Callback ejecutado cuando la animación comienza.
  final VoidCallback? _onAnimationStart;

  /// Callback ejecutado cuando la animación termina completamente.
  final VoidCallback? _onAnimationComplete;

  /// Callback ejecutado cuando cambia la fase de la animación.
  final void Function(AnimationPhase phase)? _onPhaseChange;

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

  AnimationPhase _currentPhase = AnimationPhase.idle;

  @override
  void initState() {
    super.initState();

    firstTextVerticalOffset = widget._secondaryText != null ? -1.0 : -0.5;
    lastTextVerticalOffset = widget._secondaryText != null ? 0.8 : 0.5;
    lastTextHorizontalOffset = widget._secondaryText != null ? 0.7 : 0.3;
    lastTextOriginOffset = widget._secondaryText != null ? -10 : 10;

    lastTextInvertedValue = widget._secondaryText != null ? 1.0 : -1.0;

    // Start animation lifecycle
    _updatePhase(AnimationPhase.entering);
    widget._onAnimationStart?.call();

    _initAnimationPhases();
  }

  /// Updates the current phase and notifies listeners
  void _updatePhase(AnimationPhase newPhase) {
    if (_currentPhase != newPhase) {
      _currentPhase = newPhase;
      widget._onPhaseChange?.call(newPhase);
    }
  }

  /// Initializes the animation phase sequence
  void _initAnimationPhases() {
    // Phase: entering → active (after slide in completes)
    Future.delayed(SonicManiaTiming.slideIn, () {
      if (!mounted) return;
      _updatePhase(AnimationPhase.active);
    });

    // Phase: active → exiting (when slide out starts)
    Future.delayed(SonicManiaTiming.slideOutDelay, () {
      if (!mounted) return;
      _updatePhase(AnimationPhase.exiting);
    });

    // Phase: exiting → completed (auto-destruction)
    Future.delayed(SonicManiaTiming.totalDuration, () {
      if (!mounted) return;
      _updatePhase(AnimationPhase.completed);
      widget._onAnimationComplete?.call();
      setState(() {
        _animationCompleted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: SonicManiaTiming.fadeTransition,
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
