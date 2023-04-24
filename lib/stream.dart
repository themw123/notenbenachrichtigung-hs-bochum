import 'dart:async';

import 'database.dart';
import 'package:sqflite/sqflite.dart';

class StreamControllerHelper {
  static final StreamController<List<Map<String, dynamic>>>
      _dataStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  // Methode, um Daten zu fetchen und sie über den StreamController an die Flutter-Anwendung zu senden
  static Future<void> setSubjects() async {
    // Daten an den StreamController senden
    _dataStreamController.add(await DatabaseHelper.getSubjects());
  }

  static StreamController<List<Map<String, dynamic>>> get controller =>
      _dataStreamController;
}
