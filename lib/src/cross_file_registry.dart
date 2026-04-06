// lib/src/cross_file_registry.dart
//
// Global registry that maps every Dart type name discovered across all
// scanned source files to its metadata.
//
// ── Import path calculation ───────────────────────────────────────────────────
// Generated files live at  lib/gen/**/*.g.ts  (not alongside the source).
// Cross-file imports inside .g.ts files must therefore be relative to
// lib/gen/, not lib/.
//
//   Source:  lib/src/Vehicle.dart        → output: lib/gen/src/Vehicle.g.ts
//   Source:  lib/src/enums/DLStatus.dart → output: lib/gen/src/enums/DLStatus.g.ts
//
//   Import from Vehicle.g.ts → DLStatus.g.ts:
//     ../enums/DLStatus          (relative from lib/gen/src/ to lib/gen/src/enums/)

import 'package:path/path.dart' as p;

// ── Data model ──────────────────────────────────────────────────────────────

class TypeInfo {
  final String name;
  final bool isEnum;
  final List<String> enumValues;

  /// Package-relative asset path of the *source* dart file,
  /// e.g. "lib/src/enums/DLStatus.dart".
  final String sourceAssetPath;

  final String? superclassName;

  const TypeInfo({
    required this.name,
    required this.isEnum,
    this.enumValues = const [],
    required this.sourceAssetPath,
    this.superclassName,
  });
}

// ── Registry ────────────────────────────────────────────────────────────────

class CrossFileRegistry {
  CrossFileRegistry._();
  static final CrossFileRegistry instance = CrossFileRegistry._();

  final Map<String, TypeInfo> _types = {};
  bool _initialized = false;

  bool get isInitialized => _initialized;
  void markInitialized() => _initialized = true;

  void reset() {
    _types.clear();
    _initialized = false;
  }

  void register(TypeInfo info) => _types[info.name] = info;

  TypeInfo? resolve(String typeName) => _types[typeName];
  bool isEnum(String typeName) => _types[typeName]?.isEnum ?? false;
  List<String> enumValues(String typeName) =>
      _types[typeName]?.enumValues ?? const [];
  String? sourceOf(String typeName) => _types[typeName]?.sourceAssetPath;
  String? superclassOf(String typeName) => _types[typeName]?.superclassName;
  Iterable<String> get allTypeNames => _types.keys;

  // ── Import resolution ─────────────────────────────────────────────────────

  /// Compute the relative TypeScript import path from the *generated* file
  /// that is being written ([fromSourceAssetPath]) to the *generated* file
  /// that defines [typeName].
  ///
  /// Both arguments are **source** asset paths (e.g. "lib/src/Vehicle.dart").
  /// We convert them to their output paths under lib/gen/ before computing
  /// the relative path.
  ///
  /// Returns null if [typeName] is unknown or defined in the same source file.
  String? relativeImportFor({
    required String typeName,
    required String fromSourceAssetPath,
  }) {
    final toSourcePath = sourceOf(typeName);
    if (toSourcePath == null || toSourcePath == fromSourceAssetPath) {
      return null;
    }

    // Convert source paths → lib/gen/ output paths.
    final fromGenTs = _sourceToGenTsPath(fromSourceAssetPath);
    final toGenTs = _sourceToGenTsPath(toSourcePath);

    final fromDir = p.posix.dirname(fromGenTs);
    var rel = p.posix.relative(toGenTs, from: fromDir);

    if (!rel.startsWith('.')) rel = './$rel';

    // Strip .ts extension (TypeScript import convention).
    if (rel.endsWith('.ts')) rel = rel.substring(0, rel.length - 3);

    return rel;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Maps a source asset path to its generated output path under lib/gen/.
  ///
  ///   lib/src/Vehicle.dart        →  lib/gen/src/Vehicle.g.ts
  ///   lib/src/enums/DLStatus.dart →  lib/gen/src/enums/DLStatus.g.ts
  String _sourceToGenTsPath(String sourcePath) {
    // Strip leading lib/
    final withoutLib = sourcePath.startsWith('lib/')
        ? sourcePath.substring('lib/'.length)
        : sourcePath;

    // Replace .dart with .g.ts
    final withoutDart = withoutLib.endsWith('.dart')
        ? withoutLib.substring(0, withoutLib.length - '.dart'.length)
        : withoutLib;

    return 'lib/gen/$withoutDart.g.ts';
  }
}
