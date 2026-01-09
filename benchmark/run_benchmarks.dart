/// Main benchmark runner for fancy_titles package.
///
/// This file consolidates all widget benchmarks and generates a comprehensive
/// performance report. Supports baseline comparison for regression detection.
///
/// Usage:
/// ```bash
/// # Run all benchmarks with report
/// flutter test benchmark/run_benchmarks.dart
///
/// # Run with verbose output
/// flutter test benchmark/run_benchmarks.dart --reporter expanded
///
/// # Save new baseline (set environment variable)
/// SAVE_BASELINE=true flutter test benchmark/run_benchmarks.dart
/// ```
library;

import 'dart:convert';
import 'dart:io';

import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/benchmark_reporter.dart';
import 'utils/frame_metrics.dart';
import 'utils/print_helpers.dart';

/// Baseline file path relative to package root.
const baselinePath = 'benchmark/baseline.json';

/// Performance thresholds for validation.
///
/// Uses slightly relaxed initial render time to account for test environment
/// variability (150ms vs 100ms in production).
const thresholds = BenchmarkThresholds(
  maxInitialRenderMs: 150,
);

/// Relaxed thresholds for EvangelionTitle.
///
/// EvangelionTitle uses discrete pumps (5 intervals) so jank percentage
/// granularity is 20% per frame. Uses higher jank threshold accordingly.
const relaxedThresholds = BenchmarkThresholds(
  maxJankPercentage: 25, // One jank frame = 20% with discrete pumps
  maxInitialRenderMs: 200,
  maxP95FrameTimeMs: 25,
);

void main() {
  final reporter = BenchmarkReporter(verbose: true);
  Map<String, dynamic>? baseline;

  setUpAll(() {
    // Load baseline if exists
    final baselineFile = File(baselinePath);
    if (baselineFile.existsSync()) {
      try {
        final content = baselineFile.readAsStringSync();
        baseline = jsonDecode(content) as Map<String, dynamic>;
        printLine('Loaded baseline from $baselinePath');
      } on FormatException catch (e) {
        printLine('Warning: Could not parse baseline: $e');
      } on FileSystemException catch (e) {
        printLine('Warning: Could not read baseline: $e');
      }
    } else {
      printLine('No baseline found at $baselinePath');
    }
  });

  tearDownAll(() async {
    // Print final report
    reporter.printSummary();

    // Compare against baseline
    if (baseline != null) {
      _compareWithBaseline(reporter, baseline!);
    }

    // Save baseline if requested
    final saveBaseline = Platform.environment['SAVE_BASELINE'] == 'true';
    if (saveBaseline) {
      await _saveBaseline(reporter);
    }
  });

  group('Benchmark Suite', () {
    group('SonicManiaSplash', () {
      testWidgets('full animation', (tester) async {
        final result = await _benchmarkAnimation(
          tester: tester,
          widgetName: 'SonicManiaSplash',
          widget: SonicManiaSplash(
            baseText: 'BENCHMARK',
            secondaryText: 'TEST',
            lastText: 'RUN',
          ),
          duration: SonicManiaTiming.totalDuration,
          thresholds: thresholds,
        );
        reporter.addResult(result);
        expect(result.passed, isTrue, reason: result.failureReason);
      });
    });

    group('Persona5Title', () {
      testWidgets('full animation', (tester) async {
        final result = await _benchmarkAnimation(
          tester: tester,
          widgetName: 'Persona5Title',
          widget: const Persona5Title(text: 'TAKE YOUR TIME'),
          duration: Persona5Timing.totalDuration,
          thresholds: thresholds,
        );
        reporter.addResult(result);
        expect(result.passed, isTrue, reason: result.failureReason);
      });
    });

    group('EvangelionTitle', () {
      testWidgets('full animation', (tester) async {
        final result = await _benchmarkAnimation(
          tester: tester,
          widgetName: 'EvangelionTitle',
          widget: const EvangelionTitle(),
          duration: EvangelionTiming.totalDuration,
          thresholds: relaxedThresholds,
          discretePump: true, // Use discrete pumps for CachedBlurWidget
        );
        reporter.addResult(result);
        expect(result.passed, isTrue, reason: result.failureReason);
      });
    });

    group('MarioMakerTitle', () {
      testWidgets('full animation', (tester) async {
        final result = await _benchmarkAnimation(
          tester: tester,
          widgetName: 'MarioMakerTitle',
          widget: const MarioMakerTitle(
            title: 'WORLD 1-1',
            imagePath: 'test/fixtures/test_image.png',
          ),
          duration: MarioMakerTiming.defaultTotalDuration,
          thresholds: thresholds,
          postAnimationDelay: const Duration(seconds: 1),
        );
        reporter.addResult(result);
        expect(result.passed, isTrue, reason: result.failureReason);
      });

      testWidgets('stress test (large image)', (tester) async {
        final result = await _benchmarkAnimation(
          tester: tester,
          widgetName: 'MarioMakerTitle (97KB)',
          widget: const MarioMakerTitle(
            title: 'STRESS TEST',
            imagePath: 'test/fixtures/large_image.png',
          ),
          duration: MarioMakerTiming.defaultTotalDuration,
          thresholds: relaxedThresholds,
          postAnimationDelay: const Duration(seconds: 1),
        );
        reporter.addResult(result);
        expect(result.passed, isTrue, reason: result.failureReason);
      });
    });
  });
}

