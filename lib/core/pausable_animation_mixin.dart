import 'dart:async';

import 'package:fancy_titles/core/fancy_title_controller.dart';
import 'package:fancy_titles/core/fancy_title_controller_scope.dart';
import 'package:flutter/widgets.dart';

/// Mixin que permite a los widgets pausar y reanudar sus animaciones
/// en respuesta a un [FancyTitleController].
///
/// Este mixin gestiona:
/// - Escuchar cambios en el controller del scope ancestro
/// - Pausar/reanudar [AnimationController]s registrados
/// - Pausar/reanudar timers pendientes con tracking de tiempo restante
///
/// ## Uso
///
/// ```dart
/// class _MyWidgetState extends State<MyWidget>
///     with SingleTickerProviderStateMixin, PausableAnimationMixin {
///   late AnimationController _controller;
///
///   @override
///   void initState() {
///     super.initState();
///     _controller = AnimationController(vsync: this, duration: duration);
///     registerAnimationController(_controller);
///     delayedPausable(Duration(seconds: 1), () => doSomething());
///   }
///
///   @override
///   void dispose() {
///     _controller.dispose();
///     super.dispose();
///   }
/// }
/// ```
mixin PausableAnimationMixin<T extends StatefulWidget> on State<T> {
  final List<AnimationController> _registeredControllers = [];
  final List<PausableTimer> _pausableTimers = [];
  FancyTitleController? _parentController;
  bool _wasPaused = false;

  /// Si la animación está actualmente pausada por el controller padre.
  bool get isPausedByController => _parentController?.isPaused ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateControllerSubscription();
  }

  void _updateControllerSubscription() {
    final newController = FancyTitleControllerScope.maybeOf(context);

    if (newController != _parentController) {
      _parentController?.removeListener(_onControllerChanged);
      _parentController = newController;
      _parentController?.addListener(_onControllerChanged);
    }

    // Verificar estado actual
    if (_parentController != null) {
      _onControllerChanged();
    }
  }

  void _onControllerChanged() {
    final isPaused = _parentController?.isPaused ?? false;

    if (isPaused && !_wasPaused) {
      _pauseAll();
    } else if (!isPaused && _wasPaused) {
      _resumeAll();
    }

    // Manejar skipToEnd
    if (_parentController?.isCompleted ?? false) {
      _skipToEnd();
    }

    _wasPaused = isPaused;
  }

  void _pauseAll() {
    for (final controller in _registeredControllers) {
      if (controller.isAnimating) {
        controller.stop(canceled: false);
      }
    }
    for (final timer in _pausableTimers) {
      timer.pause();
    }
  }

  void _resumeAll() {
    for (final controller in _registeredControllers) {
      // Solo reanudar si no ha completado
      if (controller.value < 1.0 && controller.value > 0.0) {
        unawaited(controller.forward());
      }
    }
    for (final timer in _pausableTimers) {
      timer.resume();
    }
  }

  void _skipToEnd() {
    // Cancelar todos los timers
    for (final timer in _pausableTimers) {
      timer.cancel();
    }
    _pausableTimers.clear();

    // Completar todas las animaciones
    for (final controller in _registeredControllers) {
      controller
        ..stop()
        ..value = 1.0;
    }
  }

  /// Registra un [AnimationController] para ser pausado/reanudado
  /// automáticamente.
  ///
  /// El controller será pausado cuando el [FancyTitleController] padre
  /// llame a pause() y reanudado cuando llame a resume().
  @protected
  void registerAnimationController(AnimationController controller) {
    _registeredControllers.add(controller);
  }

  /// Desregistra un [AnimationController].
  ///
  /// Llama esto antes de disponer el controller si lo registraste
  /// con [registerAnimationController].
  @protected
  void unregisterAnimationController(AnimationController controller) {
    _registeredControllers.remove(controller);
  }

  /// Ejecuta [callback] después de [duration], soportando pause/resume.
  ///
  /// A diferencia de `Future.delayed`, este timer:
  /// - Puede ser pausado cuando el controller padre está en pausa
  /// - Reanuda con el tiempo restante cuando se resume
  /// - Se cancela automáticamente en dispose
  ///
  /// Retorna un [PausableTimer] que puede ser cancelado manualmente.
  @protected
  PausableTimer delayedPausable(Duration duration, VoidCallback callback) {
    final timer = PausableTimer(
      duration: duration,
      callback: () {
        if (!mounted) return;
        callback();
      },
    );

    // Si ya estamos pausados, pausar el timer inmediatamente
    if (isPausedByController) {
      timer.pause();
    }

    _pausableTimers.add(timer);
    return timer;
  }

  @override
  void dispose() {
    _parentController?.removeListener(_onControllerChanged);
    for (final timer in _pausableTimers) {
      timer.cancel();
    }
    _pausableTimers.clear();
    _registeredControllers.clear();
    super.dispose();
  }
}

/// Timer que puede ser pausado y reanudado.
///
/// Internamente rastrea el tiempo restante cuando se pausa
/// y crea un nuevo timer con ese tiempo cuando se reanuda.
///
/// Este timer es público para permitir su uso en tests y
/// en implementaciones personalizadas.
class PausableTimer {
  /// Crea un timer pausable que ejecutará [callback] después de [duration].
  PausableTimer({
    required Duration duration,
    required VoidCallback callback,
  })  : _totalDuration = duration,
        _remainingDuration = duration,
        _callback = callback {
    _startTime = DateTime.now();
    _timer = Timer(duration, _execute);
  }

  final Duration _totalDuration;
  Duration _remainingDuration;
  final VoidCallback _callback;
  Timer? _timer;
  DateTime? _startTime;
  bool _isPaused = false;
  bool _isCompleted = false;

  /// Si el timer está actualmente pausado.
  bool get isPaused => _isPaused;

  /// Si el timer ha completado su ejecución.
  bool get isCompleted => _isCompleted;

  void _execute() {
    _isCompleted = true;
    _callback();
  }

  /// Pausa el timer, guardando el tiempo restante.
  void pause() {
    if (_isPaused || _isCompleted || _timer == null) return;

    _timer?.cancel();
    _timer = null;

    if (_startTime != null) {
      final elapsed = DateTime.now().difference(_startTime!);
      _remainingDuration = _totalDuration - elapsed;
      if (_remainingDuration.isNegative) {
        _remainingDuration = Duration.zero;
      }
    }

    _isPaused = true;
  }

  /// Reanuda el timer con el tiempo restante.
  void resume() {
    if (!_isPaused || _isCompleted) return;

    _isPaused = false;
    _startTime = DateTime.now();
    _timer = Timer(_remainingDuration, _execute);
  }

  /// Cancela el timer permanentemente.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _isCompleted = true;
  }
}
