import 'package:json_annotation/json_annotation.dart';

part 'AuthConfig.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthConfig {
  @JsonKey(defaultValue: [])
  List<String?> admin = [];

  @JsonKey(defaultValue: [])
  List<String?> franchise = [];

  AuthConfig();
  factory AuthConfig.fromJson(Map<String, dynamic> json) =>
      _$AuthConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AuthConfigToJson(this);
}
