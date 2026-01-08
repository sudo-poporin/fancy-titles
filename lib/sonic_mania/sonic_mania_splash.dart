import 'package:fancy_titles/core/animation_phase.dart';
import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/fancy_title_controller_scope.dart';
import 'package:fancy_titles/core/pausable_animation_mixin.dart';
import 'package:fancy_titles/sonic_mania/clippers/clippers.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_splash_controller.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme_scope.dart';
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
/// ## Control programático
///
/// Se puede controlar la animación usando un [SonicManiaSplashController]:
///
/// ```dart
/// final controller = SonicManiaSplashController();
///
/// SonicManiaSplash(
///   baseText: 'LEVEL 1',
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
/// ## Personalización de colores
///
/// Se puede personalizar los colores usando [SonicManiaTheme]:
///
/// ```dart
/// SonicManiaSplash(
///   baseText: 'LEVEL 1',
///   theme: SonicManiaTheme(
///     redBarColor: Colors.purple,
///     orangeBarColor: Colors.pink,
///     blueCurtainColor: Colors.indigo,
///   ),
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
  /// [controller] es opcional y permite control programático de la animación.
  ///
  /// [theme] es opcional y permite personalizar los colores del widget.
  /// Si es `null`, se usan los colores por defecto de Sonic Mania.
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
  /// Ejemplo con controller:
  /// ```dart
  /// final controller = SonicManiaSplashController();
  ///
  /// SonicManiaSplash(
  ///   baseText: 'GREEN HILL',
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
  /// SonicManiaSplash(
  ///   baseText: 'GREEN HILL',
  ///   theme: SonicManiaTheme(
  ///     redBarColor: Colors.purple,
  ///     blueCurtainColor: Colors.indigo,
  ///   ),
  /// )
  /// ```
  SonicManiaSplash({
    required String baseText,
    String? secondaryText,
    String? lastText,
    SonicManiaSplashController? controller,
    SonicManiaTheme? theme,
    VoidCallback? onAnimationStart,
    VoidCallback? onAnimationComplete,
    void Function(AnimationPhase phase)? onPhaseChange,
    super.key,
  }) : _baseText = baseText,
       _secondaryText = secondaryText,
       _lastText = lastText,
       _controller = controller,
       _theme = theme,
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

  /// Controller opcional para control programático de la animación.
  final SonicManiaSplashController? _controller;

  /// Tema opcional para personalización de colores.
  final SonicManiaTheme? _theme;

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
    with SingleTickerProviderStateMixin, PausableAnimationMixin {
  late bool _animationCompleted = false;
  late double firstTextVerticalOffset;
  late double lastTextVerticalOffset;
  late double lastTextHorizontalOffset;
  late double lastTextOriginOffset;
  late double lastTextInvertedValue;

  AnimationPhase _currentPhase = AnimationPhase.idle;

  // Key para forzar rebuild cuando se hace reset
  Key _contentKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    firstTextVerticalOffset = widget._secondaryText != null ? -1.0 : -0.5;
    lastTextVerticalOffset = widget._secondaryText != null ? 0.8 : 0.5;
    lastTextHorizontalOffset = widget._secondaryText != null ? 0.7 : 0.3;
    lastTextOriginOffset = widget._secondaryText != null ? -10 : 10;

    lastTextInvertedValue = widget._secondaryText != null ? 1.0 : -1.0;

    // Escuchar cambios del controller
    widget._controller?.addListener(_onControllerChanged);

    // Start animation lifecycle
    _updatePhase(AnimationPhase.entering);
    widget._onAnimationStart?.call();

    _initAnimationPhases();
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
      _currentPhase = AnimationPhase.idle;
      _contentKey = UniqueKey(); // Forzar rebuild de widgets hijos
    });

    // Reiniciar el ciclo de animación
    _updatePhase(AnimationPhase.entering);
    widget._onAnimationStart?.call();
    _initAnimationPhases();
  }

  /// Updates the current phase and notifies listeners
  void _updatePhase(AnimationPhase newPhase) {
    if (_currentPhase != newPhase) {
      _currentPhase = newPhase;
      widget._controller?.updatePhase(newPhase);
      widget._onPhaseChange?.call(newPhase);
    }
  }

  /// Initializes the animation phase sequence
  void _initAnimationPhases() {
    // Phase: entering → active (after slide in completes)
    delayedPausable(SonicManiaTiming.slideIn, () {
      _updatePhase(AnimationPhase.active);
    });

    // Phase: active → exiting (when slide out starts)
    delayedPausable(SonicManiaTiming.slideOutDelay, () {
      _updatePhase(AnimationPhase.exiting);
    });

    // Phase: exiting → completed (auto-destruction)
    delayedPausable(SonicManiaTiming.totalDuration, () {
      _updatePhase(AnimationPhase.completed);
      widget._onAnimationComplete?.call();
      setState(() {
        _animationCompleted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedSwitcher(
      duration: SonicManiaTiming.fadeTransition,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: _animationCompleted
          ? const SizedBox.shrink()
          : ColoredBox(
              key: _contentKey,
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

    // Envolver con el scope del tema si existe
    if (widget._theme != null) {
      content = SonicManiaThemeScope(
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
