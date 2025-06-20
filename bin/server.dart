import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

Future<Response> sendOtpHandler(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  final response = await http.post(
    Uri.parse('https://smsplus.sslwireless.com/api/v3/send-sms'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  return Response(
    response.statusCode,
    body: response.body,
    headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
    },
  );
}


void main() async {
  final router = Router();
  router.post('/send-otp', sendOtpHandler);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('✅ Server started on http://${server.address.host}:${server.port}');
}
