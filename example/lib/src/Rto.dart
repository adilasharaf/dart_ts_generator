import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Rto.g.dart';

@JsonSerializable(explicitToJson: true)
class Rto {
  late String id;
  String? name;
  Address? address;

  Rto();

  factory Rto.fromJson(Map<String, dynamic> json) => _$RtoFromJson(json);

  Map<String, dynamic> toJson() => _$RtoToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rto && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Rto.copy(Rto r) {
    return Rto.fromJson(r.toJson());
  }
}
