import 'dart:_http';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';

Future<void> main() async {
  final HttpServer server = await shelf_io.serve(
    proxyHandler('https://soapphoto.com'),
    'localhost',
    3000,
  );

  print('Proxying at http://${server.address.host}:${server.port}');
}
