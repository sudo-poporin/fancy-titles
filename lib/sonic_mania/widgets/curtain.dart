import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/pausable_animation_mixin.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme_scope.dart';
import 'package:flutter/material.dart';

/// Tipo de cortina para resolver colores del tema.
enum _CurtainType {
  /// Cortina azul.
  blue,

  /// Cortina naranja.
  orange,

  /// Cortina ámbar.
  amber,

  /// Cortina verde.
  green,

  /// Cortina amarilla.
  yellow,

  /// Cortina negra.
  black,

  /// Cortina con color personalizado.
  custom,
}

/// Widget que muestra una cortina de color que se despliega y se contrae
/// en la pantalla.
///
/// Los colores pueden ser personalizados usando [SonicManiaTheme].
class Curtain extends StatefulWidget {
  /// Cortina de color que se despliega y se contrae en la pantalla.
  ///
  /// Se puede personalizar el color de la cortina y el retardo de la animación.
  const Curtain({
    required this.color,
    this.delay = Duration.zero,
    super.key,
  }) : _curtainType = _CurtainType.custom;

  /// Cortina azul.
  ///
  /// El color puede ser personalizado con [SonicManiaTheme.blueCurtainColor].
  const Curtain.blue({
    this.color = SonicManiaCurtainColors.blue,
    this.delay = SonicManiaTiming.curtainBlueDelay,
    super.key,
  }) : _curtainType = _CurtainType.blue;

  /// Cortina naranja.
  ///
  /// El color puede ser personalizado con [SonicManiaTheme.orangeCurtainColor].
  const Curtain.orange({
    this.color = SonicManiaCurtainColors.orange,
    this.delay = SonicManiaTiming.curtainOrangeDelay,
    super.key,
  }) : _curtainType = _CurtainType.orange;

  /// Cortina ámbar.
  ///
  /// El color puede ser personalizado con [SonicManiaTheme.amberCurtainColor].
  const Curtain.amber({
    this.color = SonicManiaCurtainColors.amber,
    this.delay = SonicManiaTiming.curtainAmberDelay,
    super.key,
  }) : _curtainType = _CurtainType.amber;

  /// Cortina verde.
  ///
  /// El color puede ser personalizado con [SonicManiaTheme.greenCurtainColor].
  const Curtain.green({
    this.color = SonicManiaCurtainColors.green,
    this.delay = SonicManiaTiming.curtainGreenDelay,
    super.key,
  }) : _curtainType = _CurtainType.green;

  /// Cortina amarilla.
  ///
  /// El color puede ser personalizado con [SonicManiaTheme.yellowCurtainColor].
  const Curtain.yellow({
    this.color = SonicManiaCurtainColors.yellow,
    this.delay = SonicManiaTiming.curtainYellowDelay,
    super.key,
  }) : _curtainType = _CurtainType.yellow;

  /// Cortina negra.
  const Curtain.black({
    this.color = SonicManiaCurtainColors.black,
    this.delay = SonicManiaTiming.curtainBlackDelay,
    super.key,
  }) : _curtainType = _CurtainType.black;

  /// Tipo interno de cortina para resolución de colores del tema.
  final _CurtainType _curtainType;

  /// Color de la cortina
  final Color color;

  /// Retardo de la animación
  final Duration delay;

  @override
  State<Curtain> createState() => _CurtainState();
}

class _CurtainState extends State<Curtain>
    with TickerProviderStateMixin, PausableAnimationMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: SonicManiaTiming.curtainExpandDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    registerAnimationController(_controller);

    delayedPausable(widget.delay, () {
      unawaited(
        _controller.forward().whenComplete(() {
          if (mounted) unawaited(_controller.reverse());
        }),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Resuelve el color de la cortina basándose en el tema o el color por
  /// defecto.
  Color _resolveColor(BuildContext context) {
    final theme = SonicManiaThemeScope.maybeOf(context);
    if (theme == null) return widget.color;

    return switch (widget._curtainType) {
      _CurtainType.blue => theme.blueCurtainColor ?? widget.color,
      _CurtainType.orange => theme.orangeCurtainColor ?? widget.color,
      _CurtainType.amber => theme.amberCurtainColor ?? widget.color,
      _CurtainType.green => theme.greenCurtainColor ?? widget.color,
      _CurtainType.yellow => theme.yellowCurtainColor ?? widget.color,
      _CurtainType.black => widget.color, // Negro no es personalizable
      _CurtainType.custom => widget.color,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: Center(
        child: AnimatedSize(
          duration: SonicManiaTiming.curtainExpandDuration,
          child: ColoredBox(
            color: _resolveColor(context),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
