import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'Address.g.dart';

@JsonSerializable()
class Address {
  String id;
  String? line1;
  String? line2;
  String? city;
  String? district;
  String? state;
  String? pin;
  double? latitude;
  double? longitude;
  String? savedAs;
  String? fullAddress;
  String? geoHash = 't9w8t';
  @JsonKey(fromJson: _fromJsonGeoPoint, toJson: _toJsonGeoPoint)
  GeoPoint? geoPoint;

  Address() : id = DateTime.now().microsecondsSinceEpoch.toString();

  String get name => fullAddress?.split(',').first ?? '';

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  factory Address.copy(Address address) => Address.fromJson(address.toJson());

  static GeoPoint? _fromJsonGeoPoint(GeoPoint? geoPoint) {
    return geoPoint;
  }

  static GeoPoint? _toJsonGeoPoint(GeoPoint? geoPoint) {
    return geoPoint;
  }
}
