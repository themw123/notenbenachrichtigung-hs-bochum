// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'logged_in_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    const storage = FlutterSecureStorage();
    storage.write(key: 'isLoggedIn', value: "true");
    storage.write(key: 'username', value: username);
    storage.write(key: 'password', value: password);

    await Future.delayed(const Duration(milliseconds: 300));
    // Weiterleitung zur LoggedInPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoggedInPage(username: username, password: password)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // das verhindert dass das Layout automatisch angepasst wird
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 10),
                SvgPicture.asset(
                  'assets/hs.svg',
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Benutzername'),
                  controller: _usernameController,
                  validator: _validateInput,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Passwort'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: _validateInput,
                ),
                ElevatedButton(
                  child: const Text('login'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Dieses Feld darf nicht leer sein.';
    }
    return null;
  }
}
