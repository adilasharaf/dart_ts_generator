import 'package:json_annotation/json_annotation.dart';

part 'AccountConfig.g.dart';

@JsonSerializable(explicitToJson: true)
class AccountConfig {
  List<String>? incomeTypes;
  List<String>? expenseTypes;
  double? lastUpdatedInvoiceNo;
  double? lastUpdatedCreditNoteNo;

  @JsonKey(defaultValue: [])
  List<String> vehicleRelatedCategories = [];

  @JsonKey(defaultValue: [])
  List<String> franchiseRelatedCategories = [];

  @JsonKey(defaultValue: [])
  List<String> trainerRelatedCategories = [];

  AccountConfig();
  factory AccountConfig.fromJson(Map<String, dynamic> json) =>
      _$AccountConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AccountConfigToJson(this);
}
