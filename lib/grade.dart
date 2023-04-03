import 'package:workmanager/workmanager.dart';

import 'notification.dart';

class Grade {

  static void getGrade() {
    // Hier wird Notification aufgerufen
    NotificationManager.init();
    NotificationManager.showNotification("Test Notification", "This is a test notification");
  }

}