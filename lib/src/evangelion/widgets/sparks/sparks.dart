// Barrel file for spark variants under `lib/src/`.
//
// Each `NthSpark` class is annotated `@internal` from `package:meta` and
// lives under `lib/src/`, so:
// - Consumers importing `package:fancy_titles/src/...` trigger the
//   `implementation_imports` lint.
// - The Dart analyzer flags any external use as `internal_member` warning.
// - These classes are NOT re-exported from `lib/fancy_titles.dart`.
// Public API surface is the `Spark` dispatcher in
// `lib/evangelion/widgets/spark.dart`.
export 'fifth_spark.dart';
export 'first_spark.dart';
export 'fourth_spark.dart';
export 'second_spark.dart';
export 'sixth_spark.dart';
export 'third_spark.dart';
