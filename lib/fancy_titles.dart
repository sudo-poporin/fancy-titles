/// Paquete que contiene widgets de splash y títulos basados en animes
/// y videojuegos.
/// Este paquete incluye títulos de:
/// - Neon Genesis Evangelion
/// - Mario Maker
/// - Persona 5
/// - Sonic Mania
library;

// Core
export 'core/animation_phase.dart';
export 'core/animation_timings.dart';
export 'core/base_title_widget.dart';
export 'core/cancelable_timers.dart';
export 'core/fancy_title_controller.dart';
export 'core/fancy_title_controller_scope.dart';
export 'core/fancy_titles_theme.dart';
export 'core/pausable_animation_mixin.dart';

// Evangelion
export 'evangelion/evangelion_theme.dart';
export 'evangelion/evangelion_title.dart';
export 'evangelion/evangelion_title_controller.dart';

// Mario Maker
export 'mario_maker/mario_maker_theme.dart';
export 'mario_maker/mario_maker_title.dart';
export 'mario_maker/mario_maker_title_controller.dart';

// Persona 5
export 'persona_5/persona_5_theme.dart';
export 'persona_5/persona_5_title.dart';
export 'persona_5/persona_5_title_controller.dart';

// Sonic Mania
export 'sonic_mania/sonic_mania_splash.dart';
export 'sonic_mania/sonic_mania_splash_controller.dart';
export 'sonic_mania/sonic_mania_theme.dart';
