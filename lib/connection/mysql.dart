import 'package:backend_restful_dart/models/db_response.dart';
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

  Future<IResultSet> dbQuery(String query) async {
    var result = await conn.execute(query);
    //await conn.close();
    return result;
    /* var res = await dbConnect(
      "UPDATE book SET price = :price",
      {"price": 200},
    );

    await db()
    await db().then((db) async {
      db.query(query)
        ..then((res) {
          return DBResponses(success: res);
        })
        ..whenComplete(() {
          db.close();
        });

      return null;
    }).onError((error, stackTrace) {
      print(error);
    }); */
  }
}
