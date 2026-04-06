// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address()
  ..id = json['id'] as String
  ..line1 = json['line1'] as String?
  ..line2 = json['line2'] as String?
  ..city = json['city'] as String?
  ..district = json['district'] as String?
  ..state = json['state'] as String?
  ..pin = json['pin'] as String?
  ..latitude = (json['latitude'] as num?)?.toDouble()
  ..longitude = (json['longitude'] as num?)?.toDouble()
  ..savedAs = json['savedAs'] as String?
  ..fullAddress = json['fullAddress'] as String?
  ..geoHash = json['geoHash'] as String?
  ..geoPoint = Address._fromJsonGeoPoint(json['geoPoint'] as GeoPoint?);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id': instance.id,
  'line1': instance.line1,
  'line2': instance.line2,
  'city': instance.city,
  'district': instance.district,
  'state': instance.state,
  'pin': instance.pin,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'savedAs': instance.savedAs,
  'fullAddress': instance.fullAddress,
  'geoHash': instance.geoHash,
  'geoPoint': Address._toJsonGeoPoint(instance.geoPoint),
};
