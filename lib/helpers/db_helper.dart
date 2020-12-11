import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'workouts.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE workout_list(id TEXT PRIMARY KEY, duration TEXT, date_time TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqlDb = await DBHelper.database();
    await sqlDb.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object>>> getData(String table) async {
    final sqlDb = await DBHelper.database();
    return sqlDb.query(table);
  }

  static Future<void> deleteById(String id) async {
    final sqlDb = await DBHelper.database();
    await sqlDb.execute('DELETE FROM workout_list WHERE id = ?', [id]);
  }

}