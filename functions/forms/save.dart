import 'dart:isolate';

import 'package:srvls/srvls.dart';

Future<void> main(List<String> args, SendPort sendPort) =>
    srvls(args, sendPort, (req) {
      return Response.ok(json: {'hello': 'world'});
    });
