/// Constantes de timing para todas las animaciones del paquete fancy_titles.
///
/// Este archivo centraliza todas las duraciones y delays de animación
/// para facilitar ajustes y mantener consistencia entre módulos.
library;

// =============================================================================
// SONIC MANIA TIMINGS
// =============================================================================

/// Timings para SonicManiaSplash y widgets relacionados.
abstract final class SonicManiaTiming {
  // ---------------------------------------------------------------------------
  // Duraciones principales
  // ---------------------------------------------------------------------------

  /// Duración del slide inicial de las barras de texto.
  static const slideIn = Duration(milliseconds: 600);

  /// Tiempo que el texto permanece visible antes de salir.
  static const slideOutDelay = Duration(milliseconds: 3500);

  /// Duración total de la animación (auto-destrucción).
  static const totalDuration = Duration(milliseconds: 5000);

  /// Duración del fade transition del AnimatedSwitcher.
  static const fadeTransition = Duration(milliseconds: 125);

  // ---------------------------------------------------------------------------
  // Cortinas (Curtains)
  // ---------------------------------------------------------------------------

  /// Duración de la expansión de las cortinas de color.
  static const curtainExpandDuration = Duration(milliseconds: 175);

  /// Delay de la cortina azul (primera).
  static const Duration curtainBlueDelay = Duration.zero;

  /// Delay de la cortina naranja.
  static const curtainOrangeDelay = Duration(milliseconds: 150);

  /// Delay de la cortina ámbar.
  static const curtainAmberDelay = Duration(milliseconds: 300);

  /// Delay de la cortina verde.
  static const curtainGreenDelay = Duration(milliseconds: 450);

  /// Delay de la cortina amarilla.
  static const curtainYellowDelay = Duration(milliseconds: 600);

  /// Delay de la cortina negra.
  static const curtainBlackDelay = Duration(milliseconds: 350);

  // ---------------------------------------------------------------------------
  // Bounce (Texto rebotando)
  // ---------------------------------------------------------------------------

  /// Duración de la animación de rebote vertical.
  static const bounceVerticallyDuration = Duration(milliseconds: 250);

  /// Delay inicial antes del rebote.
  static const bounceVerticallyDelay = Duration(milliseconds: 250);

  // ---------------------------------------------------------------------------
  // Clipped Bars (Barras recortadas diagonales)
  // ---------------------------------------------------------------------------

  /// Delay inicial antes de que las barras recortadas aparezcan.
  static const clippedBarInitialDelay = Duration(milliseconds: 725);

  /// Duración por defecto de la animación de barras recortadas.
  static const clippedBarDefaultDuration = Duration(milliseconds: 325);

  /// Delay por defecto antes del slide out de barras recortadas.
  static const clippedBarDefaultDelay = Duration(milliseconds: 2400);

  /// Duración de la barra roja.
  static const clippedBarRedDuration = Duration(milliseconds: 150);

  /// Delay de la barra roja.
  static const clippedBarRedDelay = Duration(milliseconds: 2200);

  /// Duración de la barra naranja.
  static const clippedBarOrangeDuration = Duration(milliseconds: 150);

  /// Delay de la barra naranja.
  static const clippedBarOrangeDelay = Duration(milliseconds: 2000);

  /// Duración de la barra azul.
  static const clippedBarBlueDuration = Duration(milliseconds: 375);

  /// Delay de la barra azul.
  static const clippedBarBlueDelay = Duration(milliseconds: 2400);

  /// Duración de la barra verde.
  static const clippedBarGreenDuration = Duration(milliseconds: 200);

  /// Delay de la barra verde.
  static const clippedBarGreenDelay = Duration(milliseconds: 2200);

  // ---------------------------------------------------------------------------
  // Clipped Curtains (Cortinas recortadas)
  // ---------------------------------------------------------------------------

  /// Duración de la animación de cortinas recortadas.
  static const clippedCurtainDuration = Duration(milliseconds: 325);

  /// Delay inicial antes de que las cortinas recortadas aparezcan.
  static const clippedCurtainInitialDelay = Duration(milliseconds: 500);

  /// Delay antes del slide out de las cortinas recortadas.
  static const clippedCurtainSlideOutDelay = Duration(milliseconds: 2500);
}

// =============================================================================
// PERSONA 5 TIMINGS
// =============================================================================

/// Timings para Persona5Title y widgets relacionados.
abstract final class Persona5Timing {
  // ---------------------------------------------------------------------------
  // Duraciones principales
  // ---------------------------------------------------------------------------

  /// Delay inicial por defecto antes de la animación.
  static const initialDelay = Duration(milliseconds: 125);

  /// Duración de la animación principal.
  static const mainDuration = Duration(milliseconds: 3400);

  /// Duración total incluyendo fade out (auto-destrucción).
  static const totalDuration = Duration(milliseconds: 4000);

  /// Delay antes de que aparezca el texto.
  static const textAppearDelay = Duration(milliseconds: 250);

  // ---------------------------------------------------------------------------
  // Transiciones
  // ---------------------------------------------------------------------------

  /// Duración del fade transition (reverse).
  static const fadeTransitionReverse = Duration(milliseconds: 225);

  /// Duración de la transición del círculo de fondo.
  static const circleTransitionDuration = Duration(milliseconds: 325);
}

// =============================================================================
// EVANGELION TIMINGS
// =============================================================================

