// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TrainerBooking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainerBooking _$TrainerBookingFromJson(Map<String, dynamic> json) =>
    TrainerBooking()
      ..id = json['id'] as String
      ..bookedBy = EiUser.fromJson(json['bookedBy'] as Map<String, dynamic>)
      ..totalAmount = (json['totalAmount'] as num?)?.toDouble()
      ..payableAmount = (json['payableAmount'] as num?)?.toDouble()
      ..effectivePrice = (json['effectivePrice'] as num?)?.toDouble()
      ..cancellationNote = json['cancellationNote'] as String?
      ..modifiedBy = json['modifiedBy'] as String?
      ..operationId = json['operationId'] as String?
      ..pendingAmountCollected =
          (json['pendingAmountCollected'] as num?)?.toDouble() ?? 0.0
      ..cancellationCharge =
          (json['cancellationCharge'] as num?)?.toDouble() ?? 0.0
      ..cancelledOn = _$JsonConverterFromJson<Object, DateTime>(
        json['cancelledOn'],
        const DateTimeConverter().fromJson,
      )
      ..bookedOn = _$JsonConverterFromJson<Object, DateTime>(
        json['bookedOn'],
        const DateTimeConverter().fromJson,
      )
      ..modifiedOn = _$JsonConverterFromJson<Object, DateTime>(
        json['modifiedOn'],
        const DateTimeConverter().fromJson,
      )
      ..totalAmountPerKm = (json['totalAmountPerKm'] as num?)?.toDouble()
      ..payableAmountPerKm = (json['payableAmountPerKm'] as num?)?.toDouble()
      ..minPayableAmount = (json['minPayableAmount'] as num?)?.toDouble()
      ..maxPayableAmount = (json['maxPayableAmount'] as num?)?.toDouble()
      ..pickupLocation = json['pickupLocation'] == null
          ? null
          : Address.fromJson(json['pickupLocation'] as Map<String, dynamic>)
      ..dropLocation = json['dropLocation'] == null
          ? null
          : Address.fromJson(json['dropLocation'] as Map<String, dynamic>)
      ..pickTime = _$JsonConverterFromJson<Object, DateTime>(
        json['pickTime'],
        const DateTimeConverter().fromJson,
      )
      ..riders = (json['riders'] as List<dynamic>?)
          ?.map((e) => Rider.fromJson(e as Map<String, dynamic>))
          .toList()
      ..vehicle = json['vehicle'] == null
          ? null
          : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>);

Map<String, dynamic> _$TrainerBookingToJson(TrainerBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookedBy': instance.bookedBy.toJson(),
      'totalAmount': instance.totalAmount,
      'payableAmount': instance.payableAmount,
      'effectivePrice': instance.effectivePrice,
      'cancellationNote': instance.cancellationNote,
      'modifiedBy': instance.modifiedBy,
      'operationId': instance.operationId,
      'pendingAmountCollected': instance.pendingAmountCollected,
      'cancellationCharge': instance.cancellationCharge,
      'cancelledOn': _$JsonConverterToJson<Object, DateTime>(
        instance.cancelledOn,
        const DateTimeConverter().toJson,
      ),
      'bookedOn': _$JsonConverterToJson<Object, DateTime>(
        instance.bookedOn,
        const DateTimeConverter().toJson,
      ),
      'modifiedOn': _$JsonConverterToJson<Object, DateTime>(
        instance.modifiedOn,
        const DateTimeConverter().toJson,
      ),
      'totalAmountPerKm': instance.totalAmountPerKm,
      'payableAmountPerKm': instance.payableAmountPerKm,
      'minPayableAmount': instance.minPayableAmount,
      'maxPayableAmount': instance.maxPayableAmount,
      'pickupLocation': instance.pickupLocation?.toJson(),
      'dropLocation': instance.dropLocation?.toJson(),
      'pickTime': _$JsonConverterToJson<Object, DateTime>(
        instance.pickTime,
        const DateTimeConverter().toJson,
      ),
      'riders': instance.riders?.map((e) => e.toJson()).toList(),
      'vehicle': instance.vehicle?.toJson(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
