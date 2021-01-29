import 'dart:async';

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
  final String path;
  final Map<String, String> headers;
  final dynamic json;

  Request({
    this.path,
    this.headers,
    this.json,
  });

  Request.fromJson(Map<String, dynamic> json)
      : path = json['path'] as String,
        headers = json['headers'] as Map<String, String>,
        json = json['json'] as dynamic;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'path': path,
        'headers': headers,
        'json': json,
      };
}

Future<void> run(Map<String, HandlerFunction> routeHandlerMap) async =>
    print(routeHandlerMap);
