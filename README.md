# dart_ts_generator

A production-ready Dart `build_runner` package that generates **TypeScript types and Zod schemas** from Dart models annotated with `json_serializable`.

| Feature                                              | Status                               |
| ---------------------------------------------------- | ------------------------------------ |
| Custom JsonConverter (DateTime, Timestamp, GeoPoint) | ✅ with `.transform()`               |
| `@JsonKey` defaults & field name overrides           | ✅                                   |
| Inheritance (`extends`) → Zod `.extend()`            | ✅ topologically sorted              |
| Nullable fields                                      | ✅ `.optional()`                     |
| Enums → `z.enum()`                                   | ✅                                   |
| Nested model references                              | ✅ schema name refs                  |
| Lists with converters                                | ✅ `z.array(z.any().transform(...))` |
| `@TsIgnore`                                          | ✅ field omitted                     |
| Custom `fromJson`/`toJson`                           | ✅ → `z.any()`                       |
| Cross-file imports (multi-file projects)             | ✅ auto relative imports             |
| Index barrel (`index.ts`)                            | ✅ auto-generated                    |
| Standalone CLI (no build_runner)                     | ✅ `dart_ts_gen`                     |
| Constructor default extraction                       | ✅ via source text parsing           |

---

## Installation

```yaml
# pubspec.yaml
dev_dependencies:
  build_runner: ^2.4.9
  dart_ts_generator:
    git:
      url: https://github.com/yourorg/dart_ts_generator
    # OR locally:
    # path: ../dart_ts_generator
```

---

## Option A — build_runner

Configure `build.yaml` in your project:

```yaml
targets:
  $default:
    builders:
      dart_ts_generator:dart_ts_generator:
        enabled: true
        generate_for:
          include:
            - lib/models/**
        options:
          output_dir: "gen/erated/ts"
          generate_index: true
          zod_import: "zod"
          firestore_transforms: true
```

```bash
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch   # watch mode
```

---

## Option B — Standalone CLI

```bash
# Single file
dart run dart_ts_generator:dart_ts_gen lib/models/ei_user.dart

# Entire directory (recursive)
dart run dart_ts_generator:dart_ts_gen -o src/generated/types lib/models/

# Custom Zod import (monorepo)
dart run dart_ts_generator:dart_ts_gen --zod-import @myapp/zod lib/models/

# Watch mode
dart run dart_ts_generator:dart_ts_gen --watch lib/models/

# Flags: --no-index  --verbose/-v  --help/-h
```

The CLI runs a two-phase analysis pass, which means it correctly emits cross-file
`import` statements even between unrelated files.

---

## Multi-file Output

Given:

```
lib/models/
  ei_base.dart       ← EiModel, EiAddress, EiAppSource, EiUserRole, EiRideStatus
  ei_user.dart       ← EiUser extends EiModel
  ei_ride.dart       ← EiRide extends EiModel
```

Generates:

```
gen/erated/ts/
  ei_base.g.ts
  ei_user.g.ts       ← imports EiModelSchema from './ei_base.g'
  ei_ride.g.ts       ← imports EiModelSchema from './ei_base.g'
  index.ts           ← export * from all files
```

---

## Feature Examples

### Enums

```dart
enum EiAppSource { admin, user, other }
```

```ts
export const EiAppSourceSchema = z.enum(["admin", "user", "other"]);
export type EiAppSource = z.infer<typeof EiAppSourceSchema>;
```

### DateTimeNullableConverter

```dart
@DateTimeNullableConverter()
DateTime? addedOn;
```

```ts
added_on:
  z.any().transform((val) =>
    val?.toDate ? val.toDate() : typeof val === "number" ? new Date(val) : null
  ).optional(),
```

### @JsonKey defaults

```dart
@JsonKey(defaultValue: EiAppSource.other)
EiAppSource lastModifiedAppSource;

@JsonKey(defaultValue: 0.0)
double rating;

@JsonKey(name: 'rider_categories', defaultValue: [])
List<String> riderCategories;
```

```ts
lastModifiedAppSource: EiAppSourceSchema.default("other"),
rating: z.number().default(0),
rider_categories: z.array(z.string()).default([]),
```

### Inheritance (cross-file imports auto-generated)

```dart
class EiUser extends EiModel { ... }
```

