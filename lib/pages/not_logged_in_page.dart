// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Business.dart';
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
  late Business business;
  bool login = true;
  bool loading = false;
  bool button = true;

  void _submitForm() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      loading = true;
      login = true;
      button = false;
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;

    business = Business(username, password);
    bool success = await business.login();

    if (success) {
      const storage = FlutterSecureStorage();
      storage.write(key: 'isLoggedIn', value: "true");
      storage.write(key: 'username', value: username);
      storage.write(key: 'password', value: password);

      // Weiterleitung zur LoggedInPage
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoggedInPage(username: username, password: password)),
      );
    } else {
      setState(() {
        login = false;
      });
    }
    setState(() {
      loading = false;
      button = true;
    });
  }

  Future<void> _launchUrl(url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
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
        child: Column(
          children: [
            Padding(
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
                    loading == true || login == false
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    Center(
                      child: Stack(children: [
                        loading
                            ? Column(children: const [
                                CircularProgressIndicator(),
                              ])
                            : const Text(""),
                        login
                            ? const Text("")
                            : Column(children: const [
                                Text("Login fehlgeschlagen.",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 25)),
                              ]),
                      ]),
                    ),
                    loading == true || login == false
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Benutzername'),
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
                      onPressed: button
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                _submitForm();
                              }
                            }
                          : null,
                      style: button
                          ? null
                          : ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey[300]!),
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              splashFactory: NoSplash.splashFactory,
                            ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _launchUrl('https://github.com/themw123');
                      },
                      child: Text(
                        'mein GitHub',
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
