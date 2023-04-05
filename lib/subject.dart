import 'notification.dart';
import 'database.dart';

class Subject {


  static Future<void> getSubjectsHS() async {



    //noten holen und dann notification wenn nötig
    NotificationManager.init();
    NotificationManager.showNotification("Test Notification", "This is a test notification, !!!!!!!!");
  }



  static Stream<List<List<dynamic>>> getSubjectsStream() async* {
    final db = await DatabaseHelper.getDatabaseobject();
    yield* await db
        .query(DatabaseHelper.table)
        .then((rows) => rows.map((row) => [row[DatabaseHelper.columnId], row[DatabaseHelper.columnSubject]]).toList())
        .asStream();
  }

  /*
  static Future<List<List>> getSubjectsDB() async {

    //query
    final allRows = await DatabaseHelper.queryAllRows();

    List<List<dynamic>> subjects = [];
    for (final row in allRows) {
      var id = row['id'];
      var subject = row['fach'];
      List<dynamic> element = [id, subject];
      subjects.add(element);
    }

    return subjects;

  }
  */


  static Future<void> setSubjects() async {
    // row to insert
    Map<String, dynamic> row1 = {
      DatabaseHelper.columnSubject: 'testFach1',
    };
    Map<String, dynamic> row2 = {
      DatabaseHelper.columnSubject: 'testFach2',
    };
    await DatabaseHelper.insert(row1);
    await DatabaseHelper.insert(row2);
  }

  static Future<void> removeSubject() async {

  }

}