import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/mario_maker/consts/consts.dart';
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
/// - `onAnimationStart`: Callback para sincronizar sonidos
///
/// Los tiempos de animación están definidos en [MarioMakerTiming].
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
  const MarioMakerTitle({
    required String title,
    required String imagePath,
    VoidCallback? onAnimationStart,
    Duration duration = MarioMakerTiming.defaultTotalDuration,
    double circleRadius = 80,
    double bottomMargin = 100,
    TextStyle? titleStyle,
    Alignment irisOutAlignment = Alignment.center,
    double irisOutEdgePadding = 50,
    super.key,
  })  : _title = title,
        _imagePath = imagePath,
        _onAnimationStart = onAnimationStart,
        _duration = duration,
        _circleRadius = circleRadius,
        _bottomMargin = bottomMargin,
        _titleStyle = titleStyle,
        _irisOutAlignment = irisOutAlignment,
        _irisOutEdgePadding = irisOutEdgePadding;

  final String _title;
  final String _imagePath;
  final VoidCallback? _onAnimationStart;
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
    with SingleTickerProviderStateMixin {
  bool _animationCompleted = false;
  bool _imagePrecached = false;

  static const Duration _irisOutDuration = MarioMakerTiming.irisOutDuration;
  static const Duration _titleEntryDelay = MarioMakerTiming.titleEntryDelay;
  static const Duration _bounceDuration = MarioMakerTiming.bounceDuration;
  static const Duration _expandDelay = MarioMakerTiming.expandDelay;
  static const Duration _expandDuration = MarioMakerTiming.expandDuration;

  @override
  void initState() {
    super.initState();
    _executeCallback();
    _initAutoDestruction();
  }

  void _executeCallback() {
    try {
      widget._onAnimationStart?.call();
    } on Exception catch (_) {
      // Silently handle callback errors to prevent crashes
    }
  }

  void _initAutoDestruction() {
    // Auto-destruct at end of duration
    unawaited(
      Future<void>.delayed(widget._duration, () {
        if (mounted) {
          setState(() => _animationCompleted = true);
        }
      }),
    );
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
      unawaited(
        precacheImage(AssetImage(widget._imagePath), context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    if (_animationCompleted) {
      return const SizedBox.shrink();
    }

    return ContractingCircleMask(
      delay: _irisOutDelay,
      alignment: widget._irisOutAlignment,
      edgePadding: widget._irisOutEdgePadding,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Black background (initial state)
            const SizedBox.expand(
              child: ColoredBox(color: marioMakerBlack),
            ),

            // Expanding circle mask that reveals yellow background
            ExpandingCircleMask(
              initialRadius: widget._circleRadius,
              bottomMargin: widget._bottomMargin,
              delay: _expandDelay,
              expandDuration: _expandDuration,
              background: const SizedBox.expand(
                child: ColoredBox(color: marioMakerYellow),
              ),
            ),

            // Bouncing circle with image (positioned at bottom center)
            Positioned(
              bottom: widget._bottomMargin - widget._circleRadius,
              left: (screenSize.width / 2) - widget._circleRadius,
              child: BouncingCircle(
                circleRadius: widget._circleRadius,
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
  }
}
