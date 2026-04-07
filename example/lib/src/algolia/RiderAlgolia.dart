// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'RiderAlgolia.g.dart';

class RiderFilter {
  String? searchTerm;
  String? licenseStatus;
  String? licenceVerificationStatus;

  RiderFilter({this.searchTerm});
}

@JsonSerializable(explicitToJson: true)
class RiderAlgolia {
  String? id;
  String? displayName;
  String? phone;
  String? photoUrl;

  @JsonKey(
    name: 'driversLicense.licenceVerificationStatus',
    defaultValue: "unknown",
  )
  String? licenceVerificationStatus;

  RiderAlgolia();

  factory RiderAlgolia.fromJson(Map<String, dynamic> json) =>
      _$RiderAlgoliaFromJson(json);

  factory RiderAlgolia.copy(RiderAlgolia riderAlgolia) =>
      RiderAlgolia.fromJson(riderAlgolia.toJson());

  Map<String, dynamic> toJson() => _$RiderAlgoliaToJson(this);
}
