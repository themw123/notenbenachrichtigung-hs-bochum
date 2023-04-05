import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "notenbenachrichtigung.db";
  static const _databaseVersion = 1;

  static const table = 'noten';

  static const columnId = 'id';
  static const columnSubject = 'fach';


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static late Database _db;

  // only have a single app-wide reference to the database
  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await init();
    return _db!;
  }

  // this opens the database (and creates it if it doesn't exist)
  init() async {
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


  static Stream<List<List<dynamic>>> getSubjectsStream() async* {

    /*
    yield* await db
        .query(DatabaseHelper.table)
        .then((rows) => rows.map((row) => [row[DatabaseHelper.columnId], row[DatabaseHelper.columnSubject]]).toList())
        .asStream();

     */
    final db = await instance.database;
    final allRows = await db.query(table);
    final subjects = allRows.map((row) => [row[DatabaseHelper.columnId], row[DatabaseHelper.columnSubject]]).toList();
    yield subjects;
  }


  static Future<void> setSubjects() async {
    // row to insert
    Map<String, dynamic> row1 = {
      DatabaseHelper.columnSubject: 'testFach1',
    };
    Map<String, dynamic> row2 = {
      DatabaseHelper.columnSubject: 'testFach2',
    };
    final db = await instance.database;
    await db.insert(table, row1);
    await db.insert(table, row2);
  }

  static Future<void> removeSubject() async {

  }



  // Helper methods

  //delete all rows
  static Future<int> deleteAllRows() async {
    final db = await instance.database;
    return await db.delete('noten');
  }

  // Inserts at row in the database where each key in he Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insert(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  static Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await instance.database;
    return await _db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  static Future<int> queryRowCount() async {
    final db = await instance.database;
    final results = await db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  static Future<int> update(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row[columnId];
    return await db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  static Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}