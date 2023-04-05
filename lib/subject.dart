import 'package:sqflite/sqflite.dart';

import 'notification.dart';
import 'database.dart';

class Subject {


  static Future<void> getSubjectsHS() async {
    //noten holen und dann notification wenn nötig
    NotificationManager.init();
    NotificationManager.showNotification("Test Notification", "This is a test notification, !!!!!!!!");
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


}