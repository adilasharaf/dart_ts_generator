import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:dart_ts_generator_example/src/EiModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PendingPayment.g.dart';

@JsonSerializable(explicitToJson: true)
class PendingPayment extends EiModel {
  String? bookingId;
  String? paymentId;

  @JsonKey(defaultValue: 0)
  double amount = 0;

  PendingPayment();

  factory PendingPayment.fromJson(Map<String, dynamic> json) =>
      _$PendingPaymentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PendingPaymentToJson(this);

  factory PendingPayment.copy(PendingPayment l) {
    return PendingPayment.fromJson(l.toJson());
  }
}
