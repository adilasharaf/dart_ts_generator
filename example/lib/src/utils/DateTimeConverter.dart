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
    if (json == null) return null;
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

class NullableDateTimeConverter implements JsonConverter<DateTime?, Object?> {
  const NullableDateTimeConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
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
