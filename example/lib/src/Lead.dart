import 'package:dart_ts_generator_example/EiModels.dart';

import 'package:json_annotation/json_annotation.dart';

part 'Lead.g.dart';

@JsonSerializable(explicitToJson: true)
class Lead extends EiUser {
  String? leadId;
  Rider? rider;

  @DateTimeConverter()
  DateTime? followUpDate;

  @JsonKey(defaultValue: CallStatus.pending)
  CallStatus callStatus = CallStatus.pending;

  @JsonKey(defaultValue: 'Unknown')
  String leadSource = 'Unknown';

  @DateTimeConverter()
  DateTime? dueDate;

  Lead();

  factory Lead.fromJson(Map<String, dynamic> json) => _$LeadFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$LeadToJson(this);

  factory Lead.copy(Lead l) {
    return Lead.fromJson(l.toJson());
  }
}
