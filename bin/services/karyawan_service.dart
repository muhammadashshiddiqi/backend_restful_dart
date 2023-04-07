import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../db/connection.dart';
import '../models/response_wrapper.dart';
import '../utils/variables.dart';

class KaryawanService {
  final Connection _conn;

  KaryawanService(this._conn);
  Router get router => Router()
    ..get('/', _getAllKaryawanHandler)
    ..post('/add', _addKaryawanHandler)
    ..put('/update', _updateKaryawanHandler)
    ..delete('/delete', _deleteKaryawanHandler);

  Future<Response> _getAllKaryawanHandler(Request request) async {
    try {
      const getKaryawanQuery = 'SELECT * FROM master_karyawan';
      final postgresResult = await _conn.db.query(getKaryawanQuery);
      final lsResult =
          postgresResult.toList().map((e) => e.toColumnMap()).toList();

      return Response.ok(
        headers: vr.headers,
        jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.ok,
            data: lsResult,
          ).toJson(),
        ),
      );
    } on PostgreSQLException catch (e, trace) {
      log(e.toString(), stackTrace: trace);
      return Response.internalServerError(
        headers: vr.headers,
        body: jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.internalServerError,
            message: e.message,
          ).toJson(),
        ),
      );
    } catch (e, trace) {
      log(e.toString(), stackTrace: trace);
      return Response.internalServerError(
        headers: vr.headers,
        body: jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.internalServerError,
            message: e.toString(),
          ).toJson(),
        ),
      );
    }
  }

  Future<Response> _addKaryawanHandler(Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final nik = body['nik'] as String?;
      final nama = body['nama'] as String?;
      final gaji = body['gaji'] as int?;

      if (nik == null || nik.isEmpty) {
        return Response.badRequest(
          headers: vr.headers,
          body: jsonEncode(
            ResponseWrapper(
              statusCode: HttpStatus.badRequest,
              message: '{nik} is required',
            ).toJson(),
          ),
        );
      }

      if (nama == null || nama.isEmpty) {
        return Response.badRequest(
          headers: vr.headers,
          body: jsonEncode(
            ResponseWrapper(
              statusCode: HttpStatus.badRequest,
              message: '{nama} is required',
            ).toJson(),
          ),
        );
      }

      if (gaji == null || gaji == 0) {
        return Response.badRequest(
          headers: vr.headers,
          body: jsonEncode(
            ResponseWrapper(
              statusCode: HttpStatus.badRequest,
              message: '{gaji} is required',
            ).toJson(),
          ),
        );
      }

      /* untuk transaction group begin and rollback
      final transaction = await _conn.db.transaction((connection) async {
        
      }); */

      const insertKaryawanQuery = '''
        INSERT INTO master_karyawan (
          nik,
          nama,
          gaji
        ) VALUES (
          @nik,
          @nama,
          @gaji:int4
        ) RETURNING nik
      ''';

      final postgresResult = await _conn.db.query(
        insertKaryawanQuery,
        substitutionValues: {'nik': nik, 'nama': nama, 'gaji': gaji},
      );
      if (postgresResult.isEmpty) {
        return Response.internalServerError(
          headers: vr.headers,
          body: jsonEncode(
            ResponseWrapper(
              statusCode: HttpStatus.internalServerError,
              message: 'Karyawan not created',
            ).toJson(),
          ),
        );
      }

      return Response.ok(
        headers: vr.headers,
        jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.ok,
            message: 'Karyawan successfully created',
          ).toJson(),
        ),
      );
    } on PostgreSQLException catch (e, trace) {
      log(e.toString(), stackTrace: trace);
      return Response.internalServerError(
        headers: vr.headers,
        body: jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.internalServerError,
            message: e.message,
          ).toJson(),
        ),
      );
    } catch (e, trace) {
      log(e.toString(), stackTrace: trace);
      return Response.internalServerError(
        headers: vr.headers,
        body: jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.internalServerError,
            message: e.toString(),
          ).toJson(),
        ),
      );
    }
  }

  Future<Response> _updateKaryawanHandler(Request request) async {
    try {
      final nik = request.requestedUri.queryParameters['nik'] ?? '';
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final nama = body['nama'] as String?;
      final gaji = body['gaji'] as int?;

      const updateKaryawanQuery = '''
        UPDATE 
          master_karyawan 
        SET 
          nama = @nama, 
          gaji = @gaji:int4 
        WHERE nik = @nik 
        RETURNING nik
      ''';
      final postgresResult = await _conn.db.query(
        updateKaryawanQuery,
        substitutionValues: {'nama': nama, 'gaji': gaji, 'nik': nik},
      );
      if (postgresResult.isEmpty) {
        return Response.internalServerError(
          headers: vr.headers,
          body: jsonEncode(
            ResponseWrapper(
              statusCode: HttpStatus.internalServerError,
              message: 'Karyawan not updated',
            ).toJson(),
          ),
        );
      }

      return Response.ok(
        headers: vr.headers,
        jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.ok,
            message: 'Karyawan successfully updated',
          ).toJson(),
        ),
      );
    } on PostgreSQLException catch (e, trace) {
      log(e.toString(), stackTrace: trace);
      return Response.internalServerError(
        headers: vr.headers,
        body: jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.internalServerError,
            message: e.message,
          ).toJson(),
        ),
      );
    } catch (e, trace) {
      log(e.toString(), stackTrace: trace);
      return Response.internalServerError(
        headers: vr.headers,
        body: jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.internalServerError,
            message: e.toString(),
          ).toJson(),
        ),
      );
    }
  }

  Future<Response> _deleteKaryawanHandler(Request request) async {
    try {
      final nik = request.requestedUri.queryParameters['nik'] ?? '';
      const deleteKaryawanQuery =
          ''' DELETE FROM master_karyawan WHERE nik = @nik ''';
      final postgresResult = await _conn.db.query(
        deleteKaryawanQuery,
        substitutionValues: {'nik': nik},
      );

      return Response.ok(
        headers: vr.headers,
        jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.ok,
            message: 'Karyawan successfully deleted',
          ).toJson(),
        ),
      );
    } on PostgreSQLException catch (e, trace) {
      log(e.toString(), stackTrace: trace);
      return Response.internalServerError(
        headers: vr.headers,
        body: jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.internalServerError,
            message: e.message,
          ).toJson(),
        ),
      );
    } catch (e, trace) {
      log(e.toString(), stackTrace: trace);
      return Response.internalServerError(
        headers: vr.headers,
        body: jsonEncode(
          ResponseWrapper(
            statusCode: HttpStatus.internalServerError,
            message: e.toString(),
          ).toJson(),
        ),
      );
    }
  }
}
