import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:dart_ts_generator_example/src/EiModel.dart';
import 'package:json_annotation/json_annotation.dart';

part "Course.g.dart";

@JsonSerializable(explicitToJson: true)
class Course extends EiModel {
  String? name;
  String? description;

  @JsonKey(defaultValue: CourseStatus.none)
  CourseStatus status = CourseStatus.none;

  @JsonKey(defaultValue: 0)
  double serviceCharge = 0;

  @JsonKey(defaultValue: 0)
  double rtoFee = 0;

  @JsonKey(defaultValue: 0)
  double gst = 0;

  @JsonKey(defaultValue: [])
  List<Subscription> subscriptions = [];

  @DateTimeConverter()
  DateTime? dueDate;

  Course();

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CourseToJson(this);

  factory Course.copy(Course r) {
    return Course.fromJson(r.toJson());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
