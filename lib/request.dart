import 'notification.dart';
import 'database.dart';

class Request {


  static Future<void> getSubjectsHS() async {

    await DatabaseHelper.setSubjects();

    //wenn ein fach weniger dann notification
    NotificationManager.init();
    NotificationManager.showNotification("Test Notification", "This is a test notification, !!!!!!!!");

  }






}