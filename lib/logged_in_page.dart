import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notenbenachrichtigung/database.dart';
import 'package:notenbenachrichtigung/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notenbenachrichtigung/request.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Notenbenachrichtigung'),
        actions: [
          IconButton(
            iconSize: 0,
            onPressed: () async {
              final storage = new FlutterSecureStorage();
              await storage.deleteAll();
              await Future.delayed(Duration(milliseconds: 300));
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
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Du bist eingeloggt!'),
                  Text('Welcome ${widget.username}'),
                  Text('Your password is ${widget.password}'),
                ],
              ),
            ),
            Container(
              child: const Text(
                'Beobachten',
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final id = subjects[index][0];
                  final subject = subjects[index][1];
                  final id_subject = id.toString() + ":" + subject;
                  return ListTile(
                    title: Text(id_subject),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
