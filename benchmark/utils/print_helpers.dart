/// Helper functions for benchmark output.
///
/// Benchmarks need to output results to console, which triggers the
/// `avoid_print` lint. These helpers centralize the ignore comments.
library;

import 'frame_metrics.dart';

/// Prints a line to console.
///
/// Used by benchmarks to output results. The avoid_print lint is
/// intentionally ignored since benchmarks require console output.
void printLine(String message) {
  // Benchmarks output to console by design
  // ignore: avoid_print
  print(message);
}

/// Prints frame metrics with a title.
void printMetrics(String title, FrameMetrics metrics) {
  printLine(title);
  printLine(metrics.toString());
}

/// Prints phase-specific metrics.
void printPhaseMetrics(String title, int avgUs, double jankPct) {
  printLine(title);
  final avgMs = (avgUs / 1000).toStringAsFixed(2);
  printLine('  Average: ${avgUs}us ($avgMs ms)');
  printLine('  Jank: ${jankPct.toStringAsFixed(2)}%');
}

/// Prints initial render time.
void printInitialRender(String widgetName, int milliseconds) {
  printLine('$widgetName Initial render: ${milliseconds}ms');
}
