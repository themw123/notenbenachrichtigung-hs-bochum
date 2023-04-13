// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pages/not_logged_in_page.dart';
import 'pages/logged_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();
  String? value = await storage.read(key: 'isLoggedIn');
  bool isLoggedIn = value?.toLowerCase() == 'true';

  value = await storage.read(key: 'username');
  String username = value != null ? value : '';

  value = await storage.read(key: 'password');
  String password = value != null ? value : '';

  //await DatabaseHelper.removeAllSubjects();
  //await DatabaseHelper.deleteDatabasex();

  //berechtigugn einfordern, dass app nicht von bsp energiesparmodus beeinträchtigt wird
  requestBatteryOptimizations();

  runApp(MyApp(isLoggedIn: isLoggedIn, username: username, password: password));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key,
      required this.isLoggedIn,
      required this.username,
      required this.password})
      : super(key: key);

  final bool isLoggedIn;
  final String username;
  final String password;
  final myCustomColor = const Color(0xffe2001a);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final myCustomMaterialColor = MaterialColor(
      myCustomColor.value,
      <int, Color>{
        50: myCustomColor.withOpacity(0.1),
        100: myCustomColor.withOpacity(0.2),
        200: myCustomColor.withOpacity(0.3),
        300: myCustomColor.withOpacity(0.4),
        400: myCustomColor.withOpacity(0.5),
        500: myCustomColor.withOpacity(0.6),
        600: myCustomColor.withOpacity(0.7),
        700: myCustomColor.withOpacity(0.8),
        800: myCustomColor.withOpacity(0.9),
        900: myCustomColor.withOpacity(1),
      },
    );

    return MaterialApp(
      title: '',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: myCustomMaterialColor,
      ),
      home: isLoggedIn
          ? LoggedInPage(username: username, password: password)
          : const LoginPage(),
    );
  }
}

void requestBatteryOptimizations() async {
  if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
    // Die Berechtigung wurde gewährt, die App kann im Hintergrund ausgeführt werden
  } else {
    // Die Berechtigung wurde nicht gewährt, die App kann möglicherweise nicht im Hintergrund ausgeführt werden
  }
}
