// lib/src/generator.dart
//
// Core generation logic. Orchestrates ModelAnalyzer → ZodGenerator.
// Does NOT extend source_gen's Generator to avoid part-file conflicts.

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_ts_generator/dart_ts_generator.dart';

class TsZodGenerator {
  final BuilderOptions options;
  final CrossFileRegistry _registry;
  late final ModelAnalyzer _analyzer;
  late final ZodGenerator _zodGen;

  TsZodGenerator(this.options, this._registry) {
    final dateTimeAsString =
        options.config['date_time_as_string'] as bool? ?? true;
    _analyzer = ModelAnalyzer(_registry);
    _zodGen = ZodGenerator(_registry, dateTimeAsString: dateTimeAsString);
  }

  /// Entry point called by the builder for each input asset.
  ///
  /// Returns the generated TypeScript source, or empty string to skip.
  Future<String> generate(
    LibraryElement library,
    AssetId inputId,
    BuildStep buildStep,
  ) async {
    final assetPath = inputId.path; // e.g. "lib/src/Vehicle.dart"

    // Analyze the library
    final classes = _analyzer.analyzeLibrary(library, assetPath);

    if (classes.isEmpty) return '';

    // Filter: only emit output for classes that are @JsonSerializable
    // or enums — skip pure utility files
    final relevant =
        classes.where((c) => c.isEnum || c.hasJsonSerializable).toList();
    if (relevant.isEmpty) return '';

    return _zodGen.generateFile(relevant, assetPath);
  }
}
