// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking()
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
  ..cancellationCharge = (json['cancellationCharge'] as num?)?.toDouble() ?? 0.0
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
  );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
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
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
