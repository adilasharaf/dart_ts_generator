import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

import 'src/model_analyzer.dart';
import 'src/zod_generator.dart';

class DartTsGenerator extends Generator {
  final Map<String, dynamic> config;

  DartTsGenerator(this.config);

  final _jsonSerializableChecker = TypeChecker.typeNamedLiterally(
    'JsonSerializable',
    inPackage: 'json_annotation',
  );

  final _tsGenerateChecker = TypeChecker.typeNamedLiterally(
    'TsGenerate',
    inPackage: 'dart_ts_generator',
  );

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final tsContent = await generateForLibrary(library.element, buildStep);
    if (tsContent == null || tsContent.trim().isEmpty) return null;

    // ── KEY FIX 1: Write the .g.ts file directly, bypassing source_gen's
    //   Dart formatter entirely. We construct the output AssetId manually
    //   so we control both the extension AND the output directory.
    final outputDir = config['output_dir'] as String? ?? 'lib/generated/ts';

    // e.g. lib/models/ei_user.dart → ei_user
    final baseName = p.basenameWithoutExtension(buildStep.inputId.path);

    final outputId = AssetId(
      buildStep.inputId.package,
      '$outputDir/$baseName.g.ts', // e.g. lib/generated/ts/ei_user.g.ts
    );

    await buildStep.writeAsString(outputId, tsContent);

    // ── KEY FIX 2: Return null so source_gen does NOT try to write or
    //   format anything itself. If we returned a string here, source_gen
    //   would pipe it through `dart format` and write a .g.dart part —
    //   both of which are wrong for TypeScript output.
    return null;
  }

  Future<String?> generateForLibrary(
    LibraryElement library,
    BuildStep buildStep,
  ) async {
    final generatorConfig = GeneratorConfig.fromMap(config);

    final allClasses = _collectClasses(library);
    if (allClasses.isEmpty) return null;

    final knownModelNames = allClasses.map((c) => c.name!).toSet();
    final knownEnumNames = allClasses
        .whereType<EnumElement>()
        .map((c) => c.name!)
        .toSet();

    final analyzer = ModelAnalyzer(
      knownModelNames: knownModelNames,
      knownEnumNames: knownEnumNames,
    );

    final classInfos = <ClassInfo>[];
    for (final cls in allClasses) {
      try {
        if (cls is EnumElement) {
          classInfos.add(_analyzeEnum(cls));
        } else if (cls is ClassElement) {
          if (!_shouldGenerate(cls)) continue;
          classInfos.add(analyzer.analyzeClass(cls));
        }
      } catch (e) {
        log.warning('dart_ts_generator: failed to analyze ${cls.name}: $e');
      }
    }

    if (classInfos.isEmpty) return null;

    final registry = {for (final c in classInfos) c.name!: c};

    final zodGen = ZodSchemaGenerator(
      classRegistry: registry,
      config: generatorConfig,
    );

    return zodGen.generateFile(classInfos);
  }

  List<InterfaceElement> _collectClasses(LibraryElement library) {
    final result = <InterfaceElement>[];
    for (final element in library.children) {
      if (element is EnumElement) result.add(element);
      if (element is ClassElement) result.add(element);
      if (element is MixinElement) result.add(element);
    }
    return result;
  }

  bool _shouldGenerate(ClassElement cls) {
    if (cls.name!.startsWith('_')) return false;
    if (_jsonSerializableChecker.hasAnnotationOf(cls)) return true;
    if (_tsGenerateChecker.hasAnnotationOf(cls)) return true;
    final superName = cls.supertype?.element.name;
    if (superName != null &&
        superName != 'Object' &&
        !superName.startsWith('_')) {
      return true;
    }
    return false;
  }

  ClassInfo _analyzeEnum(EnumElement element) {
    final values = element.fields
        .where((f) => f.isEnumConstant)
        .map((f) => f.name)
        .toList();

    return ClassInfo(
      name: element.name,
      fields: [],
      isEnum: true,
      enumValues: values,
      isAbstract: false,
    );
  }
}
