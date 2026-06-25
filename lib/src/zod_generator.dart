// lib/src/zod_generator.dart

import 'model_analyzer.dart';
import 'cross_file_registry.dart';

class ZodGenerator {
  final CrossFileRegistry _registry;
  final bool dateTimeAsString;

  ZodGenerator(this._registry, {this.dateTimeAsString = false});

  // ─────────────────────────────────────────────────────────────────────────────
  // PUBLIC ENTRY POINT
  // ─────────────────────────────────────────────────────────────────────────────

  String generateFile(List<ClassInfo> classes, String assetPath) {
    if (classes.isEmpty) return '';

    final importMap = <String, Set<String>>{};
    final externalImports = <String>{};
    final bodyBlocks = <String>[];

    // ── Cyclic type resolution ────────────────────────────────────────────────
    //
    // We merge two independent cycle sets:
    //
    //   intraFileCyclicTypes  — types that form a cycle purely within this
    //                           file's class list (e.g. a self-referential
    //                           tree node).  Detected from the local field graph.
    //
    //   globalCyclicTypes     — types that participate in ANY cycle across ALL
    //                           source files, detected by CrossFileRegistry using
    //                           the fieldDeps collected during the pre-scan.
    //                           This is the set that catches EiUser ↔ PendingPayment
    //                           and every similar cross-file cycle.
    //
    // Any type in the union must have its schema wrapped in z.lazy() wherever
    // it is referenced, to avoid the Node.js circular-import
    // "cannot read properties of undefined" crash at module load time.
    final graph = buildDependencyGraph(classes);
    final intraFileCyclicTypes = findCyclicTypes(graph);
    final globalCyclicTypes = _registry.globalCyclicTypes();
    final cyclicTypes = {...intraFileCyclicTypes, ...globalCyclicTypes};

    final classMap = {for (var c in classes) c.name: c};
    final topoOrder = topoSort(graph);

    // ───── ENUMS + INTERFACES ─────
    for (final cls in classes) {
      if (cls.isEnum) {
        bodyBlocks.add(_generateEnum(cls));
      } else {
        bodyBlocks.add(_generateInterface(cls));
      }
    }

    final generated = <String>{};

    // ───── SCHEMAS (topo order) ─────
    for (final name in topoOrder) {
      final cls = classMap[name];
      if (cls == null || cls.isEnum) continue;

      final result = _generateSchema(cls, assetPath, cyclicTypes);
      _mergeImports(importMap, externalImports, result.imports);
      bodyBlocks.add(result.code);
      generated.add(name);
    }

    // fallback for anything not reached by topo sort (e.g. isolated nodes)
    for (final cls in classes) {
      if (generated.contains(cls.name) || cls.isEnum) continue;

      final result = _generateSchema(cls, assetPath, cyclicTypes);
      _mergeImports(importMap, externalImports, result.imports);
      bodyBlocks.add(result.code);
    }

    // ───── BUILD FILE ─────
    final lines = <String>["import { z } from 'zod';"];

    if (externalImports.isNotEmpty) {
      lines.addAll(externalImports.toList()..sort());
    }

    if (importMap.isNotEmpty) {
      for (final entry in importMap.entries) {
        final imports = entry.value.toList()..sort();
        lines.add("import { ${imports.join(', ')} } from '${entry.key}';");
      }
    }

    lines.add('');
    lines.add(bodyBlocks.join('\n\n'));

    return lines.join('\n');
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ENUM
  // ─────────────────────────────────────────────────────────────────────────────

  String _generateEnum(ClassInfo cls) {
    final values = cls.enumValues.map((e) => "'$e'").join(', ');

    return [
      '// ── ${cls.name} (Enum) ──',
      'export const ${cls.name}Schema = z.enum([$values]);',
      'export type ${cls.name} = z.infer<typeof ${cls.name}Schema>;',
    ].join('\n');
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // INTERFACE
  // ─────────────────────────────────────────────────────────────────────────────

  String _generateInterface(ClassInfo cls) {
    final lines = <String>[];

    lines.add('// ── ${cls.name} (Type) ──');
    lines.add('export interface ${cls.name} {');

    for (final field in cls.allFields) {
      if (field.isIgnored) continue;

      final tsType = _tsTypeForField(field);
      final optional = field.isNullable ? '?' : '';

      lines.add('  ${_tsKey(field.effectiveJsonName)}$optional: $tsType;');
    }

    lines.add('}');

    return lines.join('\n');
  }

  String _tsTypeForField(FieldInfo field) {
    String base;

    if (field.isList) {
      base = '${_tsType(field.listItemType ?? 'any')}[]';
    } else if (field.isMap) {
      base = 'Record<string, ${_tsType(field.mapValueType ?? 'any')}>';
    } else {
      base = _tsType(field.dartType);
    }

    if (field.isNullable) return '$base | null';
    return base;
  }

  String _tsType(String dartType) {
    if (_externalTypes.containsKey(dartType)) {
      return _externalTypes[dartType]!.tsType;
    }

    const map = {
      'String': 'string',
      'int': 'number',
      'double': 'number',
      'num': 'number',
      'bool': 'boolean',
      'dynamic': 'any',
      'Object': 'any',
      'DateTime': 'Date',
    };

    return map[dartType] ?? dartType;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SCHEMA
  // ─────────────────────────────────────────────────────────────────────────────

  _GeneratorResult _generateSchema(
    ClassInfo cls,
    String fromAssetPath,
    Set<String> cyclicTypes,
  ) {
    final imports = <_Import>{};
    final fieldLines = <String>[];

    for (final field in cls.allFields) {
      if (field.isIgnored) continue;

      final result = _generateField(field, fromAssetPath, cyclicTypes);
      imports.addAll(result.imports);

      fieldLines.add(
        '  ${_tsKey(field.effectiveJsonName)}: ${result.zodExpr},',
      );
    }

    final schemaName = '${cls.name}Schema';

    // A schema must be wrapped in z.lazy() when the type itself is cyclic
    // (self-referential or part of any intra- or cross-file cycle).
    final isCyclic = cyclicTypes.contains(cls.name);

    final code = isCyclic
        ? [
            '// ── ${cls.name} (Schema) ──',
            'export const $schemaName: z.ZodType<${cls.name}> = z.lazy(() =>',
            '  z.object({',
            ...fieldLines,
            '  })',
            ') as unknown as z.ZodType<${cls.name}>;',
          ]
        : [
            '// ── ${cls.name} (Schema) ──',
            'export const $schemaName: z.ZodType<${cls.name}> = z.object({',
            ...fieldLines,
            '});',
          ];

    return _GeneratorResult(code: code.join('\n'), imports: imports);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FIELD
  // ─────────────────────────────────────────────────────────────────────────────

  _FieldResult _generateField(
    FieldInfo field,
    String fromAssetPath,
    Set<String> cyclicTypes,
  ) {
    final imports = <_Import>{};
    String zodExpr;

    // DateTime converter
    if (field.hasDateTimeConverter || field.hasDateTimeNullableConverter) {
      imports.add(
        _Import.external(
          "import { Timestamp } from 'firebase-admin/firestore';",
        ),
      );

      zodExpr =
          '''z.union([
  z.date(),
  z.number(),
  z.string(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  if (typeof val === 'string') return new Date(val);
  return val.toDate();
})'''
              .trim();
    }
    // DateTime list converter
    else if (field.hasDateTimeListConverter) {
      imports.add(
        _Import.external(
          "import { Timestamp } from 'firebase-admin/firestore';",
        ),
      );

      zodExpr =
          '''z.array(
  z.union([
    z.date(),
    z.number(),
    z.string(),
    z.instanceof(Timestamp)
  ]).transform((val) => {
    if (val instanceof Date) return val;
    if (typeof val === 'number') return new Date(val);
    if (typeof val === 'string') return new Date(val);
    return val.toDate();
  })
)'''
              .trim();
    } else if (field.hasPhoneConverter) {
      if (field.isNullable) {
        zodExpr = '''z.union([z.string(), z.number()]).nullish().transform((val) => {
  if (!val) return null;
  const phone = String(val).replace(/\\D/g, "");
  if (phone.length === 10) return `+91\${phone}`;
  if (phone.length === 12 && phone.startsWith("91")) return `+\${phone}`;
  if (phone.length === 11 && phone.startsWith("0")) return `+91\${phone.slice(1)}`;
  return null;
})'''.trim();
      } else {
        zodExpr = '''z.union([z.string(), z.number()]).transform((val) => {
  if (!val) return "";
  const phone = String(val).replace(/\\D/g, "");
  if (phone.length === 10) return `+91\${phone}`;
  if (phone.length === 12 && phone.startsWith("91")) return `+\${phone}`;
  if (phone.length === 11 && phone.startsWith("0")) return `+91\${phone.slice(1)}`;
  return "";
})'''.trim();
      }
    } else if (field.hasDisplayNameConverter) {
      if (field.isNullable) {
        zodExpr = '''z.string().nullish().transform((val) => {
  if (!val || !val.trim()) return null;
  return val.trim().toLowerCase().split(/\\s+/).map((word) => word.charAt(0).toUpperCase() + word.slice(1)).join(" ");
})'''.trim();
      } else {
        zodExpr = '''z.string().transform((val) => {
  if (!val || !val.trim()) return "";
  return val.trim().toLowerCase().split(/\\s+/).map((word) => word.charAt(0).toUpperCase() + word.slice(1)).join(" ");
})'''.trim();
      }
    } else if (field.hasDoubleConverter) {
      zodExpr = 'z.coerce.number()';
    } else if (field.hasIntConverter) {
      zodExpr = 'z.coerce.number().int()';
    } else if (field.hasStringConverter) {
      zodExpr = 'z.coerce.string()';
    } else if (field.hasBoolConverter) {
      zodExpr = 'z.coerce.boolean()';
    } else if (field.isList) {
      final item = _zodForType(
        field.listItemType ?? 'dynamic',
        fromAssetPath,
        imports,
        cyclicTypes,
      );
      zodExpr = 'z.array($item)';
    } else if (field.isMap) {
      final value = _zodForType(
        field.mapValueType ?? 'dynamic',
        fromAssetPath,
        imports,
        cyclicTypes,
      );
      zodExpr = 'z.record(z.string(), $value)';
    } else {
      zodExpr = _zodForType(
        field.dartType,
        fromAssetPath,
        imports,
        cyclicTypes,
      );
    }

    // ── Nullability + default ─────────────────────────────────────────────────
    final def = _dartDefaultToTs(field.defaultValue);

    if (field.isNullable) zodExpr = '$zodExpr.nullish()';

    if (def != null) {
      zodExpr = '$zodExpr.catch($def)';
    }

    return _FieldResult(zodExpr, imports);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TYPE RESOLUTION
  // ─────────────────────────────────────────────────────────────────────────────

  String _zodForType(
    String dartType,
    String fromAssetPath,
    Set<_Import> imports,
    Set<String> cyclicTypes,
  ) {
    if (_externalTypes.containsKey(dartType)) {
      final ext = _externalTypes[dartType]!;
      imports.add(_Import.external(ext.import));
      return ext.zodExpr;
    }

    final primitive = _primitives[dartType];
    if (primitive != null) return primitive;

    if (_registry.isEnum(dartType) || _registry.resolve(dartType) != null) {
      final rel = _registry.relativeImportFor(
        typeName: dartType,
        fromSourceAssetPath: fromAssetPath,
      );

      if (rel != null) {
        imports.add(_Import.normal(rel, dartType));
      }

      // ── z.lazy() decision ──────────────────────────────────────────────────
      
      final needsLazy =
          !_registry.isEnum(dartType) && cyclicTypes.contains(dartType);

      if (needsLazy) {
        return 'z.lazy(() => ${dartType}Schema)';
      }

      return '${dartType}Schema';
    }

    return 'z.unknown()';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // IMPORT MERGE
  // ─────────────────────────────────────────────────────────────────────────────

  void _mergeImports(
    Map<String, Set<String>> map,
    Set<String> external,
    Set<_Import> imports,
  ) {
    for (final imp in imports) {
      if (imp.isExternal) {
        external.add(imp.raw!);
        continue;
      }

      map.putIfAbsent(imp.path!, () => {});
      map[imp.path!]!.add(imp.type!);
      map[imp.path!]!.add('${imp.type!}Schema');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DEPENDENCY GRAPH (intra-file)
  // ─────────────────────────────────────────────────────────────────────────────

  Map<String, Set<String>> buildDependencyGraph(List<ClassInfo> classes) {
    final graph = <String, Set<String>>{};

    for (final cls in classes) {
      final deps = <String>{};

      for (final f in cls.allFields) {
        if (_isValidType(f.dartType)) deps.add(f.dartType);
        if (f.listItemType != null && _isValidType(f.listItemType!)) {
          deps.add(f.listItemType!);
        }
        if (f.mapValueType != null && _isValidType(f.mapValueType!)) {
          deps.add(f.mapValueType!);
        }
      }

      graph[cls.name] = deps;
    }

    return graph;
  }

  bool _isValidType(String type) {
    return !_primitives.containsKey(type) &&
        !_externalTypes.containsKey(type) &&
        _registry.resolve(type) != null;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // GRAPH ALGORITHMS
  // ─────────────────────────────────────────────────────────────────────────────

  String _tsKey(String name) {
    const identPattern = r'^[a-zA-Z_$][a-zA-Z0-9_$]*$';
    return RegExp(identPattern).hasMatch(name) ? name : "'$name'";
  }

  /// Kahn's algorithm — returns nodes in reverse dependency order.
  List<String> topoSort(Map<String, Set<String>> graph) {
    final inDegree = <String, int>{};

    for (final node in graph.keys) {
      inDegree[node] = 0;
    }

    for (final deps in graph.values) {
      for (final d in deps) {
        if (inDegree.containsKey(d)) {
          inDegree[d] = (inDegree[d] ?? 0) + 1;
        }
      }
    }

    final queue = <String>[];
    for (final e in inDegree.entries) {
      if (e.value == 0) queue.add(e.key);
    }

    final result = <String>[];

    while (queue.isNotEmpty) {
      final node = queue.removeLast();
      result.add(node);

      for (final dep in graph[node] ?? {}) {
        if (!inDegree.containsKey(dep)) continue;

        final newVal = (inDegree[dep] ?? 0) - 1;
        inDegree[dep] = newVal;

        if (newVal == 0) queue.add(dep);
      }
    }

    return result.reversed.toList();
  }

  /// DFS cycle detection — returns every node in any cycle.
  /// Marks the full cycle path, not just the back-edge target.
  Set<String> findCyclicTypes(Map<String, Set<String>> graph) {
    final visited = <String>{};
    final stack = <String>[];
    final stackSet = <String>{};
    final cyclic = <String>{};

    void dfs(String node) {
      if (stackSet.contains(node)) {
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

  // ─────────────────────────────────────────────────────────────────────────────
  // CONSTANTS
  // ─────────────────────────────────────────────────────────────────────────────

  static const _primitives = {
    'String': 'z.string()',
    'int': 'z.number().int()',
    'double': 'z.number()',
    'num': 'z.number()',
    'bool': 'z.boolean()',
    'dynamic': 'z.unknown()',
    'Object': 'z.unknown()',
    'DateTime': 'z.date()',
  };

  static const _externalTypes = {
    'GeoPoint': _ExternalType(
      tsType: 'GeoPoint',
      zodExpr: 'z.instanceof(GeoPoint)',
      import: "import { GeoPoint } from 'firebase-admin/firestore';",
    ),
    'Timestamp': _ExternalType(
      tsType: 'Timestamp',
      zodExpr: 'z.instanceof(Timestamp)',
      import: "import { Timestamp } from 'firebase-admin/firestore';",
    ),
  };

  String? _dartDefaultToTs(dynamic value) {
    if (value is bool) return value ? 'true' : 'false';
    if (value is num) return '$value';
    if (value is String) return '"$value"';
    if (value is List) return '[]';
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _Import {
  final String? path;
  final String? type;
  final String? raw;
  final bool isExternal;

  _Import.normal(this.path, this.type) : raw = null, isExternal = false;

  _Import.external(this.raw) : path = null, type = null, isExternal = true;

  @override
  bool operator ==(Object other) =>
      other is _Import &&
      other.path == path &&
      other.type == type &&
      other.raw == raw;

  @override
  int get hashCode => Object.hash(path, type, raw);
}

class _FieldResult {
  final String zodExpr;
  final Set<_Import> imports;

  _FieldResult(this.zodExpr, this.imports);
}

class _GeneratorResult {
  final String code;
  final Set<_Import> imports;

  _GeneratorResult({required this.code, required this.imports});
}

class _ExternalType {
  final String tsType;
  final String zodExpr;
  final String import;

  const _ExternalType({
    required this.tsType,
    required this.zodExpr,
    required this.import,
  });
}
