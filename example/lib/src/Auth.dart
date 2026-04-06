import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Auth.g.dart';

@JsonSerializable(explicitToJson: true)
class Auth extends EiUser {
  String? roleType;

  @JsonKey(defaultValue: [])
  List<String> userRoles = [];

  Auth();

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthToJson(this);

  factory Auth.copy(Auth r) {
    return Auth.fromJson(r.toJson());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Auth &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
