import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:dart_ts_generator_example/src/EiModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Subscription.g.dart';

@JsonSerializable(explicitToJson: true)
class Subscription extends EiModel {
  @JsonKey(defaultValue: '')
  String name = '';

  @JsonKey(defaultValue: '')
  String description = '';

  double? effectivePriceLmv;

  double? effectivePriceMc;

  @JsonKey(defaultValue: 0)
  int lmvBookingLimit = 0;

  @JsonKey(defaultValue: 0)
  int mcBookingLimit = 0;

  @JsonKey(defaultValue: 0)
  int rtoTestBookingLimit = 0;

  @JsonKey(defaultValue: 0)
  int mockTestBookingLimit = 0;

  @JsonKey(defaultValue: 0)
  int lmvBookingTotal = 0;

  @JsonKey(defaultValue: 0)
  int mcBookingTotal = 0;

  @JsonKey(defaultValue: 0)
  int rtoTestBookingTotal = 0;

  @JsonKey(defaultValue: 0)
  int mockTestBookingTotal = 0;

  @DateTimeConverter()
  DateTime? startDate;

  @DateTimeConverter()
  DateTime? endDate;

  @JsonKey(defaultValue: 0)
  double amount = 0;

  @JsonKey(defaultValue: 0)
  double gst = 0;

  // @JsonKey(defaultValue: PaymentStatus.none)
  // PaymentStatus paymentStatus = PaymentStatus.none;

  Subscription();

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Subscription.copy(Subscription r) {
    return Subscription.fromJson(r.toJson());
  }
}
