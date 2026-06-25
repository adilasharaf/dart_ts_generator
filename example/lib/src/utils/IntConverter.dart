import 'package:json_annotation/json_annotation.dart';

class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic json) {
    if (json == null) return 0;
    if (json is int) return json;
    if (json is double) return json.toInt();
    if (json is String) {
      final num = double.tryParse(json);
      return num?.toInt() ?? 0;
    }
    return 0;
  }

  @override
  dynamic toJson(int object) => object;
}

class NullableIntConverter implements JsonConverter<int?, dynamic> {
  const NullableIntConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is int) return json;
    if (json is double) return json.toInt();
    if (json is String) {
      final num = double.tryParse(json);
      return num?.toInt();
    }
    return null;
  }

  @override
  dynamic toJson(int? object) => object;
}
