Here’s a clean, professional **README.md** tailored for your Dart → TypeScript (Zod) generator package:

---

# 🚀 Dart TS Generator (Zod)

Generate **TypeScript types** and **Zod schemas** automatically from your Dart models using `build_runner`.

> Perfect for sharing models between Flutter (Dart) and backend/frontend TypeScript projects.

---

## ✨ Features

* 🔄 Convert Dart models → TypeScript interfaces
* 🛡 Generate fully-typed **Zod validation schemas**
* 📦 Supports `@JsonSerializable` models
* 🧠 Detects manual `fromJson` / `toMap` patterns automatically
* 🔗 Cross-file type resolution (imports handled for you)
* 🧬 Enum → `z.enum()` conversion
* 🧩 Handles:

  * Nested models
  * Lists & Maps
  * Nullable fields
  * Default values
  * Inheritance
* 🔁 Circular dependency safe
* ⚙️ Configurable (`DateTime` handling, etc.)

---

## 📂 Output Structure

```bash
lib/src/User.dart          → gen/src/User.g.ts
lib/src/enums/Role.dart   → gen/src/enums/Role.g.ts
```

Then:

```bash
gen/**/*.g.ts → compiled → dist/
```

---

## 📦 Installation

Add to your `dev_dependencies`:

```yaml
dev_dependencies:
  dart_ts_generator:
    git:
      url: https://gitlab.com/ucmonks/eimodels.git
```

Also required:

```yaml
dependencies:
  build_runner: ^2.4.0
```

---

## ⚙️ Configuration

Create or update `build.yaml`:

```yaml
targets:
  $default:
    builders:
      dart_ts_generator:
        options:
          date_time_as_string: true
```

### Options

| Option                | Description                                     | Default |
| --------------------- | ----------------------------------------------- | ------- |
| `date_time_as_string` | Convert `DateTime` → `string` instead of `Date` | `true`  |

---

## ▶️ Usage

Run the generator:

```bash
dart run build_runner build
```

Or watch mode:

```bash
dart run build_runner watch
```

---

## 🧠 Supported Models

### ✅ JsonSerializable

```dart
@JsonSerializable()
class User {
  final String id;
  final String? name;

  User({required this.id, this.name});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

---

### ✅ Manual Serialization (No Annotation Needed)

```dart
class Product {
  final int id;

  Product(this.id);

  static Product fromJson(Map<String, dynamic> json) {
    return Product(json['id']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}
```

---

### ✅ Enum

```dart
enum Status { pending, completed, failed }
```

---

## 🧾 Generated Output Example

```ts
// ── Status (Enum) ──
export const StatusSchema = z.enum(['pending', 'completed', 'failed']);
export type Status = z.infer<typeof StatusSchema>;

// ── User (Type) ──
export interface User {
  id: string;
  name?: string | null;
}

// ── User (Schema) ──
export const UserSchema = z.object({
  id: z.string(),
  name: z.string().nullish(),
});
```

---

## 🏷 Annotations

### `@TsIgnore`

Ignore a field:

```dart
@TsIgnore()
String internalField;
```

---

### `@TsType`

Override TypeScript type:

```dart
@TsType('string | number', zodSchema: 'z.union([z.string(), z.number()])')
dynamic value;
```

---

### `@TsGenerate`

Force generation:

```dart
@TsGenerate()
class CustomModel {}
```

---

### `@TsFirestoreModel`

Adds Firestore-specific handling (e.g. Timestamp).

---

## 🔄 Type Mapping

| Dart       | TypeScript  | Zod                 |
| ---------- | ----------- | ------------------- |
| String     | string      | z.string()          |
| int/double | number      | z.number()          |
| bool       | boolean     | z.boolean()         |
| DateTime   | string/Date | z.string()/z.date() |
| List<T>    | T[]         | z.array()           |
| Map        | Record      | z.record()          |

---

## 🧩 Cross-File Imports

Imports are automatically resolved:

```ts
import { RoleSchema } from '../enums/Role';
```

No manual work needed.

---

## ⚠️ Notes

* `.g.dart` and `.freezed.dart` files are ignored
* Only relevant classes are generated:

  * `@JsonSerializable`
  * Manual serialization (`fromJson` + `toMap`)
  * `@TsGenerate`
* Part files are skipped automatically

---

## 🧪 Development

Run tests:

```bash
dart test
```

---

## 📜 License

MIT License

---

## 💡 Future Improvements

* Better Firestore support
* Custom transformers
* CLI mode (without build_runner)
* Swagger/OpenAPI generation

---
