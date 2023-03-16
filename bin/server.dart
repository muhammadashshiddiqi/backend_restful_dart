import 'package:backend_restful_dart/services/service.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  //final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  //final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  //final port = int.parse(Platform.environment['PORT'] ?? '9090');

  final service = Service();
  final server = await shelf_io.serve(service.handler, 'localhost', 9090);
  print('Server running on localhost:${server.port}');
}
