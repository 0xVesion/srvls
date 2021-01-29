import 'package:srvls/srvls.dart';

Future<Response> handler(Request req) async {
  return Response.ok(json: {'hello': 'world'});
}
