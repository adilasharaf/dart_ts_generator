// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthConfig _$AuthConfigFromJson(Map<String, dynamic> json) => AuthConfig()
  ..admin =
      (json['admin'] as List<dynamic>?)?.map((e) => e as String?).toList() ?? []
  ..franchise =
      (json['franchise'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList() ??
      [];

Map<String, dynamic> _$AuthConfigToJson(AuthConfig instance) =>
    <String, dynamic>{'admin': instance.admin, 'franchise': instance.franchise};
