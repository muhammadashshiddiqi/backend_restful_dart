import 'dart:convert';

import 'package:backend_restful_dart/controller/karyawan_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Service {
  Handler get handler {
    final router = Router();
    final header = <String, String>{'Content-Type': 'application/json'};

    router.get('/karyawan-list', (Request request) async {
      final res = await karyawanController.getAllKaryawan();
      if (res.code == 200) {
        return Response.ok(
          jsonEncode(res.toJson()),
          headers: header,
        );
      }
      return Response.internalServerError(
        body: jsonEncode(res.toJson()),
        headers: header,
      );
    });

    router.post('/karyawan-add', (Request request) async {
      final payload = jsonDecode(await request.readAsString());
      if (payload == null) {
        return Response.notFound("Data Notfound.", headers: header);
      }

      final res = await karyawanController.addKaryawan(
        payload['nik'],
        payload['nama'],
      );

      if (res.code == 200) {
        return Response.ok(
          jsonEncode(res.toJson()),
          headers: header,
        );
      }

      return Response.internalServerError(
        body: jsonEncode(res.toJson()),
        headers: header,
      );
    });

    router.put('/karyawan-update', (Request request) async {
      final payload = jsonDecode(await request.readAsString());
      List data = [];
      data.add(payload);

      return Response.ok(
        jsonEncode({'success': true, 'data': data}),
        headers: header,
      );
    });

    return router;
  }
}
