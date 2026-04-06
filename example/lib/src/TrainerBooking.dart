import 'package:dart_ts_generator_example/EiModels.dart';

import 'package:json_annotation/json_annotation.dart';
part 'TrainerBooking.g.dart';

@JsonSerializable(explicitToJson: true)
class TrainerBooking extends Booking {
  double? totalAmountPerKm;
  double? payableAmountPerKm;
  double? minPayableAmount;
  double? maxPayableAmount;
  Address? pickupLocation;
  Address? dropLocation;
  @DateTimeConverter()
  DateTime? pickTime;
  List<Rider>? riders;
  Vehicle? vehicle;
  // Payment? payment;

  double getTotalDiscount() {
    return (totalAmount ?? 0) - (payableAmount ?? 0);
  }

  TrainerBooking();

  factory TrainerBooking.copy(TrainerBooking booking) {
    return TrainerBooking.fromJson(booking.toJson());
  }

  factory TrainerBooking.fromJson(Map<String, dynamic> data) =>
      _$TrainerBookingFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$TrainerBookingToJson(this);
}
