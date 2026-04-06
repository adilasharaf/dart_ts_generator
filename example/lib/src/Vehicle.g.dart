// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle()
  ..id = json['id'] as String
  ..addedOn = const DateTimeNullableConverter().fromJson(json['addedOn'])
  ..addedBy = json['addedBy'] == null
      ? null
      : EiUser.fromJson(json['addedBy'] as Map<String, dynamic>)
  ..modifiedOn = const DateTimeNullableConverter().fromJson(json['modifiedOn'])
  ..modifiedBy = json['modifiedBy'] as String?
  ..operationId = json['operationId'] as String?
  ..make = json['make'] as String
  ..model = json['model'] as String
  ..year = (json['year'] as num?)?.toInt()
  ..imageUrl = json['imageUrl'] as String
  ..savedAs = json['savedAs'] as String?
  ..kmsDriven = (json['kmsDriven'] as num?)?.toInt()
  ..vehicleNumber = json['vehicleNumber'] as String?
  ..variant = json['variant'] as String?
  ..makeCountry = json['makeCountry'] as String?
  ..priceFactor = (json['priceFactor'] as num?)?.toDouble() ?? 1.0
  ..assignedTrainerId = json['assignedTrainerId'] as String?
  ..capacity = (json['capacity'] as num?)?.toInt()
  ..isPickupAvailable = json['isPickupAvailable'] as bool? ?? true;

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
  'id': instance.id,
  'addedOn': const DateTimeNullableConverter().toJson(instance.addedOn),
  'addedBy': instance.addedBy?.toJson(),
  'modifiedOn': const DateTimeNullableConverter().toJson(instance.modifiedOn),
  'modifiedBy': instance.modifiedBy,
  'operationId': instance.operationId,
  'make': instance.make,
  'model': instance.model,
  'year': instance.year,
  'imageUrl': instance.imageUrl,
  'savedAs': instance.savedAs,
  'kmsDriven': instance.kmsDriven,
  'vehicleNumber': instance.vehicleNumber,
  'variant': instance.variant,
  'makeCountry': instance.makeCountry,
  'priceFactor': instance.priceFactor,
  'assignedTrainerId': instance.assignedTrainerId,
  'capacity': instance.capacity,
  'isPickupAvailable': instance.isPickupAvailable,
};
