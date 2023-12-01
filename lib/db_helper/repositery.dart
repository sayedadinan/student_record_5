import 'package:sqflite/sqflite.dart';
import 'package:student_record_5/db_helper/database_connection.dart';

class Repository {
  late DatabaseConnection databaseConnection;
  Repository() {
    databaseConnection = DatabaseConnection();
  }

  static Database? databases;
  Future<Database?> get database async {
    if (databases != null) {
      return databases;
    } else {
      databases = await databaseConnection.setDatabase();
      return databases;
    }
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteDataById(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$itemId");
  }
}
