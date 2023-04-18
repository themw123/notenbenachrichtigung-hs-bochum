// ignore_for_file: depend_on_referenced_packages

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "notenbenachrichtigung.db";
  static const _databaseVersion = 1;

  static const tableNoten = 'noten';
  static const tableNotenOld = 'notenold';

  static const columnId = 'id';
  static const columnSubject = 'fach';
  static const columnPruefer = 'pruefer';
  static const columnDatum = 'datum';
  static const columnRaum = 'raum';
  static const columnUhrzeit = 'uhrzeit';

  static const columnOld = "old";

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

  _init() async {
    return await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: _onCreate,
      version: _databaseVersion,
    );
  }

  // SQL code to create the database table
  static Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableNoten (
            $columnId INTEGER PRIMARY KEY,
            $columnSubject TEXT NOT NULL,
            $columnPruefer TEXT NOT NULL,
            $columnDatum TEXT NOT NULL,
            $columnRaum TEXT NOT NULL,
            $columnUhrzeit TEXT NOT NULL,
            $columnOld INTEGER NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableNotenOld (
            $columnId INTEGER PRIMARY KEY,
            $columnSubject TEXT NOT NULL,
            $columnPruefer TEXT NOT NULL,
            $columnDatum TEXT NOT NULL,
            $columnRaum TEXT NOT NULL,
            $columnUhrzeit TEXT NOT NULL,
            $columnOld INTEGER NOT NULL
          )
          ''');
  }

  static Future<List<Map<String, dynamic>>> getSubjects() async {
    Database? db = await instance.database;

    List<Map<String, dynamic>> rowsOld =
        (await db!.query(DatabaseHelper.tableNotenOld))
            .map((row) => Map<String, dynamic>.from(row))
            .toList();

    List<Map<String, dynamic>> rows =
        (await db.query(DatabaseHelper.tableNoten))
            .map((row) => Map<String, dynamic>.from(row))
            .toList();

    List<Map<String, dynamic>> subjects = [];
    subjects.addAll(rowsOld);
    subjects.addAll(rows);

    return subjects;
  }

  static Future<void> setSubjects(
      table, List<Map<String, dynamic>> subjects) async {
    Database? db = await instance.database;

    for (Map<String, dynamic> subject in subjects) {
      await db!.insert(table, subject);
    }

    /*
    Map<String, dynamic> row1 = {
      DatabaseHelper.columnSubject: 'testFach1',
      DatabaseHelper.columnPruefer: 'Merchiersx',
      DatabaseHelper.columnDatum: '19.10.23',
      DatabaseHelper.columnRaum: 'H9',
      DatabaseHelper.columnUhrzeit: '13:00',
      DatabaseHelper.columnOld: 0
    };

    Map<String, dynamic> row2 = {
      DatabaseHelper.columnSubject: 'Digitalisierung im industrielen Umfeld',
      DatabaseHelper.columnPruefer: 'Merchiersd',
      DatabaseHelper.columnDatum: '19.08.23',
      DatabaseHelper.columnRaum: 'H7',
      DatabaseHelper.columnUhrzeit: '10:00',
      DatabaseHelper.columnOld: 1
    };

    await db!.insert(tableNoten, row1);
    await db.insert(tableNotenOld, row2);
    */
  }

  static Future<void> removeAllSubjects() async {
    Database? db = await instance.database;
    await db!.delete(DatabaseHelper.tableNoten);
    await db.delete(DatabaseHelper.tableNotenOld);
  }

  static Future<void> deleteDatabasex() async {
    await deleteDatabase(join(await getDatabasesPath(), _databaseName));
  }

  // Helper methods

  // Inserts at row in the database where each key in he Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tableNoten, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  static Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(tableNoten);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  static Future<int> queryRowCount() async {
    Database? db = await instance.database;
    final results = await db!.rawQuery('SELECT COUNT(*) FROM $tableNoten');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  static Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(
      tableNoten,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  static Future<int> delete(id) async {
    Database? db = await instance.database;
    return await db!.delete(
      tableNotenOld,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
