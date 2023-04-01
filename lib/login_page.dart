import 'package:flutter/material.dart';
import 'logged_in_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async{
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('username', username);
    prefs.setString('password', password);

    await Future.delayed(Duration(milliseconds: 500));
    // Weiterleitung zur LoggedInPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoggedInPage(username: username, password: password)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Benutzername'),
              controller: _usernameController,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
              controller: _passwordController,
            ),
            ElevatedButton(
              child: const Text('login'),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }
}
