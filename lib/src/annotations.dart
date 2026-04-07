/// Annotations for controlling TypeScript generation behavior.

/// Marks a field to be ignored during TypeScript generation.
class TsIgnore {
  const TsIgnore();
}

/// Overrides the TypeScript type for a field.
/// Example:
/// ```dart
/// @TsType('string | number')
/// dynamic myField;
/// ```
class TsType {
  final String typeName;
  final String? zodSchema;
  const TsType(this.typeName, {this.zodSchema});
}

/// Marks a class for TypeScript generation.
///
/// **Not required** when the class already has both:
///   - a static `fromJson` or `fromMap` method (deserialization), AND
///   - an instance `toMap` or `toJson` method (serialization).
///
/// Those two methods together are detected automatically, so plain
/// hand-written model classes like:
///
/// ```dart
/// class Signal {
///   int? id;
///   String? description;
///
///   static Signal fromJson(Map<String, dynamic> json) { ... }
///   Map<String, dynamic> toMap() { ... }
/// }
/// ```
///
/// are picked up without any annotation.
///
/// Use `@TsGenerate` to **force** generation on classes that don't follow
/// either the `@JsonSerializable` or the `fromJson`/`toMap` convention —
/// for example, a class whose JSON parsing is done elsewhere.
class TsGenerate {
  const TsGenerate();
}

/// Marks a class as a Firestore document model.
/// Adds special handling for Timestamp, GeoPoint, etc.
class TsFirestoreModel {
  const TsFirestoreModel();
}
