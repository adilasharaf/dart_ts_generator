import 'package:dart_ts_generator_example/EiModels.dart';
import 'package:json_annotation/json_annotation.dart';

part 'EiModel.g.dart';

@JsonSerializable()
class EiModel {
  String id;
  @DateTimeNullableConverter()
  DateTime? addedOn;

  EiUser? addedBy;

  @DateTimeNullableConverter()
  DateTime? modifiedOn;

  String? modifiedBy;

  String? operationId;

  EiModel()
    : id = DateTime.now().microsecondsSinceEpoch.toString(),
      addedOn = DateTime.now();

  factory EiModel.fromJson(Map<String, dynamic> json) =>
      _$EiModelFromJson(json);

  Map<String, dynamic> toJson() => _$EiModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EiModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