/// Benchmarks a widget animation and returns results.
Future<BenchmarkResult> _benchmarkAnimation({
  required WidgetTester tester,
  required String widgetName,
  required Widget widget,
  required Duration duration,
  required BenchmarkThresholds thresholds,
  Duration postAnimationDelay = Duration.zero,
  bool discretePump = false,
}) async {
  final metrics = FrameMetrics();
  final stopwatch = Stopwatch();

  // Measure initial render
  final initialStopwatch = Stopwatch()..start();
  await tester.pumpWidget(MaterialApp(home: widget));
  initialStopwatch.stop();
  final initialRender = initialStopwatch.elapsed;

  // Run animation
  if (discretePump) {
    // Discrete pumps for widgets with async operations (CachedBlurWidget)
    final intervals = [
      Duration.zero,
      const Duration(milliseconds: 500),
      const Duration(seconds: 1),
      const Duration(seconds: 2),
      const Duration(seconds: 3),
      duration,
    ];

    for (var i = 0; i < intervals.length - 1; i++) {
      final delta = intervals[i + 1] - intervals[i];
      stopwatch
        ..reset()
        ..start();
      await tester.pump(delta);
      stopwatch.stop();
      metrics.recordFrame(stopwatch.elapsed);
    }
  } else {
    // Frame-by-frame measurement
    const frameInterval = Duration(milliseconds: 16);
    var elapsed = Duration.zero;

    while (elapsed < duration) {
      stopwatch
        ..reset()
        ..start();

      await tester.pump(frameInterval);

      stopwatch.stop();
      metrics.recordFrame(stopwatch.elapsed);

      elapsed += frameInterval;
    }
  }

  // Post-animation delay if needed
  if (postAnimationDelay > Duration.zero) {
    await tester.pump(postAnimationDelay);
  }

  // Validate against thresholds
  final failureReason = thresholds.validate(metrics, initialRender);

  return BenchmarkResult(
    widgetName: widgetName,
    metrics: metrics,
    initialRenderTime: initialRender,
    passed: failureReason == null,
    failureReason: failureReason,
  );
}

