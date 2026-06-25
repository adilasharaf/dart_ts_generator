// lib/src/model_analyzer.dart
//
// Walks a resolved LibraryElement and extracts every class / enum that is
// relevant for TypeScript / Zod generation.
//
// ── analyzer ^10.0.1 API notes ──────────────────────────────────────────────
//  • LibraryElement no longer has .topLevelElements, .definingCompilationUnit
//    or .source.  Use the typed lists directly:
//      library.classes  → List<ClassElement>
//      library.enums    → List<EnumElement>
//  • Element.isSynthetic is deprecated → use:
//      FieldElement.isOriginDeclaration   (true for real declared fields)
//      FieldElement.isEnumConstant        (already correct for enums)
//  • ClassElement.supertype returns InterfaceType? directly.
//  • ConstructorElement.enclosingElement returns the ClassElement (no .name
//    suffix needed; just cast or use the typed property).
//  • EnumElement.fields still exists and isEnumConstant works.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

import 'cross_file_registry.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Converts a camelCase identifier to snake_case.
///
/// Examples:
///   correctOption   → correct_option
///   questionNumber  → question_number
///   isAnswered      → is_answered
///   answeredOption  → answered_option
///   myURLParser     → my_url_parser
String _camelToSnake(String s) => s.replaceAllMapped(
  RegExp(r'(?<=[a-z])[A-Z]'),
  (m) => '_${m.group(0)!.toLowerCase()}',
);

// ── Data models ──────────────────────────────────────────────────────────────

/// Metadata for a single Dart field.
class FieldInfo {
  final String name;

  /// Base type name without generics or nullability, e.g. "DLStatus", "String".
  final String dartType;

  final bool isNullable;
  final bool isList;
  final bool isMap;
  final String? listItemType;
  final String? mapValueType;
  final bool isEnum;

  /// Value from `@JsonKey(defaultValue: ...)`.
  final dynamic defaultValue;

  final bool hasDateTimeConverter;
  final bool hasDateTimeListConverter;

  final bool hasDateTimeNullableConverter;

  final bool hasPhoneConverter;
  final bool hasDisplayNameConverter;
  final bool hasDoubleConverter;
  final bool hasIntConverter;
  final bool hasStringConverter;
  final bool hasBoolConverter;

  /// From `@JsonKey(name: '...')`.
  final String? jsonKeyName;

  final bool isIgnored;

  /// When true and [jsonKeyName] is null, [effectiveJsonName] will convert
  /// the Dart camelCase field name to snake_case.
  ///
  /// Set for classes detected via the manual fromJson/toMap pattern, where
  /// the JSON keys in the hand-written serialization are conventionally
  /// snake_case (e.g. `correct_answer` for Dart field `correctOption`).
  ///
  /// An explicit `@JsonKey(name: '...')` always takes precedence over this.
  final bool useSnakeCaseFallback;

  const FieldInfo({
    required this.name,
    required this.dartType,
    required this.isNullable,
    this.isList = false,
    this.isMap = false,
    this.listItemType,
    this.mapValueType,
    this.isEnum = false,
    this.defaultValue,
    this.hasDateTimeConverter = false,
    this.hasDateTimeNullableConverter = false,
    this.hasDateTimeListConverter = false,
    this.hasPhoneConverter = false,
    this.hasDisplayNameConverter = false,
    this.hasDoubleConverter = false,
    this.hasIntConverter = false,
    this.hasStringConverter = false,
    this.hasBoolConverter = false,
    this.jsonKeyName,
    this.isIgnored = false,
    this.useSnakeCaseFallback = false,
  });

  /// The JSON key to use in the generated TypeScript / Zod schema.
  ///
  /// Priority:
  ///   1. Explicit `@JsonKey(name: '...')` → use as-is.
  ///   2. [useSnakeCaseFallback] == true   → convert camelCase to snake_case.
  ///   3. Fallback                         → raw Dart field name.
  String get effectiveJsonName {
    if (jsonKeyName != null) return jsonKeyName!;
    if (useSnakeCaseFallback) return _camelToSnake(name);
    return name;
  }
}

/// Metadata for a Dart class or enum.
class ClassInfo {
  final String name;
  final String assetPath;
  final bool isEnum;
  final List<String> enumValues;
  final List<FieldInfo> ownFields;
  final List<FieldInfo> inheritedFields;
  final String? superclassName;
  final bool hasJsonSerializable;

