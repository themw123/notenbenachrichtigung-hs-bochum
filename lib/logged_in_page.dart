import 'package:flutter/material.dart';
import 'package:notenbenachrichtigung/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workmanager/workmanager.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  _LoggedInPageState createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {

  bool grade = false;


  @override
  void initState() {
    //starte den background task
    Workmanager().registerPeriodicTask('checkGrade', 'checkGrade',
      frequency: Duration(minutes: 15),
      existingWorkPolicy: ExistingWorkPolicy.replace
    );
    super.initState();
  }

  //ui grade wird aktualisiert.
  //es fehl noch der aufruf der durch backgroundTask() erfolgen soll.
  void updateGrade(bool newGrade) {
    setState(() {
      grade = newGrade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Logged in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Du bist eingeloggt!'),
            Text('Welcome ${widget.username}'),
            Text('Your password is ${widget.password}'),
            Text("neue Note: $grade"),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('logout'),
                    onPressed: () async {
                      final storage = new FlutterSecureStorage();
                      await storage.deleteAll();
                      Workmanager().cancelByUniqueName("checkGrade");
                      await Future.delayed(Duration(milliseconds: 300));
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MyApp(
                                isLoggedIn: false, username: "", password: "")),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
