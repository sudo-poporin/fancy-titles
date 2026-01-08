import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/cancelable_timers.dart';
import 'package:fancy_titles/evangelion/painters/painters.dart';
import 'package:flutter/material.dart';

/// Define el orden de aparicion de las cortinas en la animacion de Evangelion.
///
/// Cada valor corresponde a una cortina especifica en la secuencia de
/// animacion, donde cada cortina tiene un painter y timing diferente.
///
/// Ver tambien:
/// - [Curtain] widget que usa este enum
/// - `EvangelionTitle` widget principal de la animacion
enum CurtainOrder {
  /// Primera cortina: fondo negro solido con fade in/out.
  first,

  /// Segunda cortina: usa [FirstCurtainPainter] con scale transition.
  second,

  /// Tercera cortina: usa [SecondCurtainPainter] con scale transition.
  third,

  /// Cuarta cortina: usa [ThirdCurtainPainter] con scale transition.
  fourth,

  /// Quinta cortina: usa [FourthCurtainPainter] con scale transition.
  fifth,

  /// Sexta cortina: usa [FifthCurtainPainter] con scale especial (0.5 a 1).
  sixth,
}

/// Widget que muestra las cortinas animadas de la secuencia de Evangelion.
///
/// Cada cortina es un efecto visual que aparece y desaparece con diferentes
/// animaciones (fade, scale) segun su orden en la secuencia. Las cortinas
/// son parte del efecto de transicion caracteristico de los titulos de
/// episodio de Neon Genesis Evangelion.
///
/// Usa constructores nombrados para cada cortina predefinida:
/// - [Curtain.first] - Fondo negro con fade
/// - [Curtain.second] a [Curtain.sixth] - Shapes con scale transitions
///
/// El widget maneja automaticamente sus propios timers usando
/// `CancelableTimersMixin` para aparecer despues del `delay` y desaparecer
/// despues de `duration`.
///
/// Se utiliza internamente en `EvangelionTitle` para crear la secuencia
/// de cortinas animadas.
///
/// ## Ejemplo
///
/// ```dart
/// Stack(
///   children: [
///     Curtain.first(),
///     Curtain.second(),
///     Curtain.third(),
///     // ...
///   ],
/// )
/// ```
///
/// Ver tambien:
/// - `EvangelionTitle` widget principal que usa este componente
/// - [CurtainOrder] enum con los ordenes disponibles
/// - [EvangelionTiming] constantes de timing para las cortinas
class Curtain extends StatefulWidget {
  /// Crea una cortina con orden, duracion, curva y delay personalizados.
  ///
  /// [order] determina que painter y animacion usar.
  /// [duration] tiempo que dura visible la cortina.
  /// [delay] tiempo antes de que aparezca la cortina.
  /// [curve] curva de la animacion.
  const Curtain({
    required CurtainOrder order,
    Duration duration = EvangelionTiming.sparkDefaultDuration,
    Curve curve = Curves.easeInOut,
    Duration delay = EvangelionTiming.curtainFirstDelay,
    super.key,
  }) : _delay = delay,
       _curve = curve,
       _duration = duration,
       _order = order;

  /// Shows the first curtain of Evangelion title
  const Curtain.first({super.key})
    : _order = CurtainOrder.first,
      _duration = EvangelionTiming.curtainFirstDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainFirstDelay;

  /// Shows the second curtain of Evangelion title
  const Curtain.second({super.key})
    : _order = CurtainOrder.second,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainSecondDelay;

  /// Shows the third curtain of Evangelion title
  const Curtain.third({super.key})
    : _order = CurtainOrder.third,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainThirdDelay;

  /// Shows the fourth curtain of Evangelion title
  const Curtain.fourth({super.key})
    : _order = CurtainOrder.fourth,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainFourthDelay;

  /// Shows the fifth curtain of Evangelion title
  const Curtain.fifth({super.key})
    : _order = CurtainOrder.fifth,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainFifthDelay;

  /// Shows the sixth curtain of Evangelion title
  const Curtain.sixth({super.key})
    : _order = CurtainOrder.sixth,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainSixthDelay;

  final CurtainOrder _order;
  final Duration _duration;
  final Curve _curve;
  final Duration _delay;

  @override
  State<Curtain> createState() => _CurtainState();
}

class _CurtainState extends State<Curtain> with CancelableTimersMixin {
  bool _fadeOut = true;

  @override
  void initState() {
    super.initState();

    // Show curtain after delay
    delayed(widget._delay, () {
      setState(() => _fadeOut = false);
    });

    // Hide curtain after delay + duration
    delayed(widget._delay + widget._duration, () {
      setState(() => _fadeOut = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    switch (widget._order) {
      case CurtainOrder.first:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : const SizedBox.expand(child: ColoredBox(color: Colors.black)),
        );
      case CurtainOrder.second:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const FirstCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
      case CurtainOrder.third:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const SecondCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
      case CurtainOrder.fourth:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const ThirdCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
      case CurtainOrder.fifth:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const FourthCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
      case CurtainOrder.sixth:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation.drive(
              Tween<double>(
                begin: 0.5,
                end: 1,
              ).chain(CurveTween(curve: widget._curve)),
            ),
            child: child,
          ),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const FifthCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
    }
  }
}
