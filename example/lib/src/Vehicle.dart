import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:dart_ts_generator_example/src/EiModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Vehicle.g.dart';

@JsonSerializable(explicitToJson: true)
class Vehicle extends EiModel {
  late String make;
  late String model;
  int? year;
  late String imageUrl;
  String? savedAs;
  int? kmsDriven;
  String? vehicleNumber;
  String? variant;
  String? makeCountry;
  @JsonKey(defaultValue: 1.0)
  double priceFactor = 1.0;
  String? assignedTrainerId;
  int? capacity;
  @JsonKey(defaultValue: true)
  bool isPickupAvailable = true;

  Vehicle();

  factory Vehicle.copy(Vehicle vehicle) {
    return Vehicle.fromJson(vehicle.toJson());
  }

  factory Vehicle.fromJson(Map<String, dynamic> data) =>
      _$VehicleFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
