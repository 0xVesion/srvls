import 'dart:async';
import 'dart:convert';
import 'dart:io';

typedef HandlerFunction = FutureOr<Response> Function(Request);

class Response {
  final dynamic json;
  final Map<String, String> headers;
  final int status;

  Response.ok({
    this.json,
    this.headers = const {},
  }) : status = 200;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status,
        'headers': headers,
        'json': json,
      };

  Response.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int,
        headers = json['headers'] as Map<String, String>,
        json = json['json'] as dynamic;
}

class Request {
  final String method;
  final String path;
  final Map<String, String> headers;
  final dynamic json;

  Request({
    this.method,
    this.path,
    this.headers,
    this.json,
  });

  Request.fromJson(Map<String, dynamic> json)
      : method = json['method'] as String,
        path = json['path'] as String,
        headers = json['headers'] as Map<String, String>,
        json = json['json'] as dynamic;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'method': method,
        'path': path,
        'headers': headers,
        'json': json,
      };
}

Future<void> run(
  List<String> args,
  Map<String, HandlerFunction> routeHandlerMap,
) async {
  var server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    4040,
  );
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    final json =
        request.headers.contentType.primaryType == ContentType.json.primaryType
            ? await request
                .cast<List<int>>()
                .transform<String>(Utf8Decoder())
                .transform(JsonDecoder())
                .first
            : null;

    final headers = <String, String>{};
    request.headers.forEach((name, values) {
      headers[name] = values.join(',');
    });

    final req = Request(
      method: request.method,
      path: request.uri.path,
      headers: headers,
      json: json,
    );

    await request.response.close();
  }
}
