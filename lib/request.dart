import 'package:sqflite/sqflite.dart';

import 'notification.dart';
import 'database.dart';

class Request {


  static Future<void> getSubjectsHS() async {

    //datenbank aktualisieren. alte noten löschen neue hinzufügen

    //wenn ein fach weniger dann notification

    //noten holen und dann notification wenn nötig
    NotificationManager.init();
    NotificationManager.showNotification("Test Notification", "This is a test notification, !!!!!!!!");
  }



}