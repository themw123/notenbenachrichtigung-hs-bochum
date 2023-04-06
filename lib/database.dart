import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "notenbenachrichtigung.db";
  static const _databaseVersion = 1;

  static const table = 'noten';

  static const columnId = 'id';
  static const columnSubject = 'fach';

  static List<List<dynamic>> subjects = [];


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _init();
    return _database;
  }

  _init() async{
    return await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: _onCreate,
      version: _databaseVersion,
    );
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
    Database? db = await instance.database;

    //einamlig
    yield subjects;

    //alle 5 sekunden wird subjects auf aktualisierungen überprüft
    yield* Stream.periodic(Duration(seconds: 5), (_) {
      return subjects;
    }).asyncMap((event) async => event);

  }

  static void getSubjects() async {
    final db = await instance.database;
    subjects = await db!.query(DatabaseHelper.table)
        .then((rows) => rows.map((row) => [row[DatabaseHelper.columnId], row[DatabaseHelper.columnSubject]]).toList());
  }


  static Future<void> setSubjects() async {
    Database? db = await instance.database;
    // row to insert
    Map<String, dynamic> row1 = {
      DatabaseHelper.columnSubject: 'testFach',
    };
    /*
    Map<String, dynamic> row2 = {
      DatabaseHelper.columnSubject: 'testFach2',
    };
    */
    await db!.insert(table, row1);
    //await db!.insert(table, row2);

    getSubjects();
  }

  static Future<void> removeAllSubjects() async {
    Database? db = await instance.database;
    await db!.delete(DatabaseHelper.table);
  }



  // Helper methods

  //delete all rows
  static Future<int> deleteAllRows() async {
    Database? db = await instance.database;
    return await db!.delete('noten');
  }

  // Inserts at row in the database where each key in he Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  static Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  static Future<int> queryRowCount() async {
    Database? db = await instance.database;
    final results = await db!.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  static Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  static Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}