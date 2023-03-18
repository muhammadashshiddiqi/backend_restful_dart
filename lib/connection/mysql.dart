import 'package:mysql_client/mysql_client.dart';

final mysql = _Mysql();

class _Mysql {
  late final MySQLConnection conn;
  _Mysql() {
    _initDBConnect();
  }

  void _initDBConnect() async {
    print("Connecting to mysql server...");
    conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "root",
      databaseName: "crud_backend_dart",
    );

    await conn.connect();
    print("Connected");
  }

  Future<IResultSet> dbQuery(String query, {Map<String, dynamic>? data}) async {
    var result = await conn.execute(query, data);
    return result;
  }
}
