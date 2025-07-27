import 'package:flutter/material.dart';

const Color _blueCurtainColor = Color(0xFF3D62AA);
const Color _orangeCurtainColor = Color(0xFFFE6933);
const Color _amberCurtainColor = Color(0xFFCA7C0B);
const Color _greenCurtainColor = Color(0xFF5DB4A1);
const Color _yellowCurtainColor = Color(0xFFF7C700);
const Color _blackCurtainColor = Color(0xFF040404);

/// Widget que muestra una cortina de color que se despliega y se contrae
/// en la pantalla.
class Curtain extends StatefulWidget {
  /// Cortina de color que se despliega y se contrae en la pantalla.
  ///
  /// Se puede personalizar el color de la cortina y el retardo de la animación.
  const Curtain({
    required this.color,
    this.delay = Duration.zero,
    super.key,
  });

  /// Cortina azul
  const Curtain.blue({
    this.color = _blueCurtainColor,
    this.delay = Duration.zero,
    super.key,
  });

  /// Cortina naranja
  const Curtain.orange({
    this.color = _orangeCurtainColor,
    this.delay = const Duration(milliseconds: 150),
    super.key,
  });

  /// Cortina ámbar
  const Curtain.amber({
    this.color = _amberCurtainColor,
    this.delay = const Duration(milliseconds: 300),
    super.key,
  });

  /// Cortina verde
  const Curtain.green({
    this.color = _greenCurtainColor,
    this.delay = const Duration(milliseconds: 450),
    super.key,
  });

  /// Cortina amarilla
  const Curtain.yellow({
    this.color = _yellowCurtainColor,
    this.delay = const Duration(milliseconds: 600),
    super.key,
  });

  /// Cortina negra
  const Curtain.black({
    this.color = _blackCurtainColor,
    this.delay = const Duration(milliseconds: 350),
    super.key,
  });

  /// Color de la cortina
  final Color color;

  /// Retardo de la animación
  final Duration delay;

  @override
  State<Curtain> createState() => _CurtainState();
}

class _CurtainState extends State<Curtain> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 175),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );

    Future.delayed(
      widget.delay,
      () => _controller.forward().whenComplete(() => _controller.reverse()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: Center(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 175),
          child: ColoredBox(
            color: widget.color,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
