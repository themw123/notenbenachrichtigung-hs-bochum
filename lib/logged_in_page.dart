import 'package:flutter/material.dart';
import 'package:notenbenachrichtigung/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _LoggedInPageState createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ElevatedButton(
              child: Text('Clear Data'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                await Future.delayed(Duration(milliseconds: 500));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => MyApp(isLoggedIn: false, username: "", password: "")),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