/// Timings para EvangelionTitle y widgets relacionados.
abstract final class EvangelionTiming {
  // ---------------------------------------------------------------------------
  // Duraciones principales
  // ---------------------------------------------------------------------------

  /// Delay antes de mostrar el texto.
  static const textAppearDelay = Duration(milliseconds: 450);

  /// Momento en que el fondo se vuelve transparente.
  static const backgroundFadeTime = Duration(milliseconds: 3000);

  /// Duración total de la animación (auto-destrucción).
  static const totalDuration = Duration(milliseconds: 5000);

  /// Duración del fade transition del AnimatedSwitcher.
  static const fadeTransition = Duration(milliseconds: 125);

  /// Duración de la transición del AnimatedContainer.
  static const containerTransition = Duration(milliseconds: 275);

  // ---------------------------------------------------------------------------
  // Sparks (Cruces de luz)
  // ---------------------------------------------------------------------------

  /// Duración de cada flash de cruz.
  static const crossFlashDuration = Duration(milliseconds: 75);

  /// Duración por defecto de los sparks.
  static const sparkDefaultDuration = Duration(milliseconds: 50);

  /// Delay del primer spark.
  static const Duration sparkFirstDelay = Duration.zero;

  /// Delay del segundo spark.
  static const sparkSecondDelay = Duration(milliseconds: 150);

  /// Delay del tercer spark.
  static const sparkThirdDelay = Duration(milliseconds: 230);

  /// Delay del cuarto spark.
  static const sparkFourthDelay = Duration(milliseconds: 330);

  /// Delay del quinto spark.
  static const sparkFifthDelay = Duration(milliseconds: 400);

  /// Delay del sexto spark.
  static const sparkSixthDelay = Duration(milliseconds: 475);

  // ---------------------------------------------------------------------------
  // Curtains (Cortinas de Evangelion)
  // ---------------------------------------------------------------------------

  /// Duración de la primera cortina.
  static const curtainFirstDuration = Duration(milliseconds: 75);

  /// Duración de las cortinas secundarias.
  static const curtainSecondaryDuration = Duration(milliseconds: 60);

  /// Delay de la primera cortina.
  static const Duration curtainFirstDelay = Duration.zero;

  /// Delay de la segunda cortina.
  static const curtainSecondDelay = Duration(milliseconds: 150);

  /// Delay de la tercera cortina.
  static const curtainThirdDelay = Duration(milliseconds: 200);

  /// Delay de la cuarta cortina.
  static const curtainFourthDelay = Duration(milliseconds: 320);

  /// Delay de la quinta cortina.
  static const curtainFifthDelay = Duration(milliseconds: 380);

  /// Delay de la sexta cortina.
  static const curtainSixthDelay = Duration(milliseconds: 450);

  // ---------------------------------------------------------------------------
  // Cache (Renderizado con blur)
  // ---------------------------------------------------------------------------

  /// Delay para programar la captura de imagen con blur.
  ///
  /// Aproximadamente 1 frame a 60fps para sincronización con el ciclo
  /// de renderizado.
  static const blurCacheDelay = Duration(milliseconds: 16);
}

// =============================================================================
// MARIO MAKER TIMINGS
// =============================================================================

/// Timings para MarioMakerTitle y widgets relacionados.
abstract final class MarioMakerTiming {
  // ---------------------------------------------------------------------------
  // Duraciones principales
  // ---------------------------------------------------------------------------

  /// Duración total por defecto de la animación.
  static const defaultTotalDuration = Duration(seconds: 4);

  /// Duración del efecto iris-out (contracción del círculo).
  static const irisOutDuration = Duration(milliseconds: 500);

  /// Delay antes de que entre el título.
  static const titleEntryDelay = Duration(milliseconds: 1400);

  // ---------------------------------------------------------------------------
  // Bouncing Circle
  // ---------------------------------------------------------------------------

  /// Duración de la fase de rebote del círculo.
  static const bounceDuration = Duration(milliseconds: 1200);

  // ---------------------------------------------------------------------------
  // Expanding Circle
  // ---------------------------------------------------------------------------

  /// Delay antes de la expansión del círculo.
  static const expandDelay = Duration(milliseconds: 1200);

  /// Duración de la expansión del círculo.
  static const expandDuration = Duration(milliseconds: 800);

  /// Delay por defecto para ExpandingCircleMask.
  static const expandDelayDefault = Duration(seconds: 2);

  /// Duración por defecto para ExpandingCircleMask.
  static const expandDurationDefault = Duration(milliseconds: 1500);

  // ---------------------------------------------------------------------------
  // Sliding Title
  // ---------------------------------------------------------------------------

  /// Duración del slide del título.
  static const slideDuration = Duration(milliseconds: 500);

  /// Delay por defecto antes del slide del título.
  static const slideDelayDefault = Duration(milliseconds: 3500);

  // ---------------------------------------------------------------------------
  // Contracting Circle
  // ---------------------------------------------------------------------------

  /// Duración del efecto de contracción del círculo (iris).
  static const contractDuration = Duration(milliseconds: 500);

  // ---------------------------------------------------------------------------
  // Bouncing Circle (valores por defecto del widget)
  // ---------------------------------------------------------------------------

  /// Duración por defecto del rebote en BouncingCircle.
  ///
  /// Se usa cuando no se especifica un valor personalizado.
  static const bounceDurationDefault = Duration(seconds: 2);

  /// Duración del scale-out de la imagen después del rebote.
  static const imageScaleOutDuration = Duration(milliseconds: 300);
}