  /// True when the class was detected via the manual fromJson/toMap pattern
  /// rather than @JsonSerializable. Informational only — does not affect
  /// code generation directly, but drives [useSnakeCaseFallback] on fields.
  final bool hasManualSerialization;

  const ClassInfo({
    required this.name,
    required this.assetPath,
    this.isEnum = false,
    this.enumValues = const [],
    this.ownFields = const [],
    this.inheritedFields = const [],
    this.superclassName,
    this.hasJsonSerializable = false,
    this.hasManualSerialization = false,
  });

  List<FieldInfo> get allFields => [...inheritedFields, ...ownFields];
}

// ── Analyzer ────────────────────────────────────────────────────────────────

class ModelAnalyzer {
  final CrossFileRegistry _registry;

  ModelAnalyzer(this._registry);

  // ── Public entry point ────────────────────────────────────────────────────

  /// Analyse [library] and return all [ClassInfo] objects.
  ///
  /// Uses `library.classes` and `library.enums` — the correct API for
  /// analyzer >=7.x (replaces the removed `topLevelElements`).
  List<ClassInfo> analyzeLibrary(LibraryElement library, String assetPath) {
    final results = <ClassInfo>[];

    // ── Enums ────────────────────────────────────────────────────────────────
    for (final element in library.enums) {
      results.add(_analyzeEnum(element, assetPath));
    }

    // ── Classes ───────────────────────────────────────────────────────────────
    for (final element in library.classes) {
      if (element.name!.startsWith('_')) continue;
      final info = _analyzeClass(element, assetPath);
      if (info != null) results.add(info);
    }

    return results;
  }

  // ── Enum ──────────────────────────────────────────────────────────────────

  ClassInfo _analyzeEnum(EnumElement element, String assetPath) {
    final values = element.fields
        .where((f) => f.isEnumConstant)
        .map((f) => f.name)
        .toList();

    return ClassInfo(
      name: element.name!,
      assetPath: assetPath,
      isEnum: true,
      enumValues: values.whereType<String>().toList(),
    );
  }

  // ── Class ─────────────────────────────────────────────────────────────────

  ClassInfo? _analyzeClass(ClassElement element, String assetPath) {
    final hasJsonSerializable = _hasAnnotationNamed(
      element,
      'JsonSerializable',
    );

    // ── Explicit opt-in annotation ────────────────────────────────────────
    // @TsGenerate forces generation even if the class has neither
    // @JsonSerializable nor a fromJson/toMap pair.
    final hasTsGenerate = _hasAnnotationNamed(element, 'TsGenerate');

    // ── Manual serialization pattern detection ────────────────────────────
    // A class qualifies when it has:
    //   • a static `fromJson` or `fromMap` method  (deserialization), AND
    //   • an instance `toMap` or `toJson` method   (serialization).
    //
    // This matches the common hand-written pattern:
    //
    //   static Signal fromJson(Map<String, dynamic> json) { ... }
    //   Map<String, dynamic> toMap() { ... }
    //
    final hasFromJson = element.methods.any(
      (m) => m.isStatic && (m.name == 'fromJson' || m.name == 'fromMap'),
    );
    final hasToMap = element.methods.any(
      (m) => !m.isStatic && (m.name == 'toMap' || m.name == 'toJson'),
    );
    final hasManualSerialization = hasFromJson && hasToMap;

    // For manually-serialized classes the hand-written fromJson/toMap
    // conventionally uses snake_case JSON keys (e.g. `correct_answer`)
    // while the Dart fields are camelCase (e.g. `correctOption`).
    // We propagate this flag into _analyzeField so effectiveJsonName
    // converts automatically — unless a field has an explicit @JsonKey(name:).
    final useSnakeCase = hasManualSerialization && !hasJsonSerializable;

    // Own fields: declared directly on this class.
    // isOriginDeclaration == true  →  real declared field (not a synthetic
    // getter/setter created by the compiler).
    final ownFields = element.fields
        .where((f) => !f.isStatic && f.isOriginDeclaration)
        .map((f) => _analyzeField(f, useSnakeCase: useSnakeCase))
        .whereType<FieldInfo>()
        .toList();

    // Inherited fields from the full superclass chain.
    final inheritedFields = _collectInheritedFields(
      element,
      useSnakeCase: useSnakeCase,
    );

    return ClassInfo(
      name: element.name!,
      assetPath: assetPath,
      ownFields: ownFields,
      inheritedFields: inheritedFields,
      superclassName: _superclassName(element),
      // hasJsonSerializable drives the "should we emit this class" filter in
      // builder.dart / generator.dart.  We fold all three detection paths
      // into this single flag so no downstream changes are required.
      hasJsonSerializable:
          hasJsonSerializable || hasManualSerialization || hasTsGenerate,
      hasManualSerialization: hasManualSerialization,
    );
  }

