import 'package:fancy_titles/core/animation_phase.dart';
import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/fancy_title_controller_scope.dart';
import 'package:fancy_titles/core/pausable_animation_mixin.dart';
import 'package:fancy_titles/mario_maker/constants/constants.dart';
import 'package:fancy_titles/mario_maker/mario_maker_theme.dart';
import 'package:fancy_titles/mario_maker/mario_maker_theme_scope.dart';
import 'package:fancy_titles/mario_maker/mario_maker_title_controller.dart';
import 'package:fancy_titles/mario_maker/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Pantalla de título inspirada en Super Mario Maker.
///
/// Muestra un círculo que rebota con una imagen dentro (efecto jelly),
/// luego se expande revelando un fondo amarillo, y finalmente muestra
/// un título que se desliza desde arriba.
///
/// ## Ejemplo de uso
///
/// ```dart
/// MarioMakerTitle(
///   title: 'WORLD 1-1',
///   imagePath: 'assets/mario.gif',
/// )
/// ```
///
/// ## Timeline de animación (4 segundos por defecto)
///
/// | Tiempo    | Evento                                |
/// |-----------|---------------------------------------|
/// | 0-1.2s    | Círculo rebota (efecto jelly)         |
/// | 1.2-1.5s  | Imagen se escala hacia afuera         |
/// | 1.2-2s    | Círculo se expande (fondo amarillo)   |
/// | 1.4-1.9s  | Título entra deslizándose             |
/// | 3.5-4s    | Fade out + Iris-out simultáneos       |
/// | 4s        | Widget se auto-destruye               |
///
/// ## Personalización
///
/// - `duration`: Duración total de la animación
/// - `circleRadius`: Tamaño inicial del círculo
/// - `bottomMargin`: Posición vertical del círculo
/// - `titleStyle`: Estilo personalizado para el texto
/// - `irisOutAlignment`: Punto hacia donde converge el iris-out
///
/// Los tiempos de animación están definidos en [MarioMakerTiming].
///
/// ## Control programático
///
/// Se puede controlar la animación usando un [MarioMakerTitleController]:
///
/// ```dart
/// final controller = MarioMakerTitleController();
///
/// MarioMakerTitle(
///   title: 'WORLD 1-1',
///   imagePath: 'assets/mario.gif',
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
/// MarioMakerTitle(
///   title: 'WORLD 1-1',
///   imagePath: 'assets/mario.gif',
///   onAnimationStart: () => audioPlayer.play('drum_roll.mp3'),
///   onAnimationComplete: () => Navigator.pushReplacement(...),
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
/// - `Persona5Title` para estilo Persona 5
/// - `EvangelionTitle` para estilo Evangelion
class MarioMakerTitle extends StatefulWidget {
  /// Crea una pantalla de título estilo Mario Maker.
  ///
  /// [title] texto a mostrar después de que el círculo se expande.
  ///
  /// [imagePath] ruta del asset para la imagen dentro del círculo.
  /// Soporta imágenes estáticas y GIFs animados.
  ///
  /// [onAnimationStart] callback opcional ejecutado cuando inicia la animación.
  /// Útil para sincronizar efectos de sonido.
  ///
  /// [duration] duración total de la animación.
  /// Por defecto es [MarioMakerTiming.defaultTotalDuration] (4 segundos).
  ///
  /// [circleRadius] radio base del círculo en píxeles (por defecto: 80).
  ///
  /// [bottomMargin] distancia desde el borde inferior de la pantalla hasta
  /// el centro del círculo (por defecto: 100).
  ///
  /// [titleStyle] estilo personalizado para el texto del título.
  /// Si no se proporciona, usa el estilo por defecto.
  ///
  /// [irisOutAlignment] punto hacia donde converge el efecto iris-out.
  /// Por defecto es `Alignment.center`. Usa constantes como
  /// `Alignment.bottomRight`, `Alignment.topLeft`, etc.
  ///
  /// [irisOutEdgePadding] distancia mínima desde los bordes de la pantalla
  /// para el efecto iris-out (por defecto: 50).
  ///
  /// Ejemplo básico:
  /// ```dart
  /// MarioMakerTitle(
  ///   title: 'NEW LEVEL',
  ///   imagePath: 'assets/character.png',
  /// )
  /// ```
  ///
  /// Ejemplo con callback de sonido:
  /// ```dart
  /// MarioMakerTitle(
  ///   title: 'BOSS STAGE',
  ///   imagePath: 'assets/bowser.gif',
  ///   onAnimationStart: () => audioPlayer.play('intro.mp3'),
  /// )
  /// ```
  ///
  /// Ejemplo con iris-out personalizado:
  /// ```dart
  /// MarioMakerTitle(
  ///   title: 'SECRET EXIT',
  ///   imagePath: 'assets/star.png',
  ///   irisOutAlignment: Alignment.bottomRight,
  ///   irisOutEdgePadding: 80,
  /// )
  /// ```
  ///
  /// Ejemplo con callbacks:
  /// ```dart
  /// MarioMakerTitle(
  ///   title: 'NEW LEVEL',
  ///   imagePath: 'assets/mario.gif',
  ///   onAnimationStart: () => print('Animación iniciada'),
  ///   onAnimationComplete: () => print('Animación completada'),
  ///   onPhaseChange: (phase) => print('Fase: $phase'),
  /// )
  /// ```
  ///
  /// Ejemplo con controller:
  /// ```dart
  /// final controller = MarioMakerTitleController();
  ///
  /// MarioMakerTitle(
  ///   title: 'WORLD 1-1',
  ///   imagePath: 'assets/mario.gif',
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
  /// MarioMakerTitle(
  ///   title: 'WORLD 1-1',
  ///   imagePath: 'assets/mario.gif',
  ///   theme: MarioMakerTheme(
  ///     expandedBackgroundColor: Colors.orange,
  ///     titleColor: Colors.white,
  ///   ),
  /// )
  /// ```
  const MarioMakerTitle({
    required String title,
    required String imagePath,
    MarioMakerTitleController? controller,
    MarioMakerTheme? theme,
    VoidCallback? onAnimationStart,
    VoidCallback? onAnimationComplete,
    void Function(AnimationPhase phase)? onPhaseChange,
    Duration duration = MarioMakerTiming.defaultTotalDuration,
    double circleRadius = 80,
    double bottomMargin = 100,
    TextStyle? titleStyle,
    Alignment irisOutAlignment = Alignment.center,
    double irisOutEdgePadding = 50,
    super.key,
  }) : _title = title,
       _imagePath = imagePath,
       _controller = controller,
       _theme = theme,
       _onAnimationStart = onAnimationStart,
       _onAnimationComplete = onAnimationComplete,
       _onPhaseChange = onPhaseChange,
       _duration = duration,
       _circleRadius = circleRadius,
       _bottomMargin = bottomMargin,
       _titleStyle = titleStyle,
       _irisOutAlignment = irisOutAlignment,
       _irisOutEdgePadding = irisOutEdgePadding;

