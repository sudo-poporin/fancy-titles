/// Fases de una animación de título.
///
/// Define los estados por los que pasa una animación durante su ciclo de vida.
/// Útil para sincronizar efectos externos (sonido, navegación, etc.)
/// con momentos específicos de la animación.
///
/// ## Ciclo de vida típico
///
/// ```text
/// idle → entering → active → exiting → completed
/// ```
///
/// ## Ejemplo de uso
///
/// ```dart
/// SonicManiaSplash(
///   baseText: 'LEVEL 1',
///   onPhaseChange: (phase) {
///     switch (phase) {
///       case AnimationPhase.entering:
///         audioPlayer.play('whoosh.mp3');
///         break;
///       case AnimationPhase.active:
///         audioPlayer.play('reveal.mp3');
///         break;
///       case AnimationPhase.exiting:
///         audioPlayer.play('exit.mp3');
///         break;
///       case AnimationPhase.completed:
///         Navigator.of(context).pushReplacement(...);
///         break;
///       default:
///         break;
///     }
///   },
/// )
/// ```
enum AnimationPhase {
  /// Animación no iniciada.
  ///
  /// Estado inicial antes de que cualquier animación comience.
  idle,

  /// Elementos entrando a la pantalla.
  ///
  /// En esta fase los elementos visuales están animándose hacia
  /// sus posiciones finales (slide in, fade in, scale up, etc.).
  entering,

  /// Contenido principal visible y estable.
  ///
  /// En esta fase el contenido está completamente visible y
  /// en reposo. Es el momento ideal para que el usuario
  /// lea el texto o vea la imagen.
  active,

  /// Elementos saliendo de la pantalla.
  ///
  /// En esta fase los elementos visuales están animándose
  /// hacia afuera (slide out, fade out, iris out, etc.).
  exiting,

  /// Animación completada.
  ///
  /// El widget ha terminado su ciclo de vida y está listo
  /// para ser removido del árbol de widgets.
  completed,
}