  // ── Inherited fields ──────────────────────────────────────────────────────

  List<FieldInfo> _collectInheritedFields(
    ClassElement element, {
    bool useSnakeCase = false,
    int depth = 0,
  }) {
    if (depth > 8) return const [];

    // ClassElement.supertype returns InterfaceType? in analyzer >=7.
    final superType = element.supertype;
    if (superType == null) return const [];

    final superEl = superType.element;
    if (superEl is! ClassElement || superEl.name == 'Object') return const [];

    // Recurse so deepest ancestor fields appear first.
    final ancestorFields = _collectInheritedFields(
      superEl,
      useSnakeCase: useSnakeCase,
      depth: depth + 1,
    );

    final parentFields = superEl.fields
        .where((f) => !f.isStatic && f.isOriginDeclaration)
        .map((f) => _analyzeField(f, useSnakeCase: useSnakeCase))
        .whereType<FieldInfo>()
        .toList();

    return [...ancestorFields, ...parentFields];
  }

  // ── Single field ──────────────────────────────────────────────────────────

  FieldInfo? _analyzeField(FieldElement field, {bool useSnakeCase = false}) {
    // ── @JsonKey ──────────────────────────────────────────────────────────
    final jsonKey = _getAnnotationNamed(field, 'JsonKey');

    if (jsonKey != null) {
      if (_boolField(jsonKey, 'ignore') == true) return null;
      if (_boolField(jsonKey, 'includeFromJson') == false) return null;
      if (_boolField(jsonKey, 'includeToJson') == false) return null;
    }

    final type = field.type;
    final isNullable = type.nullabilitySuffix == NullabilitySuffix.question;

    // ── Converter annotations ─────────────────────────────────────────────
    final hasDateTimeConv = _hasAnnotationNamed(field, 'DateTimeConverter');
    final hasDateTimeListConv = _hasAnnotationNamed(
      field,
      'DateTimeListConverter',
    );
    final hasDateTimeNullableConv = _hasAnnotationNamed(field, 'DateTimeNullableConverter') || _hasAnnotationNamed(field, 'NullableDateTimeConverter');
    
    final hasPhoneConv = _hasAnnotationNamed(field, 'PhoneConverter') || _hasAnnotationNamed(field, 'NullablePhoneConverter');
    final hasDisplayNameConv = _hasAnnotationNamed(field, 'DisplayNameConverter') || _hasAnnotationNamed(field, 'NullableDisplayNameConverter');
    final hasDoubleConv = _hasAnnotationNamed(field, 'DoubleConverter') || _hasAnnotationNamed(field, 'NullableDoubleConverter');
    final hasIntConv = _hasAnnotationNamed(field, 'IntConverter') || _hasAnnotationNamed(field, 'NullableIntConverter');
    final hasStringConv = _hasAnnotationNamed(field, 'StringConverter') || _hasAnnotationNamed(field, 'NullableStringConverter');
    final hasBoolConv = _hasAnnotationNamed(field, 'BoolConverter') || _hasAnnotationNamed(field, 'NullableBoolConverter');

    // ── Collection detection ──────────────────────────────────────────────
    bool isList = false, isMap = false;
    String? listItemType, mapValueType;

    if (type is InterfaceType) {
      final typeName = type.element.name;
      if (typeName == 'List' && type.typeArguments.isNotEmpty) {
        isList = true;
        listItemType = _baseTypeName(type.typeArguments.first);
      } else if (typeName == 'Map' && type.typeArguments.length >= 2) {
        isMap = true;
        mapValueType = _baseTypeName(type.typeArguments[1]);
      }
    }

    // ── Enum detection ────────────────────────────────────────────────────
    final baseType = _baseTypeName(type);
    final isEnum = _isKnownEnum(type);

    // ── @JsonKey default + name ───────────────────────────────────────────
    dynamic defaultValue;
    String? jsonKeyName;
    if (jsonKey != null) {
      defaultValue = _readDefaultValue(jsonKey);
      jsonKeyName = _stringField(jsonKey, 'name');
    }

    return FieldInfo(
      name: field.name!,
      dartType: baseType,
      isNullable: isNullable,
      isList: isList,
      isMap: isMap,
      listItemType: listItemType,
      mapValueType: mapValueType,
      isEnum: isEnum,
      defaultValue: defaultValue,
      hasDateTimeConverter: hasDateTimeConv,
      hasDateTimeListConverter: hasDateTimeListConv,
      hasDateTimeNullableConverter: hasDateTimeNullableConv,
      hasPhoneConverter: hasPhoneConv,
      hasDisplayNameConverter: hasDisplayNameConv,
      hasDoubleConverter: hasDoubleConv,
      hasIntConverter: hasIntConv,
      hasStringConverter: hasStringConv,
      hasBoolConverter: hasBoolConv,
      jsonKeyName: jsonKeyName,
      // Only apply snake_case fallback when there is no explicit @JsonKey(name:).
      // This ensures @JsonKey always wins, and snake_case only kicks in for
      // manual-serialization classes that have no per-field override.
      useSnakeCaseFallback: jsonKeyName == null && useSnakeCase,
    );
  }

