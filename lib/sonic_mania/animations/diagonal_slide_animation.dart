import 'package:flutter/material.dart';

/// Widget de transicion que desliza su hijo en direccion diagonal.
///
/// Envuelve un [SlideTransition] para proporcionar animaciones de
/// deslizamiento desde cualquier esquina de la pantalla hacia el centro.
/// Por defecto, el widget se desliza desde la esquina inferior derecha
/// hacia la posicion final.
///
/// Se utiliza internamente en `SonicManiaSplash` para animar la entrada
/// de elementos decorativos.
///
/// ## Ejemplo
///
/// ```dart
/// DiagonalSlideTransition(
///   animation: _controller,
///   child: Container(color: Colors.blue),
///   beginOffset: const Offset(1, 1),  // Esquina inferior derecha
///   endOffset: Offset.zero,            // Centro
/// )
/// ```
///
/// Ver tambien:
/// - [HorizontalSlideTransition] para deslizamientos solo horizontales
/// - [SlideTransition] widget base de Flutter
class DiagonalSlideTransition extends StatelessWidget {
  /// Crea una transicion de deslizamiento diagonal.
  ///
  /// [child] es el widget a animar.
  /// [animation] controla el progreso de la transicion.
  /// [beginOffset] posicion inicial (por defecto esquina inferior derecha).
  /// [endOffset] posicion final (por defecto centro/origen).
  const DiagonalSlideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset? beginOffset = const Offset(1, 1),
    Offset? endOffset = Offset.zero,
    super.key,
  })  : _endOffset = endOffset,
        _beginOffset = beginOffset,
        _animation = animation,
        _child = child;

  final Widget _child;
  final Animation<double> _animation;
  final Offset? _beginOffset;
  final Offset? _endOffset;

  @override
  Widget build(BuildContext context) {
    final offsetTween = Tween<Offset>(
      begin: _beginOffset,
      end: _endOffset,
    );

    return SlideTransition(
      position: _animation.drive(offsetTween),
      child: _child,
    );
  }
}

/// Widget de transicion que desliza su hijo horizontalmente.
///
/// Envuelve un [SlideTransition] para proporcionar animaciones de
/// deslizamiento horizontal. Por defecto, el widget se desliza desde
/// fuera del borde izquierdo de la pantalla hacia la posicion final.
///
/// Se utiliza internamente en `SonicManiaSplash` para animar la entrada
/// y salida de las barras de texto.
///
/// ## Ejemplo
///
/// ```dart
/// HorizontalSlideTransition(
///   animation: _controller,
///   child: Text('ZONE'),
///   beginOffset: const Offset(-2, 0),  // Fuera por la izquierda
///   endOffset: Offset.zero,             // Posicion final
/// )
/// ```
///
/// Ver tambien:
/// - [DiagonalSlideTransition] para deslizamientos diagonales
/// - [SlideTransition] widget base de Flutter
class HorizontalSlideTransition extends StatelessWidget {
  /// Crea una transicion de deslizamiento horizontal.
  ///
  /// [child] es el widget a animar.
  /// [animation] controla el progreso de la transicion.
  /// [beginOffset] posicion inicial (por defecto fuera por la izquierda).
  /// [endOffset] posicion final (por defecto centro/origen).
  const HorizontalSlideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset? beginOffset = const Offset(-2, 0),
    Offset? endOffset = Offset.zero,
    super.key,
  })  : _endOffset = endOffset,
        _beginOffset = beginOffset,
        _animation = animation,
        _child = child;

  final Widget _child;
  final Animation<double> _animation;
  final Offset? _beginOffset;
  final Offset? _endOffset;

  @override
  Widget build(BuildContext context) {
    final offsetTween = Tween<Offset>(
      begin: _beginOffset,
      end: _endOffset,
    );

    return SlideTransition(
      position: _animation.drive(offsetTween),
      child: _child,
    );
  }
}
