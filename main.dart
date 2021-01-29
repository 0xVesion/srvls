import 'package:srvls/srvls.dart';
import '/Users/vesion/projects/srvls/./functions/forms/save.dart'
    as _forms_save;

Future<void> main(List<String> args) => run({
      '/forms/save': _forms_save.handler,
    });