```ts
import { EiModelSchema, EiAddressSchema, EiUserRoleSchema } from "./ei_base.g";

export const EiUserSchema = EiModelSchema.extend({
  user_id: z.string().optional(),
  role: EiUserRoleSchema.default("rider"),
  address: EiAddressSchema.optional(),
  geoPoint: z.any().optional(), // custom fromJson/toJson
  // internalCache → @TsIgnore, omitted
});
export type EiUser = z.infer<typeof EiUserSchema>;
```

### List with Converter

```dart
@DateTimeListConverter()
@JsonKey(name: 'checkpoint_times', defaultValue: [])
List<DateTime> checkpointTimes;
```

```ts
checkpoint_times:
  z.array(
    z.any().transform((val) =>
      val?.toDate ? val.toDate() : typeof val === "number" ? new Date(val) : val
    )
  ).default([]),
```

### @TsIgnore

```dart
@TsIgnore()
String? internalCache;
```

→ Completely absent from generated output.

---

## Built-in Converter Mappings

Matching is **substring, case-insensitive** on the converter class name:

| Matches                          | Zod transform                                      |
| -------------------------------- | -------------------------------------------------- |
| `*DateTimeConverter*`            | `val?.toDate ? val.toDate() : new Date(val)`       |
| `*DateTimeNullable*`             | Same but returns `null` instead of Date on failure |
| `*DateTimeList*`                 | Wraps in `z.array(z.any().transform(...))`         |
| `*Timestamp*`                    | Same as DateTimeConverter                          |
| Anything else with `*Converter*` | `z.any()` opaque fallback                          |

---

## Firestore Type Handling

| Dart type           | Zod                                           |
| ------------------- | --------------------------------------------- |
| `Timestamp`         | `z.any().transform(val => val?.toDate ? ...)` |
| `GeoPoint`          | `z.any()`                                     |
| `DocumentReference` | `z.any()`                                     |
| `FieldValue`        | `z.any()`                                     |

---

## Architecture

```
dart_ts_generator/
├── bin/dart_ts_gen.dart              ← Standalone CLI
├── lib/
│   ├── dart_ts_generator.dart        ← Barrel export
│   ├── builder.dart                  ← build_runner factory
│   ├── generator.dart                ← source_gen Generator impl
│   ├── index_builder.dart            ← Aggregating index.ts builder
│   └── src/
│       ├── annotations.dart          ← @TsIgnore, @TsType, @TsGenerate
│       ├── cross_file_registry.dart  ← Type→file map + import generation
│       ├── model_analyzer.dart       ← AST → ClassInfo/FieldInfo
│       ├── source_parser.dart        ← Source text → constructor defaults
│       ├── type_mapping.dart         ← Dart type → Zod schema string
│       └── zod_generator.dart        ← ClassInfo[] → .ts string
├── build.yaml
├── pubspec.yaml
└── test/generator_test.dart          ← 35+ unit tests
```

### Pipeline

```
.dart files
    ↓ Phase 1: Analysis
ModelAnalyzer (per class)
  ├─ @TsIgnore → skip field
  ├─ @JsonKey → name, defaultValue, fromJson/toJson
  ├─ Converter annotation → substring match to known transforms
  ├─ Type resolution → primitive / List / Map / enum / model / Firestore
  ├─ Nullability → NullabilitySuffix
  └─ Constructor defaults → SourceParser (regex on source text)
CrossFileRegistry → maps typeName → outputFile
    ↓ Phase 2: Generation
ZodSchemaGenerator (per output file)
  ├─ Topological sort (parent before child)
  ├─ Cross-file import header
  ├─ Enums → z.enum([...])
  └─ Models → z.object({}) or ParentSchema.extend({})
        ├─ converter → z.any().transform(...)
        ├─ nullable → .optional()
        ├─ default → .default(value)
        └─ list/map → z.array / z.record
    ↓ Phase 3: Write
.g.ts files + index.ts
```

---

## Tests

```bash
dart pub get
dart test
```

Covers: all primitive mappings, nullable/default combos, all converter types,
topological sort (including 3-level chains), cross-file imports, source parser,
index barrel generation, and config parsing.

---

## Limitations

1. **Complex constructor defaults** (e.g. `= MyClass.instance()`) are not extracted. Use `@JsonKey(defaultValue: ...)` for those.
2. **Generic converters** (`MyConverter<T>`) map to `z.any()` — add to `TypeMapping.knownConverters` for custom transforms.
3. **Cross-file imports in build_runner mode**: The `build_runner` path processes libraries one at a time. For full cross-file import generation use the CLI which does a two-phase pass.
