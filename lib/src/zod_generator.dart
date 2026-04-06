// lib/src/zod_generator.dart

import 'model_analyzer.dart';
import 'cross_file_registry.dart';

class ZodGenerator {
  final CrossFileRegistry _registry;
  final bool dateTimeAsString;

  ZodGenerator(this._registry, {this.dateTimeAsString = false});

  String generateFile(List<ClassInfo> classes, String assetPath) {
    if (classes.isEmpty) return '';

    final importMap = <String, Set<String>>{};
    final externalImports = <String>{};
    final bodyBlocks = <String>[];

    final graph = buildDependencyGraph(classes);
    final topoOrder = topoSort(graph);
    final cyclicTypes = findCyclicTypes(graph);

    final classMap = {for (var c in classes) c.name: c};

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

    // fallback
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

  // ───────── ENUM ─────────

  String _generateEnum(ClassInfo cls) {
    final values = cls.enumValues.map((e) => "'$e'").join(', ');

    return [
      '// ── ${cls.name} (Enum) ──',
      'export const ${cls.name}Schema = z.enum([$values]);',
      'export type ${cls.name} = z.infer<typeof ${cls.name}Schema>;',
    ].join('\n');
  }

  // ───────── INTERFACE ─────────

  String _generateInterface(ClassInfo cls) {
    final lines = <String>[];

    lines.add('// ── ${cls.name} (Type) ──');
    lines.add('export interface ${cls.name} {');

    for (final field in cls.allFields) {
      if (field.isIgnored) continue;

      final tsType = _tsTypeForField(field);
      final optional = field.isNullable ? '?' : '';

      lines.add('  ${field.effectiveJsonName}$optional: $tsType;');
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

  // ───────── SCHEMA ─────────

  _GeneratorResult _generateSchema(
    ClassInfo cls,
    String fromAssetPath,
    Set<String> cyclicTypes,
  ) {
    final imports = <_Import>{};
    final fieldLines = <String>[];

    for (final field in cls.allFields) {
      if (field.isIgnored) continue;

      final result = _generateField(field, fromAssetPath);
      imports.addAll(result.imports);

      fieldLines.add('  ${field.effectiveJsonName}: ${result.zodExpr},');
    }

    final schemaName = '${cls.name}Schema';
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

  // ───────── FIELD ─────────

  _FieldResult _generateField(FieldInfo field, String fromAssetPath) {
    final imports = <_Import>{};
    String zodExpr;

    // 🔥 DateTime converter
    if (field.hasDateTimeConverter || field.hasDateTimeNullableConverter) {
      imports.add(
        _Import.external(
          "import { Timestamp } from 'firebase-admin/firestore';",
        ),
      );

      zodExpr =
          '''
z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
})
'''
              .trim();
    }
    // 🔥 DateTime list converter
    else if (field.hasDateTimeListConverter) {
      imports.add(
        _Import.external(
          "import { Timestamp } from 'firebase-admin/firestore';",
        ),
      );

      zodExpr =
          '''
z.array(
  z.union([
    z.date(),
    z.number(),
    z.instanceof(Timestamp)
  ]).transform((val) => {
    if (val instanceof Date) return val;
    if (typeof val === 'number') return new Date(val);
    return val.toDate();
  })
)
'''
              .trim();
    } else if (field.isList) {
      final item = _zodForType(
        field.listItemType ?? 'dynamic',
        fromAssetPath,
        imports,
      );
      zodExpr = 'z.array($item)';
    } else if (field.isMap) {
      final value = _zodForType(
        field.mapValueType ?? 'dynamic',
        fromAssetPath,
        imports,
      );
      zodExpr = 'z.record(z.string(), $value)';
    } else {
      zodExpr = _zodForType(field.dartType, fromAssetPath, imports);
    }

    if (field.isNullable) zodExpr = '$zodExpr.nullish()';

    final def = _dartDefaultToTs(field.defaultValue);
    if (def != null) zodExpr = '$zodExpr.default($def)';

    return _FieldResult(zodExpr, imports);
  }

  // ───────── TYPE RESOLUTION ─────────

  String _zodForType(
    String dartType,
    String fromAssetPath,
    Set<_Import> imports,
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

      return '${dartType}Schema';
    }

    return 'z.unknown()';
  }

  // ───────── IMPORT MERGE ─────────

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

  // ───────── GRAPH ─────────

  Map<String, Set<String>> buildDependencyGraph(List<ClassInfo> classes) {
    final graph = <String, Set<String>>{};

    for (final cls in classes) {
      final deps = <String>{};

      for (final f in cls.allFields) {
        if (_isValidType(f.dartType)) deps.add(f.dartType);
        if (f.listItemType != null && _isValidType(f.listItemType!)) {
          deps.add(f.listItemType!);
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

    return result;
  }

  Set<String> findCyclicTypes(Map<String, Set<String>> graph) {
    final visited = <String>{};
    final stack = <String>{};
    final cyclic = <String>{};

    void dfs(String node) {
      if (stack.contains(node)) {
        cyclic.add(node);
        return;
      }
      if (visited.contains(node)) return;

      visited.add(node);
      stack.add(node);

      for (final n in graph[node] ?? {}) {
        dfs(n);
        if (cyclic.contains(n)) cyclic.add(node);
      }

      stack.remove(node);
    }

    for (final node in graph.keys) {
      dfs(node);
    }

    return cyclic;
  }

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

// ───────── HELPERS ─────────

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
