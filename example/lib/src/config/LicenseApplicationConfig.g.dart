// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LicenseApplicationConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicenseApplicationConfig _$LicenseApplicationConfigFromJson(
  Map<String, dynamic> json,
) => LicenseApplicationConfig()
  ..priceConfig = LicenceApplicationPriceConfig.fromJson(
    json['priceConfig'] as Map<String, dynamic>,
  )
  ..serviceableRtos =
      (json['serviceableRtos'] as List<dynamic>?)
          ?.map((e) => Rto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..rsaIncludedRtos =
      (json['rsaIncludedRtos'] as List<dynamic>?)
          ?.map((e) => Rto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [];

Map<String, dynamic> _$LicenseApplicationConfigToJson(
  LicenseApplicationConfig instance,
) => <String, dynamic>{
  'priceConfig': instance.priceConfig.toJson(),
  'serviceableRtos': instance.serviceableRtos.map((e) => e.toJson()).toList(),
  'rsaIncludedRtos': instance.rsaIncludedRtos.map((e) => e.toJson()).toList(),
};

LicenceApplicationPriceConfig _$LicenceApplicationPriceConfigFromJson(
  Map<String, dynamic> json,
) => LicenceApplicationPriceConfig()
  ..llRetestPrice = (json['llRetestPrice'] as num?)?.toDouble() ?? 177
  ..llRenewalPrice = (json['llRenewalPrice'] as num?)?.toDouble() ?? 450
  ..dlScheduleServiceCharge =
      (json['dlScheduleServiceCharge'] as num?)?.toDouble() ?? 150
  ..dlRetestRTOBikePrice =
      (json['dlRetestRTOBikePrice'] as num?)?.toDouble() ?? 300
  ..dlRetestRTOCarPrice =
      (json['dlRetestRTOCarPrice'] as num?)?.toDouble() ?? 300
  ..dlTestBikeCharge = (json['dlTestBikeCharge'] as num?)?.toDouble() ?? 590
  ..dlTestCarCharge = (json['dlTestCarCharge'] as num?)?.toDouble() ?? 944
  ..dlTestBothVehicleCharge =
      (json['dlTestBothVehicleCharge'] as num?)?.toDouble() ?? 1298;

Map<String, dynamic> _$LicenceApplicationPriceConfigToJson(
  LicenceApplicationPriceConfig instance,
) => <String, dynamic>{
  'llRetestPrice': instance.llRetestPrice,
  'llRenewalPrice': instance.llRenewalPrice,
  'dlScheduleServiceCharge': instance.dlScheduleServiceCharge,
  'dlRetestRTOBikePrice': instance.dlRetestRTOBikePrice,
  'dlRetestRTOCarPrice': instance.dlRetestRTOCarPrice,
  'dlTestBikeCharge': instance.dlTestBikeCharge,
  'dlTestCarCharge': instance.dlTestCarCharge,
  'dlTestBothVehicleCharge': instance.dlTestBothVehicleCharge,
};
