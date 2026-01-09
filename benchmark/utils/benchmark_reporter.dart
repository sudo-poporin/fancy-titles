/// Utilities for reporting benchmark results.
library;

import 'frame_metrics.dart';

/// Reporter for benchmark results that outputs to console.
class BenchmarkReporter {
  /// Creates a benchmark reporter.
  BenchmarkReporter({this.verbose = false});

  /// Whether to output verbose information.
  final bool verbose;

  /// List of all benchmark results.
  final List<BenchmarkResult> results = [];

  /// Adds a benchmark result.
  void addResult(BenchmarkResult result) {
    results.add(result);
  }

  /// Prints a summary of all benchmark results.
  void printSummary() {
    final buffer = StringBuffer()
      ..writeln()
      ..writeln('=' * 60)
      ..writeln('BENCHMARK SUMMARY')
      ..writeln('=' * 60)
      ..writeln();

    final passed = results.where((r) => r.passed).length;
    final failed = results.length - passed;

    buffer
      ..writeln('Total benchmarks: ${results.length}')
      ..writeln('Passed: $passed')
      ..writeln('Failed: $failed')
      ..writeln();

    // Summary table header
    final header = '${'Widget'.padRight(25)}'
        '${'Avg (ms)'.padRight(12)}'
        '${'P95 (ms)'.padRight(12)}'
        '${'Jank %'.padRight(10)}'
        'Status';
    buffer
      ..writeln(header)
      ..writeln('-' * 70);

    for (final result in results) {
      final avgMs =
          (result.metrics.averageFrameTime.inMicroseconds / 1000)
              .toStringAsFixed(2);
      final p95Ms =
          (result.metrics.p95FrameTime.inMicroseconds / 1000)
              .toStringAsFixed(2);
      final jank = result.metrics.jankPercentage.toStringAsFixed(2);
      final status = result.passed ? 'PASS' : 'FAIL';

      final row = '${result.widgetName.padRight(25)}'
          '${avgMs.padRight(12)}'
          '${p95Ms.padRight(12)}'
          '${jank.padRight(10)}'
          '$status';
      buffer.writeln(row);
    }

    buffer.writeln();

    if (verbose) {
      buffer
        ..writeln('DETAILED RESULTS')
        ..writeln('-' * 60);
      results.forEach(buffer.writeln);
    }

    if (failed > 0) {
      buffer
        ..writeln('FAILURES:')
        ..writeln('-' * 60);
      for (final result in results.where((r) => !r.passed)) {
        buffer.writeln('${result.widgetName}: ${result.failureReason}');
      }
      buffer.writeln();
    }

    // Benchmarks need to output results to console
    // ignore: avoid_print
    print(buffer);
  }

  /// Returns true if all benchmarks passed.
  bool get allPassed => results.every((r) => r.passed);

  /// Generates a JSON report of all results.
  Map<String, dynamic> toJson() => {
        'timestamp': DateTime.now().toIso8601String(),
        'summary': {
          'total': results.length,
          'passed': results.where((r) => r.passed).length,
          'failed': results.where((r) => !r.passed).length,
        },
        'results': results.map((r) => r.toJson()).toList(),
      };
}

/// A single benchmark entry for comparison.
class BaselineEntry {
  /// Creates a baseline entry.
  const BaselineEntry({
    required this.averageFrameTimeUs,
    required this.maxFrameTimeMs,
    required this.jankPercentage,
    required this.initialRenderMs,
  });

  /// Creates a baseline entry from JSON.
  factory BaselineEntry.fromJson(Map<String, dynamic> json) {
    return BaselineEntry(
      averageFrameTimeUs: (json['averageFrameTimeUs'] as num).toInt(),
      maxFrameTimeMs: (json['maxFrameTimeMs'] as num).toInt(),
      jankPercentage: (json['jankPercentage'] as num).toDouble(),
      initialRenderMs: (json['initialRenderMs'] as num).toInt(),
    );
  }

  /// Average frame time in microseconds.
  final int averageFrameTimeUs;

  /// Maximum frame time in milliseconds.
  final int maxFrameTimeMs;

  /// Jank percentage.
  final double jankPercentage;

  /// Initial render time in milliseconds.
  final int initialRenderMs;

  /// Converts to JSON.
  Map<String, dynamic> toJson() => {
        'averageFrameTimeUs': averageFrameTimeUs,
        'maxFrameTimeMs': maxFrameTimeMs,
        'jankPercentage': jankPercentage,
        'initialRenderMs': initialRenderMs,
      };
}
