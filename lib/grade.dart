import 'package:workmanager/workmanager.dart';
import 'notification.dart';

class Grade {

  static Future<void> initGrade() async {
    Workmanager().initialize(backgroundTask);
  }

  static void backgroundTask() {
    Workmanager().executeTask((taskName, inputData){
      // Hier wird Notification aufgerufen
      NotificationManager.init();
      NotificationManager.showNotification("Test Notification", "This is a test notification");
      return Future.value(true);
    });
  }


  static void startGrade() {
    //starte den workmanager
    //weniger als 15 minuten nicht möglich
    Workmanager().registerPeriodicTask('yyyy', 'yyyy',
      frequency: Duration(minutes: 15),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }



}