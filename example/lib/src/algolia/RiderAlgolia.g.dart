// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RiderAlgolia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RiderAlgolia _$RiderAlgoliaFromJson(Map<String, dynamic> json) => RiderAlgolia()
  ..id = json['id'] as String?
  ..displayName = json['displayName'] as String?
  ..phone = json['phone'] as String?
  ..photoUrl = json['photoUrl'] as String?
  ..licenceVerificationStatus =
      json['driversLicense.licenceVerificationStatus'] as String? ?? 'unknown';

Map<String, dynamic> _$RiderAlgoliaToJson(RiderAlgolia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'phone': instance.phone,
      'photoUrl': instance.photoUrl,
      'driversLicense.licenceVerificationStatus':
          instance.licenceVerificationStatus,
    };
