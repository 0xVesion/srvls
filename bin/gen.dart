import 'dart:io';

import '/Users/vesion/projects/srvls/functions/forms/save.dart' as _forms_save;

void main() {
  final dir = Directory(Directory.current.absolute.path + '/functions');

  dir.list(recursive: true).where((e) => e is File).cast<File>().forEach((e) {
    final route = e.path.replaceFirst(dir.path, '').replaceFirst('.dart', '');
    final id = route.replaceAll('/', '_');

    print("import '${e.path}' as $id;");
    print(_forms_save.main);
  });
}
//refer()
