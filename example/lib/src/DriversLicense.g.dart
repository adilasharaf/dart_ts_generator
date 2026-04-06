// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DriversLicense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriversLicense _$DriversLicenseFromJson(Map<String, dynamic> json) =>
    DriversLicense()
      ..id = json['id'] as String
      ..name = json['name'] as String?
      ..fileName = json['fileName'] as String?
      ..licenceNumber = json['licenceNumber'] as String?
      ..licenceDate = _$JsonConverterFromJson<Object, DateTime>(
        json['licenceDate'],
        const DateTimeConverter().fromJson,
      )
      ..licenceExpiry = _$JsonConverterFromJson<Object, DateTime>(
        json['licenceExpiry'],
        const DateTimeConverter().fromJson,
      )
      ..learnersDate = _$JsonConverterFromJson<Object, DateTime>(
        json['learnersDate'],
        const DateTimeConverter().fromJson,
      )
      ..learnersExpiry = _$JsonConverterFromJson<Object, DateTime>(
        json['learnersExpiry'],
        const DateTimeConverter().fromJson,
      )
      ..frontUrl = json['frontUrl'] as String?
      ..backUrl = json['backUrl'] as String?
      ..learnersUrl = json['learnersUrl'] as String?
      ..licenceUrl = json['licenceUrl'] as String?;

Map<String, dynamic> _$DriversLicenseToJson(DriversLicense instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fileName': instance.fileName,
      'licenceNumber': instance.licenceNumber,
      'licenceDate': _$JsonConverterToJson<Object, DateTime>(
        instance.licenceDate,
        const DateTimeConverter().toJson,
      ),
      'licenceExpiry': _$JsonConverterToJson<Object, DateTime>(
        instance.licenceExpiry,
        const DateTimeConverter().toJson,
      ),
      'learnersDate': _$JsonConverterToJson<Object, DateTime>(
        instance.learnersDate,
        const DateTimeConverter().toJson,
      ),
      'learnersExpiry': _$JsonConverterToJson<Object, DateTime>(
        instance.learnersExpiry,
        const DateTimeConverter().toJson,
      ),
      'frontUrl': instance.frontUrl,
      'backUrl': instance.backUrl,
      'learnersUrl': instance.learnersUrl,
      'licenceUrl': instance.licenceUrl,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