  // ── Type helpers ──────────────────────────────────────────────────────────

  String _baseTypeName(DartType type) {
    if (type is InterfaceType) return type.element.name!;
    // Handle TypeParameterType, FunctionType, etc.
    final raw = type.toString().replaceAll('?', '');
    return raw.split('<').first.trim();
  }

  bool _isKnownEnum(DartType type) {
    if (type is InterfaceType && type.element is EnumElement) return true;
    return _registry.isEnum(_baseTypeName(type));
  }

  String? _superclassName(ClassElement element) {
    final s = element.supertype;
    if (s == null || s.element.name == 'Object') return null;
    return s.element.name;
  }

  // ── Annotation helpers ────────────────────────────────────────────────────

  bool _hasAnnotationNamed(Element element, String annotationName) {
    return element.metadata.annotations.any((m) {
      final el = m.element;
      // In analyzer ^10, ConstructorElement.enclosingElement returns
      // the InterfaceElement (ClassElement / EnumElement).
      if (el is ConstructorElement) {
        return el.enclosingElement.name == annotationName;
      }
      if (el is PropertyAccessorElement) {
        return el.name == annotationName;
      }
      return false;
    });
  }

  ElementAnnotation? _getAnnotationNamed(
    Element element,
    String annotationName,
  ) {
    for (final m in element.metadata.annotations) {
      final el = m.element;
      if (el is ConstructorElement &&
          el.enclosingElement.name == annotationName) {
        return m;
      }
    }
    return null;
  }

  // ── Constant value readers ────────────────────────────────────────────────

  bool? _boolField(ElementAnnotation ann, String fieldName) {
    try {
      return ann.computeConstantValue()?.getField(fieldName)?.toBoolValue();
    } catch (_) {
      return null;
    }
  }

  String? _stringField(ElementAnnotation ann, String fieldName) {
    try {
      return ann.computeConstantValue()?.getField(fieldName)?.toStringValue();
    } catch (_) {
      return null;
    }
  }

  /// Extracts the `defaultValue` from `@JsonKey(defaultValue: ...)`.
  /// Returns bool / int / double / String / List<dynamic> or null.
  dynamic _readDefaultValue(ElementAnnotation ann) {
    try {
      final obj = ann.computeConstantValue()?.getField('defaultValue');
      if (obj == null || obj.isNull) return null;

      final t = obj.type;
      if (t == null) return null;

      if (t.isDartCoreBool) return obj.toBoolValue();
      if (t.isDartCoreInt) return obj.toIntValue();
      if (t.isDartCoreDouble) return obj.toDoubleValue();
      if (t.isDartCoreString) return obj.toStringValue();

      // Enum default — e.g. `CallStatus.pending`.
      // The DartObject has fields; look for the '_name' field (synthetic).
      final nameField = obj.getField('_name') ?? obj.getField('name');
      if (nameField != null) return nameField.toStringValue();

      // List default — e.g. `[]`.
      final listVal = obj.toListValue();
      if (listVal != null) return <dynamic>[];

      return null;
    } catch (_) {
      return null;
    }
  }
}
