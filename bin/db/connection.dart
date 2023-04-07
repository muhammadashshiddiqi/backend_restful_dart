import 'package:postgres/postgres.dart';

import '../utils/environment.dart';

class Connection {
  late final PostgreSQLConnection db;

  Connection() {
    db = PostgreSQLConnection(
      env.dbHost,
      env.dbPort,
      env.dbName,
      username: env.dbUser,
      password: env.dbPassword,
    );
  }
}
