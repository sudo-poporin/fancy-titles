import 'package:fancy_titles/core/animation_phase.dart';
import 'package:flutter/material.dart';

/// Widget base abstracto para todas las pantallas de título.
///
/// Proporciona funcionalidad común como:
/// - Callbacks de ciclo de vida (`onAnimationStart`, `onAnimationComplete`)
/// - Notificación de cambios de fase (`onPhaseChange`)
/// - Gestión de fase de animación mediante [AnimationPhaseMixin]
///
/// ## Uso
///
/// Extiende esta clase para crear widgets de título personalizados:
///
/// ```dart
/// class MyCustomTitle extends BaseTitleWidget {
///   const MyCustomTitle({
///     super.onAnimationStart,
///     super.onAnimationComplete,
///     super.onPhaseChange,
///     super.key,
///   });
///
///   @override
///   State<MyCustomTitle> createState() => _MyCustomTitleState();
/// }
///
/// class _MyCustomTitleState extends State<MyCustomTitle>
///     with SingleTickerProviderStateMixin, AnimationPhaseMixin {
///   @override
///   void initState() {
///     super.initState();
///     updatePhase(AnimationPhase.entering);
///     // ... configurar animaciones
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     // ... construir UI
///   }
/// }
/// ```
///
/// Ver también:
/// - [AnimationPhaseMixin] para gestión de fases de animación
/// - [AnimationPhase] para las fases disponibles
abstract class BaseTitleWidget extends StatefulWidget {
  /// Crea un widget base para pantallas de título.
  ///
  /// [onAnimationStart] se llama cuando la animación comienza.
  /// [onAnimationComplete] se llama cuando la animación termina.
  /// [onPhaseChange] se llama cada vez que cambia la fase.
  const BaseTitleWidget({
    this.onAnimationStart,
    this.onAnimationComplete,
    this.onPhaseChange,
    super.key,
  });

  /// Callback ejecutado cuando la animación comienza.
  ///
  /// Se invoca cuando la fase cambia a [AnimationPhase.entering].
  final VoidCallback? onAnimationStart;

  /// Callback ejecutado cuando la animación termina completamente.
  ///
  /// Se invoca cuando la fase cambia a [AnimationPhase.completed].
  final VoidCallback? onAnimationComplete;

  /// Callback ejecutado cuando cambia la fase de la animación.
  ///
  /// Proporciona la nueva [AnimationPhase] cada vez que hay una transición.
  /// Las fases siguen el orden: idle → entering → active → exiting → completed.
  final void Function(AnimationPhase phase)? onPhaseChange;
}

/// Mixin que proporciona gestión de fases de animación para widgets de título.
///
/// Este mixin simplifica la implementación de widgets que siguen el ciclo
/// de vida de animación: idle → entering → active → exiting → completed.
///
/// ## Uso
///
/// ```dart
/// class _MyTitleState extends State<MyTitle>
///     with SingleTickerProviderStateMixin, AnimationPhaseMixin {
///
///   @override
///   void initState() {
///     super.initState();
///     updatePhase(AnimationPhase.entering);
///     widget.onAnimationStart?.call();
///
///     Future.delayed(enterDuration, () {
///       if (!mounted) return;
///       updatePhase(AnimationPhase.active);
///     });
///   }
/// }
/// ```
///
/// ## Métodos disponibles
///
/// - [updatePhase]: Cambia la fase actual y notifica listeners
/// - [safeSetState]: Ejecuta setState solo si el widget está montado
/// - [currentPhase]: Obtiene la fase actual de la animación
///
/// Ver también:
/// - [BaseTitleWidget] para el widget base que define los callbacks
/// - [AnimationPhase] para las fases disponibles
mixin AnimationPhaseMixin<T extends BaseTitleWidget> on State<T> {
  AnimationPhase _currentPhase = AnimationPhase.idle;

  /// Obtiene la fase actual de la animación.
  AnimationPhase get currentPhase => _currentPhase;

  /// Actualiza la fase de animación y notifica a los listeners.
  ///
  /// Si la fase es [AnimationPhase.entering], también invoca
  /// [BaseTitleWidget.onAnimationStart].
  ///
  /// Si la fase es [AnimationPhase.completed], también invoca
  /// [BaseTitleWidget.onAnimationComplete].
  ///
  /// No hace nada si la nueva fase es igual a la actual.
  @protected
  void updatePhase(AnimationPhase newPhase) {
    if (_currentPhase != newPhase) {
      _currentPhase = newPhase;
      widget.onPhaseChange?.call(newPhase);

      if (newPhase == AnimationPhase.entering) {
        widget.onAnimationStart?.call();
      } else if (newPhase == AnimationPhase.completed) {
        widget.onAnimationComplete?.call();
      }
    }
  }

  /// Ejecuta [setState] solo si el widget está montado.
  ///
  /// Esto previene errores cuando se intenta actualizar el estado
  /// después de que el widget ha sido disposed (por ejemplo, en
  /// callbacks de `Future.delayed`).
  ///
  /// ```dart
  /// Future.delayed(duration, () {
  ///   safeSetState(() => _isVisible = true);
  /// });
  /// ```
  @protected
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
