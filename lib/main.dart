import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workmanager/workmanager.dart';

import 'grade.dart';
import 'login_page.dart';
import 'logged_in_page.dart';
import 'notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = new FlutterSecureStorage();
  String? value = await storage.read(key: 'isLoggedIn');
  bool isLoggedIn = value?.toLowerCase() == 'true';

  value = await storage.read(key: 'username');
  String username = value != null ? value as String : '';

  value = await storage.read(key: 'password');
  String password = value != null ? value as String : '';



  //initialisiere den background task durch klasse Grade, muss vor runApp erfolgen
  await Grade.initGrade();
  Grade.startGrade();


  runApp(MyApp(isLoggedIn: isLoggedIn, username: username, password: password));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isLoggedIn, required this.username, required this.password})
      : super(key: key);

  final bool isLoggedIn;
  final String username;
  final String password;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? LoggedInPage(username: username, password: password) : LoginPage(),
    );
  }
}



