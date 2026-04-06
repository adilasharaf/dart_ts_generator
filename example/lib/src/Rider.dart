import 'package:json_annotation/json_annotation.dart';

import '../EiModels.dart';

part 'Rider.g.dart';

@JsonSerializable(explicitToJson: true)
class Rider extends EiUser {
  List<Vehicle>? vehicles;
  List<Address>? savedAddresses;
  @JsonKey(defaultValue: 0.0)
  double kmsDriven = 0;
  DriversLicense? driversLicense;
  LicenseApplication? licenseApplication;
  Address? lastBookedAddress;
  @JsonKey(defaultValue: false)
  bool trainInRiderVehicleEnabled = false;
  @JsonKey(defaultValue: [])
  List<String> riderCategories = [];
  String? appVersion;
  int? appBuildNumber;
  Course? course;

  // @Deprecated('Use course instead')
  // Subscription? subscription;

  Rto? selectedRto;

  @DateTimeNullableConverter()
  DateTime? dob;

  Rider();

  factory Rider.fromJson(Map<String, dynamic> json) => _$RiderFromJson(json);

  /// Connect the generated [_$RiderFromJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$RiderToJson(this);

  factory Rider.copy(Rider r) {
    return Rider.fromJson(r.toJson());
  }
}
