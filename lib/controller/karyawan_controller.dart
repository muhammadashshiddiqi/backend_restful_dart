import 'package:backend_restful_dart/connection/mysql.dart';
import 'package:backend_restful_dart/models/response.dart';

final karyawanController = _KaryawanController._();

class _KaryawanController {
  _KaryawanController._();

  Future<Response> getAllKaryawan() async {
    try {
      String query = "SELECT * FROM master_karyawan";
      final resultSet = await mysql.dbQuery(query);
      if (resultSet.numOfRows > 0) {
        List lsData = [];
        for (final row in resultSet.rows) {
          lsData.add(row.assoc());
        }
        return Response(code: 200, status: 'success', data: lsData);
      }
      return Response(code: 400, status: 'failed', message: 'Data not found.');
    } catch (e) {
      return Response(code: 400, status: 'failed', message: e.toString());
    }
  }

  Future<Response> addKaryawan(String nik, String nama) async {
    try {
      String query =
          "INSERT INTO master_karyawan (nik, nama) VALUES (:nik, :nama)";

      final resultSet =
          await mysql.dbQuery(query, data: {"nik": nik, "nama": nama});
      if (resultSet.affectedRows.toInt() > 0) {
        return Response(
            code: 200,
            status: 'success',
            message: 'Data has been insert sucessfully.');
      }
      return Response(code: 400, status: 'failed', message: 'Data failed.');
    } catch (e) {
      return Response(code: 400, status: 'failed', message: e.toString());
    }
  }
}
