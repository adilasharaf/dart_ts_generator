// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EiModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EiModel _$EiModelFromJson(Map<String, dynamic> json) => EiModel()
  ..id = json['id'] as String
  ..addedOn = const DateTimeNullableConverter().fromJson(json['addedOn'])
  ..addedBy = json['addedBy'] == null
      ? null
      : EiUser.fromJson(json['addedBy'] as Map<String, dynamic>)
  ..modifiedOn = const DateTimeNullableConverter().fromJson(json['modifiedOn'])
  ..modifiedBy = json['modifiedBy'] as String?
  ..operationId = json['operationId'] as String?;

Map<String, dynamic> _$EiModelToJson(EiModel instance) => <String, dynamic>{
  'id': instance.id,
  'addedOn': const DateTimeNullableConverter().toJson(instance.addedOn),
  'addedBy': instance.addedBy,
  'modifiedOn': const DateTimeNullableConverter().toJson(instance.modifiedOn),
  'modifiedBy': instance.modifiedBy,
  'operationId': instance.operationId,
};
