import 'package:workmanager/workmanager.dart';

import 'notification.dart';

class Grade {

  static void getGrade() {
    //noten holen und dann notification wenn nötig
    NotificationManager.init();
    NotificationManager.showNotification("Test Notification", "This is a test notification");
  }

}