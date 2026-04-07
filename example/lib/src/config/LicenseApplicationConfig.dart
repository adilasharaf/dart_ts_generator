import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:json_annotation/json_annotation.dart';

part 'LicenseApplicationConfig.g.dart';

@JsonSerializable(explicitToJson: true)
class LicenseApplicationConfig {

  late LicenceApplicationPriceConfig priceConfig;

  @JsonKey(defaultValue: [])
  List<Rto> serviceableRtos = [];

  @JsonKey(defaultValue: [])
  List<Rto> rsaIncludedRtos = [];


  LicenseApplicationConfig();
  factory LicenseApplicationConfig.fromJson(Map<String, dynamic> json) =>
      _$LicenseApplicationConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseApplicationConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LicenceApplicationPriceConfig {
  //  ll
  @JsonKey(defaultValue: 177)
  double llRetestPrice = 177;

  @JsonKey(defaultValue: 450)
  double llRenewalPrice = 450;

  // dl
  // retest
  @JsonKey(defaultValue: 150)
  double dlScheduleServiceCharge = 150;

  @JsonKey(defaultValue: 300)
  double dlRetestRTOBikePrice = 300;

  @JsonKey(defaultValue: 300)
  double dlRetestRTOCarPrice = 300;

  // vehicle
  @JsonKey(defaultValue: 590)
  double dlTestBikeCharge = 590;

  @JsonKey(defaultValue: 944)
  double dlTestCarCharge = 944;

  @JsonKey(defaultValue: 1298)
  double dlTestBothVehicleCharge = 1298;

  LicenceApplicationPriceConfig();
  factory LicenceApplicationPriceConfig.fromJson(Map<String, dynamic> json) =>
      _$LicenceApplicationPriceConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LicenceApplicationPriceConfigToJson(this);
}
