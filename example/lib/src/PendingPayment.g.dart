// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PendingPayment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingPayment _$PendingPaymentFromJson(Map<String, dynamic> json) =>
    PendingPayment()
      ..id = json['id'] as String
      ..addedOn = const DateTimeNullableConverter().fromJson(json['addedOn'])
      ..addedBy = json['addedBy'] == null
          ? null
          : EiUser.fromJson(json['addedBy'] as Map<String, dynamic>)
      ..modifiedOn = const DateTimeNullableConverter().fromJson(
        json['modifiedOn'],
      )
      ..modifiedBy = json['modifiedBy'] as String?
      ..operationId = json['operationId'] as String?
      ..bookingId = json['bookingId'] as String?
      ..paymentId = json['paymentId'] as String?
      ..amount = (json['amount'] as num?)?.toDouble() ?? 0;

Map<String, dynamic> _$PendingPaymentToJson(
  PendingPayment instance,
) => <String, dynamic>{
  'id': instance.id,
  'addedOn': const DateTimeNullableConverter().toJson(instance.addedOn),
  'addedBy': instance.addedBy?.toJson(),
  'modifiedOn': const DateTimeNullableConverter().toJson(instance.modifiedOn),
  'modifiedBy': instance.modifiedBy,
  'operationId': instance.operationId,
  'bookingId': instance.bookingId,
  'paymentId': instance.paymentId,
  'amount': instance.amount,
};
