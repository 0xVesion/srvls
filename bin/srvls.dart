import 'dart:io';

import 'dart:isolate';

import 'package:srvls/srvls.dart';

Future<void> main(List<String> arguments) async {
  final functionsDir = Directory('./functions');

  await functionsDir
      .list(recursive: true)
      .where((event) => event is File)
      .forEach((element) {
    print(element);
  });

  await schmain();
}

Future<void> schmain() async {
  final receiverPort = ReceivePort();
  final receiveStream = receiverPort.asBroadcastStream();

  await Isolate.spawnUri(
    Uri.parse('../functions/forms/save.dart'),
    [],
    receiverPort.sendPort,
  );

  final sendPort = await receiveStream.first as SendPort;

  final rawRequest = Request(
    path: '/forms/save',
    json: {'name': 'World'},
  ).toJson();

  sendPort.send(rawRequest);

  await receiveStream.listen((dynamic rawResponse) {
    final response = Response.fromJson(rawResponse as Map<String, dynamic>);
    print(response.toJson());
  });
}
