import 'package:dart_ts_generator_example/src/EiModel.dart';
import 'package:json_annotation/json_annotation.dart';

import '../EiModels.dart';

part 'EiUser.g.dart';

@JsonSerializable(explicitToJson: true)
class EiUser extends EiModel {
  String? userId;
  String? email;
  String? photoUrl;
  Address? address;
  Address? currentLocation;
  String? gender;
  String? bloodGroup;

  @NullablePhoneConverter()
  String? phone;

  @NullableDisplayNameConverter()
  String? displayName;

  @JsonKey(defaultValue: 0.0)
  @Deprecated("Use pendingPayments instead.")
  double pendingAmount = 0;

  @JsonKey(defaultValue: [])
  List<String> deviceTokens = [];

  @JsonKey(defaultValue: false)
  bool? isDeleted = false;

  @DateTimeNullableConverter()
  DateTime? deletedOn;

  EiUser();

  factory EiUser.fromJson(Map<String, dynamic> json) => _$EiUserFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$EiUserToJson(this);

  factory EiUser.copy(EiUser r) {
    return EiUser.fromJson(r.toJson());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EiUser &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
