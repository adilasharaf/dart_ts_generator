import 'package:dart_ts_generator_example/src/utils/JsonConverter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DriversLicense.g.dart';

@JsonSerializable(explicitToJson: true)
class DriversLicense {
  String id;
  String? name;
  String? fileName;
  String? licenceNumber;
  @DateTimeConverter()
  DateTime? licenceDate;
  @DateTimeConverter()
  DateTime? licenceExpiry;
  @DateTimeConverter()
  DateTime? learnersDate;
  @DateTimeConverter()
  DateTime? learnersExpiry;
  String? frontUrl;
  String? backUrl;
  String? learnersUrl;
  String? licenceUrl;

  DriversLicense() : id = DateTime.now().microsecondsSinceEpoch.toString();

  factory DriversLicense.fromJson(Map<String, dynamic> json) =>
      _$DriversLicenseFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DriversLicenseToJson(this);

  factory DriversLicense.copy(DriversLicense r) {
    return DriversLicense.fromJson(r.toJson());
  }
}
