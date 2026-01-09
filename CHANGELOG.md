# Registro de Cambios

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Versionado Semántico](https://semver.org/lang/es/).

## [1.0.7] - 2026-01-08

### Agregado

- Suite de benchmarks de performance para los 4 widgets principales
  - `benchmark/sonic_mania_benchmark.dart`
  - `benchmark/persona_5_benchmark.dart`
  - `benchmark/evangelion_benchmark.dart`
  - `benchmark/mario_maker_benchmark.dart`
- Utilidades JankDetector y TestJankDetector para análisis de tiempos de frame
- Suite de tests de performance con 92+ tests
  - `test/performance/painter_allocations_test.dart` (22 tests)
  - `test/performance/clipper_allocations_test.dart` (21 tests)
  - `test/performance/jank_test.dart` (21 tests)
- Archivo de baseline de performance (`benchmark/baseline.json`)
- Documentación de benchmarks (`benchmark/README.md`)
- Integration tests para los 4 widgets principales
  - `example/integration_test/evangelion_performance_test.dart`
  - `example/integration_test/sonic_mania_performance_test.dart`
  - `example/integration_test/persona_5_performance_test.dart`
  - `example/integration_test/mario_maker_performance_test.dart`

### Documentación

- Documentado callback `onPhaseChange` en README.md
- Documentado enum `AnimationPhase` con todas las fases
- Actualizado example/README.md con instrucciones de integration tests
- Actualizadas métricas en OPTIMIZATION_PROPOSALS.md

### Modificado

- Refactorizado CachedBlurWidget para cancelar timers pendientes en dispose
- Actualizado CachedBlurPainter con manejo apropiado de disposal

### Rendimiento

- Todos los widgets validados con <1% jank frames (objetivo: 60fps)
- Tiempo promedio de frame menor a 1ms en entorno de test
- Tests de estrés validados con texto largo e imágenes grandes

## [1.0.6] - 2026-01-08

### Agregado

- Cache de Path en 21 CustomPainters y CustomClippers para reducir jank frames
  - Evangelion: 11 painters (6 cross + 5 curtain) con cache de Path estático
  - SonicMania: 6 clippers (4 bar + 2 curtain) con cache de Path estático
  - SonicMania: 2 painters (LargeBGDraw + SmallBGDraw) con cache de Path estático
  - MarioMaker: CircleMaskClipper con cache de Path estático
- Objetos Paint estáticos pre-creados en CirclePainter (Persona5)
- TweenSequence estático en ExpandingCircleMask (MarioMaker)
- Documentación dartdoc completa para 7 widgets internos

### Modificado

- CirclePainter ahora usa drawOval en lugar de drawPath para mejor rendimiento
- Actualizado README.md con sección de callbacks
- Reducidas allocations estimadas por frame de ~60 a ~5

### Rendimiento

- Eliminada creación de objetos Path en métodos paint() y getClip()
- Reducida presión sobre el GC durante animaciones
- Tiempos de frame consistentemente bajo los 16ms objetivo para 60fps

## [1.0.5] - 2026-01-08

### Modificado

- Migradas 17 instancias de Duration hardcodeadas a constantes centralizadas
  - SonicMania: 14 instancias (clipped_bar.dart, clipped_curtain.dart)
  - Evangelion: 1 instancia (cached_blur_widget.dart)
  - MarioMaker: 2 instancias (bouncing_circle.dart)
- Actualizado animation_timings.dart con 17 nuevas constantes:
  - SonicManiaTiming: constantes clippedBar* y clippedCurtain*
  - EvangelionTiming: blurCacheDelay
  - MarioMakerTiming: bounceDurationDefault, imageScaleOutDuration
- Mejorado README.md con ejemplos detallados y GIFs para todos los widgets
- Agregados 25 nuevos tests para constantes de timing OPT-005

### Corregido

- Ninguno (paquete en estado estable)

## [1.0.4] - 2026-01-07

### Agregado

- Tests directos para todos los widgets internos (23/23)
- 739 tests con 97.8% de cobertura
- Golden tests para los 4 widgets principales

### Modificado

- Optimizado shouldRepaint() en todos los painters
- Centralizados timings de animación (44 constantes en 4 clases)

### Corregido

- Corregidos 9 warnings de lint
- Eliminado uso de API deprecada

## [1.0.3] - 2026-01-06

### Agregado

- Suite comprehensiva de tests (OPT-003)
- Tests para todos los painters, clippers y widgets
- Testing de casos borde para fases de animación

### Modificado

- Mejorada organización de tests con carpetas dedicadas por módulo

## [1.0.2] - 2026-01-05

### Agregado

- Golden tests iniciales para regresión visual
- Widget tests para pantallas splash principales
- Testing de fases de animación

### Modificado

- Consolidadas constantes de timing en core/animation_timings.dart

## [1.0.1] - 2026-01-04

### Agregado

- Mixin de timers cancelables (CancelableTimers)
- Callbacks de ciclo de vida de animación (onAnimationStart, onAnimationComplete)
- Documentación de API para todos los widgets públicos

### Modificado

- Unificada estructura de directorios en todos los módulos
- Normalizadas convenciones de nombres

### Corregido

- Memory leaks por timers no cancelados
- Errores de setState después de dispose

## [1.0.0] - 2026-01-01

### Agregado

- Release inicial con 4 widgets de splash screen:
  - SonicManiaSplash - Inspirado en las tarjetas de nivel de Sonic Mania
  - Persona5Title - Inspirado en los títulos de capítulo de Persona 5
  - EvangelionTitle - Inspirado en los títulos de episodio de Neon Genesis Evangelion
  - MarioMakerTitle - Inspirado en las revelaciones de curso de Super Mario Maker
- Fuentes personalizadas: ManiaZoneCard, Persona, EVAMatisseClassic
- Diseño responsive para modos portrait y landscape
- App de ejemplo demostrando todos los widgets
