
import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'db/connection.dart';
import 'services/karyawan_service.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  //final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  //final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  //final port = int.parse(Platform.environment['PORT'] ?? '9090');


  final connection = Connection();
  await connection.db.open();

  final karyaranService = KaryawanService(connection);


  
  final router = Router()..mount('/karyawan', karyaranService.router);
  final ip = InternetAddress.anyIPv4;
  
  final server = await shelf_io.serve(router, ip, 9090);
  print('Server running on localhost:${server.port}');
}
