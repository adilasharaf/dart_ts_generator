import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:dart_ts_generator_example/src/EiModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'LicenseApplication.g.dart';

@JsonSerializable(explicitToJson: true)
class LicenseApplication extends EiModel {
  String? fullName;
  String? applicationNumber;
  String? gender;
  String? bloodGroup;
  String? phone;
  String? nationality;

  // @Deprecated("use selectedRto insead")
  // String? rto;

  Rto? selectedRto;

  Rider? rider;

  @JsonKey(defaultValue: DLStatus.none)
  DLStatus dlStatus = DLStatus.none;

  @JsonKey(defaultValue: false ,name: 'haveLicence')
  bool isAlreadyHaveLicence = false;

  @DateTimeConverter()
  DateTime? llExpiry;

  @DateTimeConverter()
  DateTime? dob;

  @DateTimeConverter()
  DateTime? rtoPaymentCompletedDate;

  @DateTimeConverter()
  DateTime? formFilledDate;

  @DateTimeConverter()
  DateTime? eyeTestUploadPendingDate;

  @DateTimeConverter()
  DateTime? eyeTestUploadCompletedDate;

  @DateTimeConverter()
  DateTime? docsRequestedDate;

  @DateTimeConverter()
  DateTime? docsUploadedDate;

  @DateTimeConverter()
  DateTime? applicationStartedDate;

  // @DateTimeConverter()
  // DateTime? appliedDate;

  @DateTimeNullableConverter()
  DateTime? rtoVerifiedDate;

  @DateTimeNullableConverter()
  DateTime? rsaDate;

  @DateTimeNullableConverter()
  DateTime? rsaCompletedDate;

  @DateTimeNullableConverter()
  DateTime? llTestSchedule;

  @DateTimeNullableConverter()
  DateTime? dlTestSchedule;

  @DateTimeNullableConverter()
  DateTime? completedDate;

  LicenseApplication();

  factory LicenseApplication.fromJson(Map<String, dynamic> json) =>
      _$LicenseApplicationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LicenseApplicationToJson(this);

  factory LicenseApplication.copy(LicenseApplication r) {
    return LicenseApplication.fromJson(r.toJson());
  }
}
