// lib/builder.dart
//
// ── Output layout ─────────────────────────────────────────────────────────────
//
//   lib/src/Vehicle.dart           →  gen/src/Vehicle.g.ts
//   lib/src/enums/DLStatus.dart    →  gen/src/enums/DLStatus.g.ts
//   lib/src/config/AppConfig.dart  →  gen/src/config/AppConfig.g.ts
//
// TSC then compiles gen/**/*.g.ts  →  dist/
// package.json points at dist/ for npm / git-dependency consumers.
//
// ── Why the capture-group pattern ────────────────────────────────────────────
// build_runner validates every AssetId written against the set derived from
// buildExtensions BEFORE build() runs.  A simple ".dart" → ".g.ts" map only
// allows writing alongside the source file (lib/src/Foo.g.ts).
//
// The `^lib/{{}}.dart` → `gen/{{}}.g.ts` pattern uses build_runner's
// capture-group syntax:
//   • `^`    – match the full asset path (not just a suffix).
//   • `{{}}` – capture group that expands to everything between lib/ and .dart,
//              e.g. "src/enums/DLStatus" for lib/src/enums/DLStatus.dart.
//
// This tells build_runner the exact output path for each input up-front, so
// writing gen/src/enums/DLStatus.g.ts is pre-approved — no
// UnexpectedOutputException.
//
// We use `buildStep.allowedOutputs.single` to retrieve the pre-computed output
// AssetId rather than constructing it manually.
//
// ── analyzer ^10 API notes ────────────────────────────────────────────────────
//   • library.classes / library.enums  (replaces topLevelElements)
//   • library.firstFragment.source.uri (replaces library.source.uri)
//   • FieldElement.isOriginDeclaration (replaces isSynthetic)

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

import 'src/cross_file_registry.dart';
import 'src/model_analyzer.dart';
import 'src/zod_generator.dart';

// ── Factory functions ────────────────────────────────────────────────────────

Builder dartTsFileBuilder(BuilderOptions options) => _TsFileBuilder(options);
Builder dartTsGeneratorBuilder(BuilderOptions options) =>
    _TsFileBuilder(options);

// ── Builder ──────────────────────────────────────────────────────────────────

class _TsFileBuilder implements Builder {
  final BuilderOptions _options;

  _TsFileBuilder(this._options);

