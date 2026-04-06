// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EiUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EiUser _$EiUserFromJson(Map<String, dynamic> json) => EiUser()
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
  ..phone = json['phone'] as String?
  ..photoUrl = json['photoUrl'] as String?
  ..displayName = json['displayName'] as String?
  ..address = json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>)
  ..currentLocation = json['currentLocation'] == null
      ? null
      : Address.fromJson(json['currentLocation'] as Map<String, dynamic>)
  ..gender = json['gender'] as String?
  ..bloodGroup = json['bloodGroup'] as String?
  ..pendingAmount = (json['pendingAmount'] as num?)?.toDouble() ?? 0.0
  ..deviceTokens =
      (json['deviceTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      []
  ..isDeleted = json['isDeleted'] as bool? ?? false
  ..deletedOn = const DateTimeNullableConverter().fromJson(json['deletedOn']);

Map<String, dynamic> _$EiUserToJson(EiUser instance) => <String, dynamic>{
  'id': instance.id,
  'addedOn': const DateTimeNullableConverter().toJson(instance.addedOn),
  'addedBy': instance.addedBy?.toJson(),
  'modifiedOn': const DateTimeNullableConverter().toJson(instance.modifiedOn),
  'modifiedBy': instance.modifiedBy,
  'operationId': instance.operationId,
  'userId': instance.userId,
  'email': instance.email,
  'phone': instance.phone,
  'photoUrl': instance.photoUrl,
  'displayName': instance.displayName,
  'address': instance.address?.toJson(),
  'currentLocation': instance.currentLocation?.toJson(),
  'gender': instance.gender,
  'bloodGroup': instance.bloodGroup,
  'pendingAmount': instance.pendingAmount,
  'deviceTokens': instance.deviceTokens,
  'isDeleted': instance.isDeleted,
  'deletedOn': const DateTimeNullableConverter().toJson(instance.deletedOn),
};
