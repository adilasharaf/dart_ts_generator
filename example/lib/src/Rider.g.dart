// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Rider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rider _$RiderFromJson(Map<String, dynamic> json) => Rider()
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
  ..vehicles = (json['vehicles'] as List<dynamic>?)
      ?.map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
      .toList()
  ..savedAddresses = (json['savedAddresses'] as List<dynamic>?)
      ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
      .toList()
  ..kmsDriven = (json['kmsDriven'] as num?)?.toDouble() ?? 0.0
  ..driversLicense = json['driversLicense'] == null
      ? null
      : DriversLicense.fromJson(json['driversLicense'] as Map<String, dynamic>)
  ..licenseApplication = json['licenseApplication'] == null
      ? null
      : LicenseApplication.fromJson(
          json['licenseApplication'] as Map<String, dynamic>,
        )
  ..lastBookedAddress = json['lastBookedAddress'] == null
      ? null
      : Address.fromJson(json['lastBookedAddress'] as Map<String, dynamic>)
  ..trainInRiderVehicleEnabled =
      json['trainInRiderVehicleEnabled'] as bool? ?? false
  ..riderCategories =
      (json['riderCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      []
  ..appVersion = json['appVersion'] as String?
  ..appBuildNumber = (json['appBuildNumber'] as num?)?.toInt()
  ..course = json['course'] == null
      ? null
      : Course.fromJson(json['course'] as Map<String, dynamic>)
  ..selectedRto = json['selectedRto'] == null
      ? null
      : Rto.fromJson(json['selectedRto'] as Map<String, dynamic>)
  ..dob = const DateTimeNullableConverter().fromJson(json['dob']);

Map<String, dynamic> _$RiderToJson(Rider instance) => <String, dynamic>{
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
  'vehicles': instance.vehicles?.map((e) => e.toJson()).toList(),
  'savedAddresses': instance.savedAddresses?.map((e) => e.toJson()).toList(),
  'kmsDriven': instance.kmsDriven,
  'driversLicense': instance.driversLicense?.toJson(),
  'licenseApplication': instance.licenseApplication?.toJson(),
  'lastBookedAddress': instance.lastBookedAddress?.toJson(),
  'trainInRiderVehicleEnabled': instance.trainInRiderVehicleEnabled,
  'riderCategories': instance.riderCategories,
  'appVersion': instance.appVersion,
  'appBuildNumber': instance.appBuildNumber,
  'course': instance.course?.toJson(),
  'selectedRto': instance.selectedRto?.toJson(),
  'dob': const DateTimeNullableConverter().toJson(instance.dob),
};
