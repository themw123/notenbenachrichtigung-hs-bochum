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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Map<String, dynamic>> subjects = [];

  Timer? _timer;
  Color myColor = const Color.fromRGBO(226, 0, 26, 1.0);

  @override
  initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> periodicFetch() async {
    subjects = await fetchData();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await fetchData();
    });
    return subjects;
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    await Request.getSubjectsHS();
    return await DatabaseHelper.getSubjects();
  }

  /*
  void removeSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }
  */


  void removeSubject(int index) {
    final item = subjects.removeAt(index);
    /*
    _listKey.currentState?.removeItem(index, (context, animation) => SubjectWidget(
      columnSubject: subjects[index].values.elementAt(1),
      columnPruefer: subjects[index].values.elementAt(2),
      columnDatum: subjects[index].values.elementAt(3),
      columnRaum: subjects[index].values.elementAt(4),
      columnUhrzeit: subjects[index].values.elementAt(5),
      columnOld: subjects[index].values.elementAt(6),
      onDelete: () => removeSubject(index),
    ));
    */
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
              const storage = FlutterSecureStorage();
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
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: periodicFetch(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Fehler beim Laden der Daten: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Keine Daten vorhanden'));
                      } else {
                        final subjects = snapshot.data!;
                        return AnimatedList(
                          key: _listKey,
                          initialItemCount: subjects.length,
                          padding: const EdgeInsets.all(16.0),
                          itemBuilder: (context, index, animation) {
                            return SizeTransition(
                              sizeFactor: animation,
                              child: SubjectWidget(
                                columnSubject: subjects[index].values.elementAt(1),
                                columnPruefer: subjects[index].values.elementAt(2),
                                columnDatum: subjects[index].values.elementAt(3),
                                columnRaum: subjects[index].values.elementAt(4),
                                columnUhrzeit: subjects[index].values.elementAt(5),
                                columnOld: subjects[index].values.elementAt(6),
                                onDelete: () => removeSubject(index),
                              ),
                            );
                          },
                        );
                      }
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
