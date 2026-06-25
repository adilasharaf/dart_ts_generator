// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Lead.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lead _$LeadFromJson(Map<String, dynamic> json) => Lead()
  ..id = json['id'] as String
  ..addedOn = const DateTimeNullableConverter().fromJson(json['addedOn'])
  ..addedBy = json['addedBy'] == null
      ? null
      : EiUser.fromJson(json['addedBy'] as Map<String, dynamic>)
  ..modifiedOn = const DateTimeNullableConverter().fromJson(json['modifiedOn'])
  ..modifiedBy = json['modifiedBy'] as String?
  ..operationId = json['operationId'] as String?
  ..userId = json['userId'] as String?
  ..email = json['email'] as String?
  ..photoUrl = json['photoUrl'] as String?
  ..address = json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>)
  ..currentLocation = json['currentLocation'] == null
      ? null
      : Address.fromJson(json['currentLocation'] as Map<String, dynamic>)
  ..gender = json['gender'] as String?
  ..bloodGroup = json['bloodGroup'] as String?
  ..phone = const NullablePhoneConverter().fromJson(json['phone'])
  ..displayName = const NullableDisplayNameConverter().fromJson(
    json['displayName'],
  )
  ..pendingAmount = (json['pendingAmount'] as num?)?.toDouble() ?? 0.0
  ..deviceTokens =
      (json['deviceTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      []
  ..isDeleted = json['isDeleted'] as bool? ?? false
  ..deletedOn = const DateTimeNullableConverter().fromJson(json['deletedOn'])
  ..leadId = json['leadId'] as String?
  ..rider = json['rider'] == null
      ? null
      : Rider.fromJson(json['rider'] as Map<String, dynamic>)
  ..followUpDate = _$JsonConverterFromJson<Object, DateTime>(
    json['followUpDate'],
    const DateTimeConverter().fromJson,
  )
  ..callStatus =
      $enumDecodeNullable(_$CallStatusEnumMap, json['callStatus']) ??
      CallStatus.pending
  ..leadSource = json['leadSource'] as String? ?? 'Unknown'
  ..dueDate = _$JsonConverterFromJson<Object, DateTime>(
    json['dueDate'],
    const DateTimeConverter().fromJson,
  );

Map<String, dynamic> _$LeadToJson(Lead instance) => <String, dynamic>{
  'id': instance.id,
  'addedOn': const DateTimeNullableConverter().toJson(instance.addedOn),
  'addedBy': instance.addedBy?.toJson(),
  'modifiedOn': const DateTimeNullableConverter().toJson(instance.modifiedOn),
  'modifiedBy': instance.modifiedBy,
  'operationId': instance.operationId,
  'userId': instance.userId,
  'email': instance.email,
  'photoUrl': instance.photoUrl,
  'address': instance.address?.toJson(),
  'currentLocation': instance.currentLocation?.toJson(),
  'gender': instance.gender,
  'bloodGroup': instance.bloodGroup,
  'phone': const NullablePhoneConverter().toJson(instance.phone),
  'displayName': const NullableDisplayNameConverter().toJson(
    instance.displayName,
  ),
  'pendingAmount': instance.pendingAmount,
  'deviceTokens': instance.deviceTokens,
  'isDeleted': instance.isDeleted,
  'deletedOn': const DateTimeNullableConverter().toJson(instance.deletedOn),
  'leadId': instance.leadId,
  'rider': instance.rider?.toJson(),
  'followUpDate': _$JsonConverterToJson<Object, DateTime>(
    instance.followUpDate,
    const DateTimeConverter().toJson,
  ),
  'callStatus': _$CallStatusEnumMap[instance.callStatus]!,
  'leadSource': instance.leadSource,
  'dueDate': _$JsonConverterToJson<Object, DateTime>(
    instance.dueDate,
    const DateTimeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$CallStatusEnumMap = {
  CallStatus.pending: 'pending',
  CallStatus.didntConnect: 'didntConnect',
  CallStatus.didntPickup: 'didntPickup',
  CallStatus.interested: 'interested',
  CallStatus.notInterested: 'notInterested',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
