import 'package:json_annotation/json_annotation.dart';

class PhoneConverter implements JsonConverter<String, dynamic> {
  const PhoneConverter();

  @override
  String fromJson(dynamic json) {
    if (json == null) return '';
    final phone = json.toString();
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '+91$digits';
    }

    if (digits.length == 12 && digits.startsWith('91')) {
      return '+$digits';
    }

    if (digits.length == 11 && digits.startsWith('0')) {
      return '+91${digits.substring(1)}';
    }

    return '';
  }

  @override
  dynamic toJson(String object) => object;
}

class NullablePhoneConverter implements JsonConverter<String?, dynamic> {
  const NullablePhoneConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    final phone = json.toString();
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '+91$digits';
    }

    if (digits.length == 12 && digits.startsWith('91')) {
      return '+$digits';
    }

    if (digits.length == 11 && digits.startsWith('0')) {
      return '+91${digits.substring(1)}';
    }

    return null;
  }

  @override
  dynamic toJson(String? object) => object;
}
