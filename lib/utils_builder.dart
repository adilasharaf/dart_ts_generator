// lib/utils_builder.dart
import 'dart:async';
import 'package:build/build.dart';

Builder tsUtilsBuilder(BuilderOptions options) => _TsUtilsBuilder(options);

class _TsUtilsBuilder implements Builder {
  final BuilderOptions options;
  _TsUtilsBuilder(this.options);

  @override
  Map<String, List<String>> get buildExtensions => const {
    r'$package$': ['gen/utils/converters.g.ts'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final outputId = buildStep.allowedOutputs.single;

    final content = '''
// AUTO-GENERATED — DO NOT EDIT.
import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';

export const dateTimeTransform = z.union([
  z.date(),
  z.number(),
  z.string(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  if (typeof val === 'string') return new Date(val);
  return val.toDate();
});

export const phoneTransform = z.union([z.string(), z.number()]).transform((val) => {
  if (!val) return "";
  const phone = String(val).replace(/\\D/g, "");
  if (phone.length === 10) return `+91\${phone}`;
  if (phone.length === 12 && phone.startsWith("91")) return `+\${phone}`;
  if (phone.length === 11 && phone.startsWith("0")) return `+91\${phone.slice(1)}`;
  return phone;
});

export const phoneTransformNullable = z.union([z.string(), z.number()]).nullish().transform((val) => {
  if (!val) return null;
  const phone = String(val).replace(/\\D/g, "");
  if (phone.length === 10) return `+91\${phone}`;
  if (phone.length === 12 && phone.startsWith("91")) return `+\${phone}`;
  if (phone.length === 11 && phone.startsWith("0")) return `+91\${phone.slice(1)}`;
  return phone;
});

export const displayNameTransform = z.string().transform((val) => {
  if (!val || !val.trim()) return "";
  return val.trim().toLowerCase().split(/\\s+/).map((word) => word.charAt(0).toUpperCase() + word.slice(1)).join(" ");
});

export const displayNameTransformNullable = z.string().nullish().transform((val) => {
  if (!val || !val.trim()) return null;
  return val.trim().toLowerCase().split(/\\s+/).map((word) => word.charAt(0).toUpperCase() + word.slice(1)).join(" ");
});

export const flattenObject = (obj: any, prefix = ""): any => {
  if (obj === null || typeof obj !== "object" || obj instanceof Date || (obj.constructor && obj.constructor.name === "Timestamp")) return obj;
  return Object.keys(obj).reduce((acc: any, k: string) => {
    const pre = prefix.length ? prefix + "." : "";
    if (typeof obj[k] === "object" && obj[k] !== null && !Array.isArray(obj[k]) && !(obj[k] instanceof Date) && !(obj[k].constructor && obj[k].constructor.name === "Timestamp")) {
      Object.assign(acc, flattenObject(obj[k], pre + k));
    } else {
      acc[pre + k] = obj[k];
    }
    return acc;
  }, {});
};
''';

    await buildStep.writeAsString(outputId, content.trim() + '\n');
  }
}
