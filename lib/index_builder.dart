// lib/index_builder.dart
//
// Generates lib/gen/eimodels.g.ts — a single barrel file that re-exports
// every .g.ts schema produced by _TsFileBuilder under lib/gen/.
//
// Consumers of the npm / git package get one clean import:
//
//   import { VehicleSchema, DLStatus } from 'eimodels';
//
// TSC compiles lib/gen/ → dist/, so the barrel becomes dist/eimodels.g.js
// which package.json points at via "main" / "exports".
//
// ── Potential name conflict ───────────────────────────────────────────────────
// If two source files export a symbol with the same name, TypeScript raises:
//   "Module X has already exported a member named Y."
// This surfaces at `npm run build` (tsc), not at dart build_runner time.
// Fix by renaming the Dart class, or by manually editing the generated barrel
// to use aliased re-exports:  export { Foo as OtherFoo } from './...';

import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

Builder tsIndexBuilder(BuilderOptions options) => _TsIndexBuilder(options);

class _TsIndexBuilder implements Builder {
  final BuilderOptions _options;
  _TsIndexBuilder(this._options);

  @override
  Map<String, List<String>> get buildExtensions => const {
    r'$lib$': ['gen/eimodels.g.ts'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Collect all .g.ts files under lib/gen/, excluding the barrel itself
    // to avoid a circular self-referencing export.
    final glob = Glob('lib/gen/**.g.ts');
    final assets =
        (await buildStep.findAssets(glob).toList())
            .where((a) => !a.path.endsWith('eimodels.g.ts'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    if (assets.isEmpty) return;

    // Barrel lives at lib/gen/eimodels.g.ts — all relative paths from there.
    const barrelDir = 'lib/gen';

    final exportLines = assets.map((asset) {
      var rel = p.posix.relative(asset.path, from: barrelDir);
      if (rel.endsWith('.ts')) rel = rel.substring(0, rel.length - 3);
      if (!rel.startsWith('.')) rel = './$rel';
      return "export * from '$rel';";
    });

    // FIX: Use buildStep.allowedOutputs.single instead of constructing the
    // AssetId manually. build_runner pre-computes the correct output AssetId
    // from the buildExtensions map, so using it avoids any path mismatch and
    // ensures the write is pre-approved (no UnexpectedOutputException).
    final outputId = buildStep.allowedOutputs.single;

    final content = [
      '// AUTO-GENERATED — DO NOT EDIT.',
      '// Single barrel — re-exports all Zod schemas generated from Dart models.',
      '//',
      '// Usage:',
      '//   import { VehicleSchema, Vehicle, DLStatus } from "eimodels";',
      '',
      ...exportLines,
      '',
    ].join('\n');

    await buildStep.writeAsString(outputId, content);
  }
}
