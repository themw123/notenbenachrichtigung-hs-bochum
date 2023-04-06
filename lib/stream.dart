import 'dart:async';

import 'package:notenbenachrichtigung/database.dart';
import 'package:sqflite/sqflite.dart';

class StreamControllerHelper {
  static final StreamController<List<List<dynamic>>> _dataStreamController = StreamController<List<List<dynamic>>>.broadcast();

  // Methode, um Daten zu fetchen und sie über den StreamController an die Flutter-Anwendung zu senden
  static void setSubjects() async {
    // Daten an den StreamController senden
    _dataStreamController.add(await DatabaseHelper.getSubjects());
  }

  static StreamController<List<List>> get controller => _dataStreamController;

}