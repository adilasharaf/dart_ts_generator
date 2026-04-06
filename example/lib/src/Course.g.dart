// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course()
  ..id = json['id'] as String
  ..addedOn = const DateTimeNullableConverter().fromJson(json['addedOn'])
  ..addedBy = json['addedBy'] == null
      ? null
      : EiUser.fromJson(json['addedBy'] as Map<String, dynamic>)
  ..modifiedOn = const DateTimeNullableConverter().fromJson(json['modifiedOn'])
  ..modifiedBy = json['modifiedBy'] as String?
  ..operationId = json['operationId'] as String?
  ..name = json['name'] as String?
  ..description = json['description'] as String?
  ..status =
      $enumDecodeNullable(_$CourseStatusEnumMap, json['status']) ??
      CourseStatus.none
  ..serviceCharge = (json['serviceCharge'] as num?)?.toDouble() ?? 0
  ..rtoFee = (json['rtoFee'] as num?)?.toDouble() ?? 0
  ..gst = (json['gst'] as num?)?.toDouble() ?? 0
  ..subscriptions =
      (json['subscriptions'] as List<dynamic>?)
          ?.map((e) => Subscription.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..dueDate = _$JsonConverterFromJson<Object, DateTime>(
    json['dueDate'],
    const DateTimeConverter().fromJson,
  );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
  'id': instance.id,
  'addedOn': const DateTimeNullableConverter().toJson(instance.addedOn),
  'addedBy': instance.addedBy?.toJson(),
  'modifiedOn': const DateTimeNullableConverter().toJson(instance.modifiedOn),
  'modifiedBy': instance.modifiedBy,
  'operationId': instance.operationId,
  'name': instance.name,
  'description': instance.description,
  'status': _$CourseStatusEnumMap[instance.status]!,
  'serviceCharge': instance.serviceCharge,
  'rtoFee': instance.rtoFee,
  'gst': instance.gst,
  'subscriptions': instance.subscriptions.map((e) => e.toJson()).toList(),
  'dueDate': _$JsonConverterToJson<Object, DateTime>(
    instance.dueDate,
    const DateTimeConverter().toJson,
  ),
};

const _$CourseStatusEnumMap = {
  CourseStatus.none: 'none',
  CourseStatus.enrolled: 'enrolled',
  CourseStatus.completed: 'completed',
  CourseStatus.cancelled: 'cancelled',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
