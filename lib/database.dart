import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "notenbenachrichtigung.db";
  static const _databaseVersion = 1;

  static const table = 'noten';

  static const columnId = 'id';
  static const columnSubject = 'fach';

  static late Database _db;


  static Future<Database> getDatabaseobject() async {
    return await DatabaseHelper._db;
  }



  // this opens the database (and creates it if it doesn't exist)
  static Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Database initialized!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }

  // SQL code to create the database table
  static Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnSubject TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  //delete all rows
  static Future<int> deleteAllRows() async {
    return await _db.delete('noten');
  }

  // Inserts at row in the database where each key in he Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  static Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  static Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  static Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  static Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}