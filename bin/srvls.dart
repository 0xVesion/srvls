import 'dart:io';

void main(List<String> args) async {
  final dir = Directory('./functions');

  final functions = await _readFunctions(dir);

  print('Generating server for ${functions.length} functions...');
  final mainFile = File('./srvls.dart');
  await _writeSrc(mainFile, functions);

  print('Compiling...');
  final exePath = await _compile(mainFile);
  print('Successfully built ${File(exePath)}');
}

Future<String> _compile(File mainFile) async {
  final process = await Process.run('dart', ['compile', 'exe', mainFile.path]);
  if (process.exitCode != 0) throw Exception('Error whilst compiling!');
  await mainFile.delete();

  final exePath = mainFile.path.replaceFirst('.dart', '.exe');
  await Process.run('chmod', ['+x', exePath]);
  return exePath;
}

Future _writeSrc(File mainFile, List<FunctionReference> functions) async {
  if (!await mainFile.parent.exists()) await mainFile.parent.create();
  final mainSrc = _renderMain(functions);
  await mainFile.writeAsString(mainSrc);
}

Future<List<FunctionReference>> _readFunctions(Directory dir) async {
  return await dir
      .list(recursive: true)
      .where((e) => e is File)
      .cast<File>()
      .map((e) => FunctionReference(e))
      .toList();
}

String _renderMain(List<FunctionReference> functions) => '''
import 'package:srvls/srvls.dart';
${functions.map((event) => event.import).join('\n')}
  
Future<void> main(List<String> args) => run(args, {
    ${functions.map((e) => "'${e.route}': ${e.id}.handler,").join('\n')}
  });
''';

class FunctionReference {
  final File file;

  FunctionReference(this.file);

  String get route =>
      file.path.replaceFirst('./functions', '').replaceFirst('.dart', '');

  String get id => route.replaceAll('/', '_');

  String get import => "import '${file.absolute.path}' as $id;";
}

//refer()
