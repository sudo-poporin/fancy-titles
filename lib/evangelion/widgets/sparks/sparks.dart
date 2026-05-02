// Barrel file for spark variants.
//
// Each `Nth Spark` class is technically public (Dart cannot share
// `_`-prefixed private classes across files without `part`/`part of`)
// but is NOT exported from `lib/fancy_titles.dart`, so it is unreachable
// from package consumers. Treat them as internal to the spark dispatcher.
export 'fifth_spark.dart';
export 'first_spark.dart';
export 'fourth_spark.dart';
export 'second_spark.dart';
export 'sixth_spark.dart';
export 'third_spark.dart';
