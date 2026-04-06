// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription()
  ..id = json['id'] as String
  ..addedOn = const DateTimeNullableConverter().fromJson(json['addedOn'])
  ..addedBy = json['addedBy'] == null
      ? null
      : EiUser.fromJson(json['addedBy'] as Map<String, dynamic>)
  ..modifiedOn = const DateTimeNullableConverter().fromJson(json['modifiedOn'])
  ..modifiedBy = json['modifiedBy'] as String?
  ..operationId = json['operationId'] as String?
  ..name = json['name'] as String? ?? ''
  ..description = json['description'] as String? ?? ''
  ..effectivePriceLmv = (json['effectivePriceLmv'] as num?)?.toDouble()
  ..effectivePriceMc = (json['effectivePriceMc'] as num?)?.toDouble()
  ..lmvBookingLimit = (json['lmvBookingLimit'] as num?)?.toInt() ?? 0
  ..mcBookingLimit = (json['mcBookingLimit'] as num?)?.toInt() ?? 0
  ..rtoTestBookingLimit = (json['rtoTestBookingLimit'] as num?)?.toInt() ?? 0
  ..mockTestBookingLimit = (json['mockTestBookingLimit'] as num?)?.toInt() ?? 0
  ..lmvBookingTotal = (json['lmvBookingTotal'] as num?)?.toInt() ?? 0
  ..mcBookingTotal = (json['mcBookingTotal'] as num?)?.toInt() ?? 0
  ..rtoTestBookingTotal = (json['rtoTestBookingTotal'] as num?)?.toInt() ?? 0
  ..mockTestBookingTotal = (json['mockTestBookingTotal'] as num?)?.toInt() ?? 0
  ..startDate = _$JsonConverterFromJson<Object, DateTime>(
    json['startDate'],
    const DateTimeConverter().fromJson,
  )
  ..endDate = _$JsonConverterFromJson<Object, DateTime>(
    json['endDate'],
    const DateTimeConverter().fromJson,
  )
  ..amount = (json['amount'] as num?)?.toDouble() ?? 0
  ..gst = (json['gst'] as num?)?.toDouble() ?? 0;

Map<String, dynamic> _$SubscriptionToJson(
  Subscription instance,
) => <String, dynamic>{
  'id': instance.id,
  'addedOn': const DateTimeNullableConverter().toJson(instance.addedOn),
  'addedBy': instance.addedBy?.toJson(),
  'modifiedOn': const DateTimeNullableConverter().toJson(instance.modifiedOn),
  'modifiedBy': instance.modifiedBy,
  'operationId': instance.operationId,
  'name': instance.name,
  'description': instance.description,
  'effectivePriceLmv': instance.effectivePriceLmv,
  'effectivePriceMc': instance.effectivePriceMc,
  'lmvBookingLimit': instance.lmvBookingLimit,
  'mcBookingLimit': instance.mcBookingLimit,
  'rtoTestBookingLimit': instance.rtoTestBookingLimit,
  'mockTestBookingLimit': instance.mockTestBookingLimit,
  'lmvBookingTotal': instance.lmvBookingTotal,
  'mcBookingTotal': instance.mcBookingTotal,
  'rtoTestBookingTotal': instance.rtoTestBookingTotal,
  'mockTestBookingTotal': instance.mockTestBookingTotal,
  'startDate': _$JsonConverterToJson<Object, DateTime>(
    instance.startDate,
    const DateTimeConverter().toJson,
  ),
  'endDate': _$JsonConverterToJson<Object, DateTime>(
    instance.endDate,
    const DateTimeConverter().toJson,
  ),
  'amount': instance.amount,
  'gst': instance.gst,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
