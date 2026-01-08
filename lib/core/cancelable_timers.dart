import 'dart:async';

import 'package:flutter/widgets.dart';

/// Mixin que proporciona gestión de timers cancelables.
///
/// Todos los timers creados con [delayed] se cancelan automáticamente
/// en [dispose], evitando memory leaks y errores en tests.
///
/// ## Problema que resuelve
///
/// `Future.delayed` crea un timer que:
/// 1. No puede cancelarse una vez creado
/// 2. Permanece activo después de que el widget se dispose
/// 3. Causa errores "Timer still pending" en Flutter tests
///
/// ## Ejemplo de uso
///
/// ```dart
/// class _MyWidgetState extends State<MyWidget>
///     with CancelableTimersMixin {
///   @override
///   void initState() {
///     super.initState();
///     delayed(const Duration(seconds: 3), () {
///       setState(() => _showContent = true);
///     });
///   }
/// }
/// ```
///
/// ## Cadenas de timers
///
/// Para ejecutar callbacks en secuencia, usa [delayedChain]:
///
/// ```dart
/// delayedChain([
///   (duration: Duration(seconds: 1), callback: () => print('Primero')),
///   (duration: Duration(seconds: 2), callback: () => print('Segundo')),
/// ]);
/// ```
mixin CancelableTimersMixin<T extends StatefulWidget> on State<T> {
  final List<Timer> _timers = [];

  /// Ejecuta [callback] después de [duration].
  ///
  /// El timer se cancela automáticamente si el widget se dispose
  /// antes de que expire. También verifica [mounted] antes de
  /// ejecutar el callback.
  ///
  /// Retorna el [Timer] creado para permitir cancelación manual
  /// si es necesario (aunque normalmente no es necesario).
  @protected
  Timer delayed(Duration duration, VoidCallback callback) {
    final timer = Timer(duration, () {
      if (!mounted) return;
      callback();
    });
    _timers.add(timer);
    return timer;
  }

  /// Ejecuta una cadena de callbacks en secuencia.
  ///
  /// Cada elemento de [chain] se ejecuta después del anterior.
  /// Las duraciones son relativas al callback anterior, no absolutas.
  ///
  /// Ejemplo:
  /// ```dart
  /// // Callback 1 a los 500ms, callback 2 a los 500ms + 1000ms = 1500ms
  /// delayedChain([
  ///   (duration: Duration(milliseconds: 500), callback: () => doFirst()),
  ///   (duration: Duration(seconds: 1), callback: () => doSecond()),
  /// ]);
  /// ```
  @protected
  void delayedChain(
    List<({Duration duration, VoidCallback callback})> chain,
  ) {
    var accumulatedDuration = Duration.zero;

    for (final item in chain) {
      accumulatedDuration += item.duration;
      delayed(accumulatedDuration, item.callback);
    }
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    super.dispose();
  }
}
