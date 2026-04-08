// lib/src/cross_file_registry.dart
//
// Global registry that maps every Dart type name discovered across all
// scanned source files to its metadata.
//
// ── Import path calculation ───────────────────────────────────────────────────
// Generated files live at  gen/**/*.g.ts  (not alongside the source).
// Cross-file imports inside .g.ts files must therefore be relative to
// gen/, not lib/.
//
//   Source:  lib/src/Vehicle.dart        → output: gen/src/Vehicle.g.ts
//   Source:  lib/src/enums/DLStatus.dart → output: gen/src/enums/DLStatus.g.ts
//
//   Import from Vehicle.g.ts → DLStatus.g.ts:
//     ../enums/DLStatus          (relative from gen/src/ to gen/src/enums/)
//
// ── Cross-file cycle detection ────────────────────────────────────────────────
// During the pre-scan phase (builder.dart) every class registers not only its
// name and superclass but also the set of model types it references in its
// fields (fieldDeps).  This gives the registry a complete picture of the
// inter-type dependency graph across ALL source files, enabling it to compute
// the globally cyclic type set once — before any file is generated.
//
// A type is "globally cyclic" if it participates in any directed cycle in that
// cross-file graph (e.g. EiUser → PendingPayment → EiUser).  Any schema that
// references a globally cyclic type must use z.lazy() to defer evaluation and
// avoid the Node.js circular-import "undefined" crash.

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

  /// All non-primitive, non-enum model type names that this class directly
  /// references in its fields (direct field type, list item type, map value
  /// type).  Populated during the pre-scan phase in builder.dart.
  ///
  /// Example: EiUser has fields `addedBy: EiUser?` and
  /// `pendingPayments: List<PendingPayment>`, so fieldDeps = {'EiUser',
  /// 'PendingPayment'}.
  final Set<String> fieldDeps;

  const TypeInfo({
    required this.name,
    required this.isEnum,
    this.enumValues = const [],
    required this.sourceAssetPath,
    this.superclassName,
    this.fieldDeps = const {},
  });
}

// ── Registry ────────────────────────────────────────────────────────────────

class CrossFileRegistry {
  CrossFileRegistry._();
  static final CrossFileRegistry instance = CrossFileRegistry._();

  final Map<String, TypeInfo> _types = {};
  bool _initialized = false;

  // Cached result of globalCyclicTypes() — computed once after pre-scan.
  Set<String>? _cachedGlobalCyclicTypes;

  bool get isInitialized => _initialized;

  void markInitialized() {
    _initialized = true;
    // Invalidate cache whenever the registry is fully re-initialized so that a
    // fresh build always recomputes from the latest registered data.
    _cachedGlobalCyclicTypes = null;
  }

  void reset() {
    _types.clear();
    _initialized = false;
    _cachedGlobalCyclicTypes = null;
  }

  void register(TypeInfo info) {
    _types[info.name] = info;
    // Invalidate cache on any new registration.
    _cachedGlobalCyclicTypes = null;
  }

  TypeInfo? resolve(String typeName) => _types[typeName];
  bool isEnum(String typeName) => _types[typeName]?.isEnum ?? false;
  List<String> enumValues(String typeName) =>
      _types[typeName]?.enumValues ?? const [];
  String? sourceOf(String typeName) => _types[typeName]?.sourceAssetPath;
  String? superclassOf(String typeName) => _types[typeName]?.superclassName;
  Iterable<String> get allTypeNames => _types.keys;

  // ── Global cyclic type detection ──────────────────────────────────────────

  /// Returns the set of ALL type names that participate in any directed cycle
  /// in the cross-file dependency graph.
  ///
  /// The graph is built from two kinds of edges per type T:
  ///   • T → superclass(T)   (inheritance edge)
  ///   • T → F               for every F in T.fieldDeps (field reference edge)
  ///
  /// Only non-enum model types are considered — enums are pure value constants
  /// and cannot form cycles.
  ///
  /// Result is cached after the first call so repeated calls from
  /// _zodForType() are O(1).
  Set<String> globalCyclicTypes() {
    if (_cachedGlobalCyclicTypes != null) return _cachedGlobalCyclicTypes!;

    // ── Build the full cross-file dependency graph ────────────────────────
    final graph = <String, Set<String>>{};

    for (final entry in _types.entries) {
      final info = entry.value;
      if (info.isEnum) continue; // enums never form schema cycles

      final deps = <String>{};

      // Superclass edge
      final sc = info.superclassName;
      if (sc != null && _isModelType(sc)) deps.add(sc);

      // Field dependency edges (populated by builder.dart pre-scan)
      for (final dep in info.fieldDeps) {
        if (_isModelType(dep)) deps.add(dep);
      }

      graph[info.name] = deps;
    }

    // ── DFS cycle detection ───────────────────────────────────────────────
    _cachedGlobalCyclicTypes = _findCyclicTypes(graph);
    return _cachedGlobalCyclicTypes!;
  }

  /// Returns true when [typeName] is a registered non-primitive, non-enum
  /// model type.
  bool _isModelType(String typeName) {
    final info = _types[typeName];
    if (info == null) return false;
    return !info.isEnum;
  }

  /// DFS-based cycle detection on [graph].
  ///
  /// When a back-edge is found every node on the stack from the cycle start
  /// to the current node is added to the cyclic set, not just the back-edge
  /// target.  This ensures that in A → B → C → A all three are marked cyclic
  /// so any reference to B or C is also wrapped in z.lazy().
  static Set<String> _findCyclicTypes(Map<String, Set<String>> graph) {
    final visited = <String>{};
    final stack = <String>[];
    final stackSet = <String>{};
    final cyclic = <String>{};

    void dfs(String node) {
      if (stackSet.contains(node)) {
        // Back-edge — mark the entire cycle path
        final cycleStart = stack.indexOf(node);
        for (var i = cycleStart; i < stack.length; i++) {
          cyclic.add(stack[i]);
        }
        cyclic.add(node);
        return;
      }
      if (visited.contains(node)) return;

      visited.add(node);
      stack.add(node);
      stackSet.add(node);

      for (final neighbour in graph[node] ?? const <String>{}) {
        dfs(neighbour);
      }

      stack.removeLast();
      stackSet.remove(node);
    }

    for (final node in graph.keys) {
      if (!visited.contains(node)) dfs(node);
    }

    return cyclic;
  }

  // ── Import resolution ─────────────────────────────────────────────────────

  /// Compute the relative TypeScript import path from the *generated* file
  /// that is being written ([fromSourceAssetPath]) to the *generated* file
  /// that defines [typeName].
  ///
  /// Both arguments are **source** asset paths (e.g. "lib/src/Vehicle.dart").
  /// We convert them to their output paths under gen/ before computing
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

    // Convert source paths → gen/ output paths.
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

  /// Maps a source asset path to its generated output path under gen/.
  ///
  ///   lib/src/Vehicle.dart        →  gen/src/Vehicle.g.ts
  ///   lib/src/enums/DLStatus.dart →  gen/src/enums/DLStatus.g.ts
  String _sourceToGenTsPath(String sourcePath) {
    // Strip leading lib/
    final withoutLib = sourcePath.startsWith('lib/')
        ? sourcePath.substring('lib/'.length)
        : sourcePath;

    // Replace .dart with .g.ts
    final withoutDart = withoutLib.endsWith('.dart')
        ? withoutLib.substring(0, withoutLib.length - '.dart'.length)
        : withoutLib;

    return 'gen/$withoutDart.g.ts';
  }
}
