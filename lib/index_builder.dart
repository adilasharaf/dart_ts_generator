// lib/index_builder.dart
//
// Generates gen/eimodels.g.ts — a single barrel file that re-exports
// every .g.ts schema produced by _TsFileBuilder under gen/.
//
// Consumers of the npm / git package get one clean import:
//
//   import { VehicleSchema, DLStatus } from 'eimodels';
//
// TSC compiles gen/ → dist/, so the barrel becomes dist/eimodels.g.js
// which package.json points at via "main" / "exports".
//
// ── Why $package$ and not $lib$ ──────────────────────────────────────────────
// $lib$ is a synthetic anchor whose outputs must live inside lib/.
// Since eimodels.g.ts now lives at the root gen/ folder (outside lib/),
// we use $package$ instead — its outputs may be anywhere in the package.
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

  // FIX 1: Use $package$ (not $lib$) so build_runner allows outputs
  // outside lib/. The declared output gen/eimodels.g.ts sits at the
  // package root, not inside lib/, so $lib$ would reject it.
  @override
  Map<String, List<String>> get buildExtensions => const {
    r'$package$': ['gen/eimodels.g.ts'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Collect all .g.ts files under gen/, excluding the barrel itself
    // to avoid a circular self-referencing export.
    final glob = Glob('gen/**.g.ts');
    final assets =
        (await buildStep.findAssets(glob).toList())
            .where((a) => !a.path.endsWith('eimodels.g.ts'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    if (assets.isEmpty) return;

    // FIX 2: barrelDir must match where eimodels.g.ts actually lives.
    // All relative export paths are computed from this directory.
    const barrelDir = 'gen';

    final exportLines = assets.map((asset) {
      var rel = p.posix.relative(asset.path, from: barrelDir);
      if (rel.endsWith('.ts')) rel = rel.substring(0, rel.length - 3);
      if (!rel.startsWith('.')) rel = './$rel';
      return "export * from '$rel';";
    });

    // allowedOutputs.single is the AssetId build_runner pre-computed from
    // the $package$ buildExtensions entry — always use this instead of
    // constructing AssetId manually.
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
