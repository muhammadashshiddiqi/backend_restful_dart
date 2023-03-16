import 'dart:convert';

import 'package:backend_restful_dart/connection/mysql.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Service {
  Handler get handler {
    final router = Router();

    router.get('/all', (Request request) async {
      try {
        final resultSet = await mysql.dbQuery("SELECT * FROM master_karyawan");
        Map<String, dynamic> jsonData = {};
        if (resultSet.numOfRows > 0) {
          List lsData = [];
          for (final row in resultSet.rows) {
            lsData.add(row.assoc());
          }

          jsonData.addAll({'code': 200, 'status': 'success', 'data': lsData});
        }

        return Response.ok(
          jsonEncode(jsonData),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        final error = {'message': 'Data not found', 'error': e.toString()};
        return Response.internalServerError(
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(error),
        );
      }
    });

    return router;
  }
}
