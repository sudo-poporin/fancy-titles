# Benchmarks de Performance

Este directorio contiene tests de benchmark de performance para todos los widgets
de fancy_titles.

## Inicio Rapido

```bash
# Ejecutar suite completa de benchmarks con reporte
flutter test benchmark/run_benchmarks.dart

# Ejecutar todos los benchmarks individuales
flutter test benchmark/

# Ejecutar benchmark de un widget especifico
flutter test benchmark/sonic_mania_benchmark.dart
```

## Script Principal

El punto de entrada principal es `run_benchmarks.dart`, que:

1. Ejecuta benchmarks para todos los widgets
2. Genera un reporte de performance consolidado
3. Compara resultados contra baseline (si existe)
4. Opcionalmente guarda nueva baseline

### Uso

```bash
# Ejecutar con reporte resumido
flutter test benchmark/run_benchmarks.dart

# Ejecutar con salida detallada (recomendado)
flutter test benchmark/run_benchmarks.dart --reporter expanded

# Guardar nueva baseline
SAVE_BASELINE=true flutter test benchmark/run_benchmarks.dart
```

### Ejemplo de Salida

```text
============================================================
BENCHMARK SUMMARY
============================================================

Total benchmarks: 5
Passed: 5
Failed: 0

Widget                   Avg (ms)    P95 (ms)    Jank %    Status
----------------------------------------------------------------------
SonicManiaSplash         0.67        1.79        0.32      PASS
Persona5Title            0.12        0.44        0.00      PASS
EvangelionTitle          4.51        15.46       0.00      PASS
MarioMakerTitle          0.24        0.52        0.00      PASS
MarioMakerTitle (97KB)   0.18        0.37        0.00      PASS
```

## Comparacion contra Baseline

El archivo baseline (`baseline.json`) contiene metricas de performance de
referencia. Al ejecutar benchmarks, los resultados se comparan contra la
baseline para detectar regresiones.

### Deteccion de Regresiones

Se marca una regresion cuando cualquier metrica excede la baseline por mas del
`regressionThreshold` (por defecto: 20%). Metricas comparadas:

- Tiempo promedio de frame (microsegundos)
- Porcentaje de jank
- Tiempo de render inicial (milisegundos)

### Crear/Actualizar Baseline

```bash
# Guardar resultados actuales como nueva baseline
SAVE_BASELINE=true flutter test benchmark/run_benchmarks.dart
```

La baseline debe actualizarse cuando:

- Se verifican optimizaciones de performance
- El entorno de tests cambia significativamente
- Se agregan nuevos widgets

## Archivos de Benchmark Individuales

| Archivo | Widget | Tests | Descripcion |
|---------|--------|-------|-------------|
| `sonic_mania_benchmark.dart` | SonicManiaSplash | 5 | Animacion completa, slide-in, barras |
| `persona_5_benchmark.dart` | Persona5Title | 6 | Animacion completa, circulos, texto |
| `evangelion_benchmark.dart` | EvangelionTitle | 6 | Render inicial, callbacks, texto |
| `mario_maker_benchmark.dart` | MarioMakerTitle | 6 | Animacion completa, iris, stress test |
| `run_benchmarks.dart` | Todos | 5 | Suite consolidada con comparacion |

## Assets de Test

Los assets para benchmarks estan en `test/fixtures/`:

- `test_image.png` (1.8KB) - Imagen estandar para tests
- `large_image.png` (97KB) - Imagen para stress tests

## Metricas Capturadas

Cada benchmark mide:

| Metrica | Descripcion |
|---------|-------------|
| Total frames | Cantidad de frames renderizados durante la animacion |
| Tiempo promedio | Duracion promedio de frame en microsegundos |
| Tiempo P95 | Percentil 95 del tiempo de frame |
| Desviacion estandar | Consistencia del tiempo de frame |
| Porcentaje de jank | Frames que exceden el umbral de 16ms |
| Frames con jank | Cantidad de frames > 16ms |
| Tiempo maximo | Peor caso de duracion de frame |
| Render inicial | Tiempo para el primer build del widget |

## Umbrales de Performance

### Widgets Estandar

| Metrica | Umbral | Descripcion |
|---------|--------|-------------|
| Jank % | < 1% | Animaciones normales |
| Tiempo promedio | < 16ms | Objetivo de 60fps |
| Tiempo P95 | < 16ms | Performance consistente |
| Render inicial | < 150ms | Considera overhead del test |

### Widgets Complejos (EvangelionTitle)

| Metrica | Umbral | Descripcion |
|---------|--------|-------------|
| Jank % | < 25% | Pumps discretos (5 intervalos) |
| Render inicial | < 200ms | Cache de blur complejo |
| Tiempo P95 | < 25ms | Permite operaciones de blur |

## Utilidades

### `utils/frame_metrics.dart`

Clase principal para recolectar y calcular metricas de frame:

```dart
final metrics = FrameMetrics();
metrics.recordFrame(stopwatch.elapsed);
print(metrics.averageFrameTime);
print(metrics.jankPercentage);
```

### `utils/benchmark_reporter.dart`

Reporter para generar reportes resumidos y salida JSON:

```dart
final reporter = BenchmarkReporter(verbose: true);
reporter.addResult(result);
reporter.printSummary();
```

### `utils/jank_detector.dart`

Detector de jank para integration tests usando `SchedulerBinding`:

```dart
final detector = JankDetector();
detector.startRecording();
// Ejecutar animacion...
detector.stopRecording();
print(detector.getStats());
```

## Integration Tests

Para metricas frame-by-frame de EvangelionTitle (requiere dispositivo):

```bash
cd example
flutter test integration_test/evangelion_performance_test.dart -d <device_id>
```

Los integration tests son necesarios porque CachedBlurWidget usa
`RenderRepaintBoundary.toImage()` que requiere una superficie de render real.

## Performance Actual (v1.0.6)

Metricas baseline del entorno de tests:

| Widget | Tiempo Prom | Jank % | Render Inicial | Notas |
|--------|-------------|--------|----------------|-------|
| SonicManiaSplash | ~700us | 0.32% | ~130ms | Ciclo de animacion completo |
| Persona5Title | ~200us | 0% | ~15ms | Overhead minimo |
| EvangelionTitle | ~6000us | 20%* | ~20ms | *Pumps discretos |
| MarioMakerTitle | ~500us | 0% | ~50ms | Con cache de imagen |
| MarioMakerTitle (97KB) | ~300us | 0% | ~15ms | Stress test |

**Nota:** Los resultados varian segun el entorno de tests. Usar para deteccion
de regresiones.

## Solucion de Problemas

### Jank alto en un widget especifico

Verificar si el widget usa:

- Procesamiento de imagenes pesado
- Operaciones asincronas
- Operaciones de paint complejas

Considera usar integration tests para metricas mas precisas.

### La comparacion de baseline muestra regresiones

1. Verificar que el entorno de tests sea consistente
2. Ejecutar multiples veces para considerar variabilidad
3. Si es una regresion genuina, investigar cambios recientes
4. Si es esperado, actualizar baseline con `SAVE_BASELINE=true`