/// Compares results against baseline and prints regression warnings.
void _compareWithBaseline(
  BenchmarkReporter reporter,
  Map<String, dynamic> baseline,
) {
  final widgets = baseline['widgets'] as Map<String, dynamic>?;
  if (widgets == null) return;

  final baselineThresholds = baseline['thresholds'] as Map<String, dynamic>?;
  final regressionThreshold =
      (baselineThresholds?['regressionThreshold'] as num?)?.toDouble() ?? 0.1;

  printLine('');
  printLine('=' * 60);
  printLine('BASELINE COMPARISON');
  printLine('=' * 60);
  printLine('Baseline version: ${baseline['version']}');
  printLine('Baseline date: ${baseline['date']}');
  printLine('Regression threshold: ${(regressionThreshold * 100).toInt()}%');
  printLine('');

  var regressionFound = false;

  for (final result in reporter.results) {
    final widgetBaseline =
        widgets[result.widgetName] as Map<String, dynamic>?;
    if (widgetBaseline == null) {
      printLine('${result.widgetName}: No baseline (new widget)');
      continue;
    }

    final entry = BaselineEntry.fromJson(widgetBaseline);
    final currentAvgUs = result.metrics.averageFrameTime.inMicroseconds;
    final currentJank = result.metrics.jankPercentage;
    final currentInitialMs = result.initialRenderTime.inMilliseconds;

    // Check for regressions
    final avgRegression =
        (currentAvgUs - entry.averageFrameTimeUs) / entry.averageFrameTimeUs;
    final jankRegression = entry.jankPercentage > 0
        ? (currentJank - entry.jankPercentage) / entry.jankPercentage
        : (currentJank > 0 ? 1.0 : 0);
    final initialRegression =
        (currentInitialMs - entry.initialRenderMs) / entry.initialRenderMs;

    final warnings = <String>[];

    if (avgRegression > regressionThreshold) {
      warnings.add(
        'Avg frame: ${entry.averageFrameTimeUs}us -> ${currentAvgUs}us '
        '(+${(avgRegression * 100).toStringAsFixed(1)}%)',
      );
    }

    if (jankRegression > regressionThreshold && currentJank > 0.5) {
      warnings.add(
        'Jank: ${entry.jankPercentage.toStringAsFixed(2)}% -> '
        '${currentJank.toStringAsFixed(2)}%',
      );
    }

    if (initialRegression > regressionThreshold) {
      warnings.add(
        'Initial render: ${entry.initialRenderMs}ms -> ${currentInitialMs}ms '
        '(+${(initialRegression * 100).toStringAsFixed(1)}%)',
      );
    }

    if (warnings.isNotEmpty) {
      regressionFound = true;
      printLine('${result.widgetName}: REGRESSION DETECTED');
      for (final warning in warnings) {
        printLine('  - $warning');
      }
    } else {
      final improvement = avgRegression < -0.05
          ? ' (improved ${(-avgRegression * 100).toStringAsFixed(1)}%)'
          : '';
      printLine('${result.widgetName}: OK$improvement');
    }
  }

  printLine('');
  if (regressionFound) {
    printLine('WARNING: Performance regressions detected!');
    printLine('Consider running individual benchmarks for more details.');
  } else {
    printLine('All widgets meet baseline performance.');
  }
}

/// Saves current results as new baseline.
Future<void> _saveBaseline(BenchmarkReporter reporter) async {
  final widgets = <String, Map<String, dynamic>>{};

  for (final result in reporter.results) {
    widgets[result.widgetName] = BaselineEntry(
      averageFrameTimeUs: result.metrics.averageFrameTime.inMicroseconds,
      maxFrameTimeMs: result.metrics.maxFrameTime.inMilliseconds,
      jankPercentage: result.metrics.jankPercentage,
      initialRenderMs: result.initialRenderTime.inMilliseconds,
    ).toJson();
  }

  final baseline = {
    'version': '1.0.6',
    'date': DateTime.now().toIso8601String().split('T').first,
    'widgets': widgets,
    'thresholds': {
      'maxJankPercentage': 1.0,
      'maxFrameTimeMs': 16,
      'maxInitialRenderMs': 100,
      'regressionThreshold': 0.1,
    },
  };

  const encoder = JsonEncoder.withIndent('  ');
  final content = encoder.convert(baseline);

  final file = File(baselinePath);
  await file.writeAsString('$content\n');

  printLine('');
  printLine('Baseline saved to $baselinePath');
}
