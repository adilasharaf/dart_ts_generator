import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, Object> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Object json) {
    return switch (json) {
      Timestamp ts => ts.toDate(),
      int ms => DateTime.fromMillisecondsSinceEpoch(ms),
      _ => throw ArgumentError('Cannot convert $json to DateTime'),
    };
  }

  @override
  Timestamp toJson(DateTime json) => Timestamp.fromDate(json);
}

class DateTimeNullableConverter implements JsonConverter<DateTime?, Object?> {
  const DateTimeNullableConverter();

  @override
  DateTime? fromJson(Object? json) {
    return switch (json) {
      Timestamp ts => ts.toDate(),
      int ms => DateTime.fromMillisecondsSinceEpoch(ms),
      _ => null,
    };
  }

  @override
  Timestamp? toJson(DateTime? json) =>
      json != null ? Timestamp.fromDate(json) : null;
}

class DateTimeListConverter
    implements JsonConverter<List<DateTime>, List<dynamic>> {
  const DateTimeListConverter();

  @override
  List<DateTime> fromJson(List<dynamic> json) {
    return json
        .map(
          (e) => switch (e) {
            Timestamp ts => ts.toDate(),
            int ms => DateTime.fromMillisecondsSinceEpoch(ms),
            _ => throw ArgumentError('Cannot convert $e to DateTime'),
          },
        )
        .toList();
  }

  @override
  List<Timestamp> toJson(List<DateTime> json) =>
      json.map((e) => Timestamp.fromDate(e)).toList();
}

class PhoneConverter implements JsonConverter<String?, dynamic> {
  const PhoneConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    final phone = json.toString();
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '+91$digits';
    }

    if (digits.length == 12 && digits.startsWith('91')) {
      return '+$digits';
    }

    if (digits.length == 11 && digits.startsWith('0')) {
      return '+91${digits.substring(1)}';
    }

    return null;
  }

  @override
  dynamic toJson(String? object) => object;
}

class DisplayNameConverter implements JsonConverter<String?, dynamic> {
  const DisplayNameConverter();

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

class DoubleConverter implements JsonConverter<double?, dynamic> {
  const DoubleConverter();

  @override
  double? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is double) return json;
    if (json is int) return json.toDouble();
    if (json is String) return double.tryParse(json);
    return null;
  }

  @override
  dynamic toJson(double? object) => object;
}

class IntConverter implements JsonConverter<int?, dynamic> {
  const IntConverter();

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
