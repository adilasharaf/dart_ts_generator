// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LicenseApplication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicenseApplication _$LicenseApplicationFromJson(
  Map<String, dynamic> json,
) => LicenseApplication()
  ..id = json['id'] as String
  ..addedOn = const DateTimeNullableConverter().fromJson(json['addedOn'])
  ..addedBy = json['addedBy'] == null
      ? null
      : EiUser.fromJson(json['addedBy'] as Map<String, dynamic>)
  ..modifiedOn = const DateTimeNullableConverter().fromJson(json['modifiedOn'])
  ..modifiedBy = json['modifiedBy'] as String?
  ..operationId = json['operationId'] as String?
  ..fullName = json['fullName'] as String?
  ..applicationNumber = json['applicationNumber'] as String?
  ..gender = json['gender'] as String?
  ..bloodGroup = json['bloodGroup'] as String?
  ..phone = json['phone'] as String?
  ..nationality = json['nationality'] as String?
  ..selectedRto = json['selectedRto'] == null
      ? null
      : Rto.fromJson(json['selectedRto'] as Map<String, dynamic>)
  ..rider = json['rider'] == null
      ? null
      : Rider.fromJson(json['rider'] as Map<String, dynamic>)
  ..dlStatus =
      $enumDecodeNullable(_$DLStatusEnumMap, json['dlStatus']) ?? DLStatus.none
  ..isAlreadyHaveLicence = json['haveLicence'] as bool? ?? false
  ..llExpiry = _$JsonConverterFromJson<Object, DateTime>(
    json['llExpiry'],
    const DateTimeConverter().fromJson,
  )
  ..dob = _$JsonConverterFromJson<Object, DateTime>(
    json['dob'],
    const DateTimeConverter().fromJson,
  )
  ..rtoPaymentCompletedDate = _$JsonConverterFromJson<Object, DateTime>(
    json['rtoPaymentCompletedDate'],
    const DateTimeConverter().fromJson,
  )
  ..formFilledDate = _$JsonConverterFromJson<Object, DateTime>(
    json['formFilledDate'],
    const DateTimeConverter().fromJson,
  )
  ..eyeTestUploadPendingDate = _$JsonConverterFromJson<Object, DateTime>(
    json['eyeTestUploadPendingDate'],
    const DateTimeConverter().fromJson,
  )
  ..eyeTestUploadCompletedDate = _$JsonConverterFromJson<Object, DateTime>(
    json['eyeTestUploadCompletedDate'],
    const DateTimeConverter().fromJson,
  )
  ..docsRequestedDate = _$JsonConverterFromJson<Object, DateTime>(
    json['docsRequestedDate'],
    const DateTimeConverter().fromJson,
  )
  ..docsUploadedDate = _$JsonConverterFromJson<Object, DateTime>(
    json['docsUploadedDate'],
    const DateTimeConverter().fromJson,
  )
  ..applicationStartedDate = _$JsonConverterFromJson<Object, DateTime>(
    json['applicationStartedDate'],
    const DateTimeConverter().fromJson,
  )
  ..rtoVerifiedDate = const DateTimeNullableConverter().fromJson(
    json['rtoVerifiedDate'],
  )
  ..rsaDate = const DateTimeNullableConverter().fromJson(json['rsaDate'])
  ..rsaCompletedDate = const DateTimeNullableConverter().fromJson(
    json['rsaCompletedDate'],
  )
  ..llTestSchedule = const DateTimeNullableConverter().fromJson(
    json['llTestSchedule'],
  )
  ..dlTestSchedule = const DateTimeNullableConverter().fromJson(
    json['dlTestSchedule'],
  )
  ..completedDate = const DateTimeNullableConverter().fromJson(
    json['completedDate'],
  );

Map<String, dynamic> _$LicenseApplicationToJson(
  LicenseApplication instance,
) => <String, dynamic>{
  'id': instance.id,
  'addedOn': const DateTimeNullableConverter().toJson(instance.addedOn),
  'addedBy': instance.addedBy?.toJson(),
  'modifiedOn': const DateTimeNullableConverter().toJson(instance.modifiedOn),
  'modifiedBy': instance.modifiedBy,
  'operationId': instance.operationId,
  'fullName': instance.fullName,
  'applicationNumber': instance.applicationNumber,
  'gender': instance.gender,
  'bloodGroup': instance.bloodGroup,
  'phone': instance.phone,
  'nationality': instance.nationality,
  'selectedRto': instance.selectedRto?.toJson(),
  'rider': instance.rider?.toJson(),
  'dlStatus': _$DLStatusEnumMap[instance.dlStatus]!,
  'haveLicence': instance.isAlreadyHaveLicence,
  'llExpiry': _$JsonConverterToJson<Object, DateTime>(
    instance.llExpiry,
    const DateTimeConverter().toJson,
  ),
  'dob': _$JsonConverterToJson<Object, DateTime>(
    instance.dob,
    const DateTimeConverter().toJson,
  ),
  'rtoPaymentCompletedDate': _$JsonConverterToJson<Object, DateTime>(
    instance.rtoPaymentCompletedDate,
    const DateTimeConverter().toJson,
  ),
  'formFilledDate': _$JsonConverterToJson<Object, DateTime>(
    instance.formFilledDate,
    const DateTimeConverter().toJson,
  ),
  'eyeTestUploadPendingDate': _$JsonConverterToJson<Object, DateTime>(
    instance.eyeTestUploadPendingDate,
    const DateTimeConverter().toJson,
  ),
  'eyeTestUploadCompletedDate': _$JsonConverterToJson<Object, DateTime>(
    instance.eyeTestUploadCompletedDate,
    const DateTimeConverter().toJson,
  ),
  'docsRequestedDate': _$JsonConverterToJson<Object, DateTime>(
    instance.docsRequestedDate,
    const DateTimeConverter().toJson,
  ),
  'docsUploadedDate': _$JsonConverterToJson<Object, DateTime>(
    instance.docsUploadedDate,
    const DateTimeConverter().toJson,
  ),
  'applicationStartedDate': _$JsonConverterToJson<Object, DateTime>(
    instance.applicationStartedDate,
    const DateTimeConverter().toJson,
  ),
  'rtoVerifiedDate': const DateTimeNullableConverter().toJson(
    instance.rtoVerifiedDate,
  ),
  'rsaDate': const DateTimeNullableConverter().toJson(instance.rsaDate),
  'rsaCompletedDate': const DateTimeNullableConverter().toJson(
    instance.rsaCompletedDate,
  ),
  'llTestSchedule': const DateTimeNullableConverter().toJson(
    instance.llTestSchedule,
  ),
  'dlTestSchedule': const DateTimeNullableConverter().toJson(
    instance.dlTestSchedule,
  ),
  'completedDate': const DateTimeNullableConverter().toJson(
    instance.completedDate,
  ),
};

const _$DLStatusEnumMap = {
  DLStatus.none: 'none',
  DLStatus.dlScheduled: 'dlScheduled',
  DLStatus.dlPassed: 'dlPassed',
  DLStatus.dlPartialyPassed: 'dlPartialyPassed',
  DLStatus.dlFailed: 'dlFailed',
  DLStatus.dlNotAttended: 'dlNotAttended',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
