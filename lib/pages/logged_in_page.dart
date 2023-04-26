// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Notenbenachrichtigung/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Notenbenachrichtigung/Business.dart';
import 'package:workmanager/workmanager.dart';

import '../database.dart';
import '../notification.dart';
import '../stream.dart';
import '../widgets/subject.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  // ignore: library_private_types_in_public_api
  _LoggedInPageState createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage>
    with WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Future<List<Map<String, dynamic>>>? subjects;
  late Business business;

  Color myColor = const Color.fromRGBO(226, 0, 26, 1.0);

  fetchData(Function method) {
    if (mounted) {
      setState(() {
        subjects = method();
      });
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    business = Business(widget.username, widget.password);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //weil async nicht geht in initState aber hiermit. ist genau wie initState. Wird nur einmal aufgerufen wenn widget gebuilded wird
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    //wenn subjects leer ist dann request machen.
    if ((await DatabaseHelper.getSubjects()).isEmpty) {
      //request hs bochum und in datenbank speichern und ui refresh
      await business.subjects(true);
    }
    //returnt ein Future, es wird nicht drauf awaitet. FutureBuilder erwartet das ja auch
    fetchData(DatabaseHelper.getSubjects);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    //wird immer aufgerufen wenn app in den vordergrund kommt
    if (state == AppLifecycleState.resumed) {
      Workmanager().cancelByUniqueName("meintask");
      //returnt ein Future, es wird nicht drauf awaitet. FutureBuilder erwartet das ja auch
      fetchData(DatabaseHelper.getSubjects);
    } else {
      //daten periodisch von hs bochum holen
      Workmanager().registerPeriodicTask('meintask', 'meintask',
          frequency: const Duration(minutes: 15),
          initialDelay: const Duration(minutes: 15),
          existingWorkPolicy: ExistingWorkPolicy.keep);
    }
  }

  void removeSubject(int index) {
    subjects?.then((subjects) {
      final removedSubject = subjects.removeAt(index);
      final id = removedSubject.values.elementAt(0);
      DatabaseHelper.delete(id);

      _listKey.currentState?.removeItem(
        index,
        (context, animation) => Subject(
          item: removedSubject,
          animation: animation,
          columnId: removedSubject.values.elementAt(0),
          columnSubject: removedSubject.values.elementAt(1),
          columnPruefer: removedSubject.values.elementAt(2),
          columnDatum: removedSubject.values.elementAt(3),
          columnRaum: removedSubject.values.elementAt(4),
          columnUhrzeit: removedSubject.values.elementAt(5),
          columnOld: removedSubject.values.elementAt(6),
          onDelete: () => removeSubject(index),
        ),
        duration: const Duration(milliseconds: 500),
      );
    });
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
              await DatabaseHelper.removeAllSubjects();
              Workmanager().cancelByUniqueName("meintask");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MyApp(
                        isLoggedIn: false, username: "", password: "")),
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
                      color: myColor),
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
                    future: subjects,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Fehler beim Laden der Daten: ${snapshot.error}'));
                      } else if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: SizedBox(
                            width: 200, // adjust the width as needed
                            child: Text(
                              'Es gibt keine Noten auf die gewartet wird',
                              textAlign: TextAlign
                                  .center, // center the text within the container
                            ),
                          ),
                        );
                      } else {
                        final subjects = snapshot.data!;
                        return AnimatedList(
                          key: _listKey,
                          initialItemCount: subjects.length,
                          padding: const EdgeInsets.all(16.0),
                          itemBuilder: (context, index, animation) {
                            return Subject(
                              item: subjects[index],
                              animation: animation,
                              columnId: subjects[index].values.elementAt(0),
                              columnSubject:
                                  subjects[index].values.elementAt(1),
                              columnPruefer:
                                  subjects[index].values.elementAt(2),
                              columnDatum: subjects[index].values.elementAt(3),
                              columnRaum: subjects[index].values.elementAt(4),
                              columnUhrzeit:
                                  subjects[index].values.elementAt(5),
                              columnOld: subjects[index].values.elementAt(6),
                              onDelete: () => removeSubject(index),
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
