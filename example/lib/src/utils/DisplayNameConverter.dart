import 'package:json_annotation/json_annotation.dart';

class DisplayNameConverter implements JsonConverter<String, dynamic> {
  const DisplayNameConverter();

  @override
  String fromJson(dynamic json) {
    if (json == null) return '';
    final name = json.toString();
    if (name.trim().isEmpty) return '';
    
    return name
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  @override
  dynamic toJson(String object) => object;
}

class NullableDisplayNameConverter implements JsonConverter<String?, dynamic> {
  const NullableDisplayNameConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    final name = json.toString();
    if (name.trim().isEmpty) return null;
    
    return name
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  @override
  dynamic toJson(String? object) => object;
}