  /// Capture-group mapping (resolved by build_runner before build() is called):
  ///
  ///   lib/src/Vehicle.dart           →  gen/src/Vehicle.g.ts
  ///   lib/src/enums/DLStatus.dart    →  gen/src/enums/DLStatus.g.ts
  @override
  Map<String, List<String>> get buildExtensions => const {
    r'^lib/{{}}.dart': ['gen/{{}}.g.ts'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    // ── Guards ────────────────────────────────────────────────────────────
    if (inputId.path.endsWith('.g.dart')) return;
    if (inputId.path.endsWith('.freezed.dart')) return;
    if (!await buildStep.canRead(inputId)) return;

    // ── Pre-scan (once per build session) ─────────────────────────────────
    final registry = CrossFileRegistry.instance;
    if (!registry.isInitialized) {
      registry.reset();
      await _preScan(buildStep, registry);
      registry.markInitialized();
    }

    // ── Resolve library ───────────────────────────────────────────────────
    LibraryElement library;
    try {
      library = await buildStep.inputLibrary;
    } catch (_) {
      return;
    }

    // Skip part files: a part's firstFragment points to the parent library.
    final fragmentUri = library.firstFragment.source.uri.toString();
    final inputUri = inputId.uri.toString();
    if (!fragmentUri.endsWith(inputId.path) && fragmentUri != inputUri) {
      return;
    }

    // ── Generate ──────────────────────────────────────────────────────────
    final dateTimeAsString =
        _options.config['date_time_as_string'] as bool? ?? true;

    final analyzer = ModelAnalyzer(registry);
    final zodGen = ZodGenerator(registry, dateTimeAsString: dateTimeAsString);

    final allClasses = analyzer.analyzeLibrary(library, inputId.path);
    final relevant = allClasses
        .where((c) => c.isEnum || c.hasJsonSerializable)
        .toList();

    if (relevant.isEmpty) return;

    final tsSource = zodGen.generateFile(relevant, inputId.path);
    if (tsSource.trim().isEmpty) return;

    // allowedOutputs.single is the AssetId build_runner pre-computed from the
    // capture-group pattern — use it instead of constructing the path manually.
    final outputId = buildStep.allowedOutputs.single;
    await buildStep.writeAsString(outputId, tsSource);
  }

  // ── Pre-scan ──────────────────────────────────────────────────────────────
  //
  // Walks every Dart source file and registers:
  //   • Every enum   → name, values, source path
  //   • Every class  → name, superclass, source path, AND fieldDeps
  //
  // fieldDeps is the set of non-primitive, non-enum model type names that the
  // class directly references in its fields.  This is the data that makes
  // cross-file cycle detection possible in CrossFileRegistry.globalCyclicTypes().
  //
  // We extract fieldDeps here (in the builder pre-scan) rather than in the
  // ZodGenerator because:
  //   1. The pre-scan already has fully-resolved LibraryElements for every
  //      file — we just need to walk fields once more.
  //   2. The registry is the only structure shared across all per-file
  //      generateFile() calls, so it is the correct place to store global data.

  Future<void> _preScan(BuildStep buildStep, CrossFileRegistry registry) async {
    final assets = await buildStep.findAssets(Glob('lib/**.dart')).toList();

    await Future.wait(
      assets.map((asset) async {
        if (asset.path.endsWith('.g.dart')) return;
        if (asset.path.endsWith('.freezed.dart')) return;

        LibraryElement lib;
        try {
          lib = await buildStep.resolver.libraryFor(asset);
        } catch (_) {
          return;
        }

        // ── Enums ───────────────────────────────────────────────────────────
        for (final e in lib.enums) {
          final values = e.fields
              .where((f) => f.isEnumConstant)
              .map((f) => f.name)
              .toList();
          registry.register(
            TypeInfo(
              name: e.name!,
              isEnum: true,
              enumValues: values.whereType<String>().toList(),
              sourceAssetPath: asset.path,
            ),
          );
        }

        // ── Classes ─────────────────────────────────────────────────────────
        for (final c in lib.classes) {
          final superType = c.supertype;
          final superName =
              (superType != null && superType.element.name != 'Object')
              ? superType.element.name
              : null;

          // ── Extract field-level type dependencies ──────────────────────────
          // We collect the bare (non-generic) type name of every field that is
          // NOT a primitive and NOT a Dart SDK type.  These become directed
          // edges in the global dependency graph inside CrossFileRegistry.
          //
          // We intentionally do NOT filter by "is it a known model?" here —
          // the registry isn't fully populated yet while pre-scan is running
          // in parallel.  The registry's globalCyclicTypes() filters out
          // non-model types when it builds the graph later.
          final fieldDeps = <String>{};
          for (final field in c.fields) {
            if (field.isStatic) continue;
            if (!field.isOriginDeclaration) continue;

            final type = field.type;
            _collectTypeDeps(type, fieldDeps);
          }

          registry.register(
            TypeInfo(
              name: c.name!,
              isEnum: false,
              sourceAssetPath: asset.path,
              superclassName: superName,
              fieldDeps: fieldDeps,
            ),
          );
        }
      }),
    );
  }

  // ── Type dep extraction ───────────────────────────────────────────────────

  static const _dartPrimitives = {
    'String', 'int', 'double', 'num', 'bool', 'dynamic', 'Object',
    'DateTime', 'Duration', 'void', 'Null', 'Never',
    // Dart SDK collections — the type args are what matter, not these names
    'List', 'Map', 'Set', 'Iterable',
    // Firestore types handled separately by ZodGenerator
    'Timestamp', 'GeoPoint', 'DocumentReference', 'FieldValue', 'Blob',
  };

  /// Recursively extracts model type names from [type] into [deps].
  ///
  /// Handles:
  ///   • Direct types:          EiUser?           → 'EiUser'
  ///   • List item types:       List<EiUser>       → 'EiUser'
  ///   • Map value types:       Map<String, Rider> → 'Rider'
  ///   • Nested generics:       List<List<EiUser>> → 'EiUser'
  void _collectTypeDeps(DartType type, Set<String> deps) {
    if (type is! InterfaceType) return;

    final name = type.element.name;

    if (!_dartPrimitives.contains(name)) {
      deps.add(name!);
    }

    // Recurse into type arguments (List<T>, Map<K,V>, etc.)
    for (final arg in type.typeArguments) {
      _collectTypeDeps(arg, deps);
    }
  }
}
