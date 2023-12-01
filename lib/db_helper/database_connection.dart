import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> initDb() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_crud');
    var database =
        await openDatabase(path, version: 1, onCreate: createDatabase);
    return database;
  }

// Future<void>
  dynamic createDatabase(Database database, int version) async {
    String sql =
        "CREATE TABLE user(id INTEGER PRIMARY KEY,  name TEXT, study TEXT, age TEXT, blood TEXT,selectedImage TEXT);";
    await database.execute(sql);
  }

  setDatabase() async {
    return await initDb();
  }
}
