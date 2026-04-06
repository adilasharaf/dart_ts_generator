// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Rto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rto _$RtoFromJson(Map<String, dynamic> json) => Rto()
  ..id = json['id'] as String
  ..name = json['name'] as String?
  ..address = json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>);

Map<String, dynamic> _$RtoToJson(Rto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address?.toJson(),
};
