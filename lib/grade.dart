import 'notification.dart';
import 'database.dart';

class Grade {


  static Future<void> getGrade() async {

    //muss hier erfolgen
    await DatabaseHelper.init();

    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    //query
    final allRows = await DatabaseHelper.queryAllRows();
    var test = 1;
    for (final row in allRows) {
      test = row['test'];
    }
    test = test+1;

    //delete all rows
    await DatabaseHelper.deleteAllRows();

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnSubject: 'testFach',
      DatabaseHelper.test: test
    };
    await DatabaseHelper.insert(row);

    //noten holen und dann notification wenn nötig
    NotificationManager.init();
    NotificationManager.showNotification("Test Notification", "This is a test notification, !!!!${test}!!!!");
  }


}