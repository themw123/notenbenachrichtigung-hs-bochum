import 'notification.dart';
import 'database.dart';

class Request {
  static Future<List<Map<String, dynamic>>> setSubjectsHS() async {
    //künstliche ladezeit
    await Future.delayed(const Duration(seconds: 3));

    await DatabaseHelper.setSubjects();

    //wenn ein fach weniger dann notification
    NotificationManager.init();
    NotificationManager.showNotification(
        "Test Notification", "This is a test notification, !!!!!!!!");

    return await DatabaseHelper.getSubjects();
  }
}
