import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

export 'package:shelf/shelf.dart';

extension SrvlsRequest on Request {
  Future<dynamic> readAsJson() async => jsonDecode(await readAsString());
}

Future<void> run(
  List<String> args,
  Map<String, Function> routeHandlerMap,
) async {
  final router = Router();

  print('Starting...');

  routeHandlerMap.forEach((route, handler) {
    print('Adding $route');
    router.all(route, handler);
  });

  final server = await io.serve(router, 'localhost', 8080);
  print('Server running on port ${server.port}!');
}
