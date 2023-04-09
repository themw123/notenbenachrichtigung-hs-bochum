import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notenbenachrichtigung/database.dart';
import 'package:notenbenachrichtigung/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notenbenachrichtigung/request.dart';
import 'package:notenbenachrichtigung/subjectwidget.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;


  @override
  _LoggedInPageState createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  Timer? _timer;
  List<List<dynamic>> subjects = [];

  @override
  initState() {
    super.initState();
    //zu beginn einmal daten holen
    fetchData();
    //dann periodisch
    periodic();
  }

  Future<void> periodic() async {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await fetchData();
    });
  }

  Future<void> fetchData() async {
    await Request.getSubjectsHS();
    var temp = await DatabaseHelper.getSubjects();
    if (mounted) {
      setState(() {
        subjects = temp;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color.fromRGBO(226, 0, 26, 1.0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Notenbenachrichtigung'),
        actions: [
          IconButton(
            iconSize: 0,
            onPressed: () async {
              final storage = FlutterSecureStorage();
              await storage.deleteAll();
              await Future.delayed(const Duration(milliseconds: 300));
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MyApp(isLoggedIn: false, username: "", password: "")),
                (route) => false,
              );
            },
            icon: Image.asset('assets/logout.png'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20), // 16 Pixel Abstand
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: myColor,
                  width: 2.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Benutztername: ${widget.username}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: myColor
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // 16 Pixel Abstand
            const Text(
              'Beobachten',
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10), // 16 Pixel Abstand
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return SubjectWidget(
                        columnSubject: subjects[index][0],
                        columnPruefer: subjects[index][1],
                        columnDatum: subjects[index][2],
                        columnRaum: subjects[index][3],
                        columnUhrzeit: subjects[index][4],
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
