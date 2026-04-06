import 'package:json_annotation/json_annotation.dart';

part 'AppConfig.g.dart';

@JsonSerializable(explicitToJson: true)
class AppConfig {
  static const double TRAINER_SEARCH_RADIUS = 10.0;
  static const int OTP_TIMEOUT = 90;

  static const List<String> serviceableCities = ['Trivandrum'];

  static const int trainerBookingAcceptTimeOut = 80;
  AppConfig();

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}
