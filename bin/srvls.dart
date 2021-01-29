import 'dart:io';

import 'dart:isolate';

import 'package:srvls/srvls.dart';

Future<void> main() async {
  print('Starting...');
  final handler = await HandlerIsolate.init(
      File('./functions/forms/save.dart').absolute.path);

  final response = await handler.request(Request(
    path: '/forms/save',
    json: {'name': 'World'},
  ));

  print(response.toJson());
}

class HandlerIsolate {
  ReceivePort receiverPort;

  Stream<dynamic> receiveStream;

  SendPort sendPort;

  HandlerIsolate._();

  static Future<HandlerIsolate> init(String path) async {
    final handler = HandlerIsolate._();
    await handler._init(path);

    return handler;
  }

  Future<void> _init(String path) async {
    receiverPort = ReceivePort();
    receiveStream = receiverPort.asBroadcastStream();

    await Isolate.spawnUri(
      Uri.parse(path),
      [],
      receiverPort.sendPort,
    );

    sendPort = await receiveStream.first as SendPort;
  }

  Future<Response> request(Request request) async {
    sendPort.send(request.toJson());

    final rawResponse = await receiveStream.first as Map<String, dynamic>;
    return Response.fromJson(rawResponse);
  }
}