  final String _title;
  final String _imagePath;

  /// Controller opcional para control programático de la animación.
  final MarioMakerTitleController? _controller;

  /// Tema personalizado para colores.
  /// Si es null, usa los colores por defecto de Mario Maker.
  final MarioMakerTheme? _theme;

  /// Callback ejecutado cuando la animación comienza.
  final VoidCallback? _onAnimationStart;

  /// Callback ejecutado cuando la animación termina completamente.
  final VoidCallback? _onAnimationComplete;

  /// Callback ejecutado cuando cambia la fase de la animación.
  final void Function(AnimationPhase phase)? _onPhaseChange;

  final Duration _duration;
  final double _circleRadius;
  final double _bottomMargin;
  final TextStyle? _titleStyle;
  final Alignment _irisOutAlignment;
  final double _irisOutEdgePadding;

  @override
  State<MarioMakerTitle> createState() => _MarioMakerTitleState();
}

class _MarioMakerTitleState extends State<MarioMakerTitle>
    with SingleTickerProviderStateMixin, PausableAnimationMixin {
  bool _animationCompleted = false;
  bool _imagePrecached = false;

  static const Duration _irisOutDuration = MarioMakerTiming.irisOutDuration;
  static const Duration _titleEntryDelay = MarioMakerTiming.titleEntryDelay;
  static const Duration _bounceDuration = MarioMakerTiming.bounceDuration;
  static const Duration _expandDelay = MarioMakerTiming.expandDelay;
  static const Duration _expandDuration = MarioMakerTiming.expandDuration;

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
    _executeCallback();
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
    _executeCallback();
    _initAnimationPhases();
  }

  void _executeCallback() {
    try {
      widget._onAnimationStart?.call();
    } on Exception catch (_) {
      // Silently handle callback errors to prevent crashes
    }
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
    // Phase: entering → active (after title appears)
    delayedPausable(_titleEntryDelay, () {
      _updatePhase(AnimationPhase.active);
    });

    // Phase: active → exiting (when iris-out starts)
    delayedPausable(_irisOutDelay, () {
      _updatePhase(AnimationPhase.exiting);
    });

    // Phase: exiting → completed (auto-destruction)
    delayedPausable(widget._duration, () {
      _updatePhase(AnimationPhase.completed);
      widget._onAnimationComplete?.call();
      setState(() => _animationCompleted = true);
    });
  }

  /// Calculates when the iris-out effect should start
  Duration get _irisOutDelay => widget._duration - _irisOutDuration;

  /// Calculates when the title should start its exit animation
  /// Title exits at the same time as the iris-out effect
  Duration get _titleExitDelay => _irisOutDelay;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImageIfNeeded();
  }

  void _precacheImageIfNeeded() {
    if (!_imagePrecached) {
      _imagePrecached = true;
      // Fire-and-forget: precaching doesn't need await, result is not used.
      // Errors are ignored since precaching is optional - the image will
      // still load when first displayed (just without pre-warming the cache).
      // ignore: discarded_futures
      precacheImage(
        AssetImage(widget._imagePath),
        context,
        onError: (_, _) {}, // Silently ignore precache errors
      );
    }
  }

  /// Resuelve el color de fondo usando el theme o el color por defecto.
  Color _resolveBackgroundColor() {
    return widget._theme?.backgroundColor ?? marioMakerBlack;
  }

  /// Resuelve el color de fondo expandido usando el theme o el color
  /// por defecto.
  Color _resolveExpandedBackgroundColor() {
    return widget._theme?.expandedBackgroundColor ?? marioMakerYellow;
  }

  /// Resuelve el color del círculo usando el theme o el color por defecto.
  Color _resolveCircleColor() {
    return widget._theme?.circleColor ?? MarioMakerColors.circleBackground;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final backgroundColor = _resolveBackgroundColor();
    final expandedBackgroundColor = _resolveExpandedBackgroundColor();
    final circleColor = _resolveCircleColor();

    if (_animationCompleted) {
      return const SizedBox.shrink();
    }

    Widget content = ContractingCircleMask(
      key: _contentKey,
      delay: _irisOutDelay,
      alignment: widget._irisOutAlignment,
      edgePadding: widget._irisOutEdgePadding,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Black background (initial state)
            SizedBox.expand(
              child: ColoredBox(color: backgroundColor),
            ),

            // Expanding circle mask that reveals yellow background
            ExpandingCircleMask(
              initialRadius: widget._circleRadius,
              bottomMargin: widget._bottomMargin,
              delay: _expandDelay,
              expandDuration: _expandDuration,
              background: SizedBox.expand(
                child: ColoredBox(color: expandedBackgroundColor),
              ),
            ),

            // Bouncing circle with image (positioned at bottom center)
            Positioned(
              bottom: widget._bottomMargin - widget._circleRadius,
              left: (screenSize.width / 2) - widget._circleRadius,
              child: BouncingCircle(
                circleRadius: widget._circleRadius,
                circleColor: circleColor,
                bounceDuration: _bounceDuration,
                child: MarioMakerImage(
                  imagePath: widget._imagePath,
                  size: widget._circleRadius * 1.5,
                ),
              ),
            ),

            // Title layer - stays visible and exits with reverse animation
            SlidingTitle(
              text: widget._title,
              textStyle: widget._titleStyle,
              delay: _titleEntryDelay,
              exitDelay: _titleExitDelay,
            ),
          ],
        ),
      ),
    );

    // Envolver con el scope del theme si existe
    if (widget._theme != null) {
      content = MarioMakerThemeScope(
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
