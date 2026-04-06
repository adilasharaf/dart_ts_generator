import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Booking.g.dart';

@JsonSerializable(explicitToJson: true)
class Booking {
  String id;
  late EiUser bookedBy;
  double? totalAmount;
  double? payableAmount;
  double? effectivePrice;
  String? cancellationNote;
  String? modifiedBy;
  String? operationId;

  @JsonKey(defaultValue: 0.0)
  double pendingAmountCollected = 0.0;

  @JsonKey(defaultValue: 0.0)
  double cancellationCharge = 0.0;

  @DateTimeConverter()
  DateTime? cancelledOn;

  @DateTimeConverter()
  DateTime? bookedOn;

  @DateTimeConverter()
  DateTime? modifiedOn;

  Booking() : id = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Booking && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  factory Booking.copy(Booking booking) => Booking.fromJson(booking.toJson());

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
