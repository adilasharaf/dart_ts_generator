// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AccountConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountConfig _$AccountConfigFromJson(Map<String, dynamic> json) =>
    AccountConfig()
      ..incomeTypes = (json['incomeTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..expenseTypes = (json['expenseTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..lastUpdatedInvoiceNo = (json['lastUpdatedInvoiceNo'] as num?)
          ?.toDouble()
      ..lastUpdatedCreditNoteNo = (json['lastUpdatedCreditNoteNo'] as num?)
          ?.toDouble()
      ..vehicleRelatedCategories =
          (json['vehicleRelatedCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          []
      ..franchiseRelatedCategories =
          (json['franchiseRelatedCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          []
      ..trainerRelatedCategories =
          (json['trainerRelatedCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [];

Map<String, dynamic> _$AccountConfigToJson(AccountConfig instance) =>
    <String, dynamic>{
      'incomeTypes': instance.incomeTypes,
      'expenseTypes': instance.expenseTypes,
      'lastUpdatedInvoiceNo': instance.lastUpdatedInvoiceNo,
      'lastUpdatedCreditNoteNo': instance.lastUpdatedCreditNoteNo,
      'vehicleRelatedCategories': instance.vehicleRelatedCategories,
      'franchiseRelatedCategories': instance.franchiseRelatedCategories,
      'trainerRelatedCategories': instance.trainerRelatedCategories,
    };
