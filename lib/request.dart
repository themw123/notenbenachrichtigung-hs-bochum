import 'notification.dart';
import 'database.dart';

class Request {
  static setSubjectsHS() async {
    //künstliche ladezeit
    await Future.delayed(const Duration(seconds: 3));

    //await DatabaseHelper.setSubjects();
    //wenn ein fach weniger dann notification
    NotificationManager.init();
    NotificationManager.showNotification(
        "Test Notification", "This is a test notification, !!!!!!!!");
  }
}
