import 'package:html/parser.dart' show parse;
import 'notification.dart';
import 'database.dart';
import 'package:requests/requests.dart';

class Request {
  dynamic asi;
  String? username;
  String? password;
  static final Request _singleton = Request._internal();

  factory Request(String username, String password) {
    _singleton.username = username;
    _singleton.password = password;
    return _singleton;
  }

  Request._internal();

  Future<List<Map<String, dynamic>>> subjects() async {
    //künstliche ladezeit
    //await Future.delayed(const Duration(seconds: 3));

    bool success = await login();
    NotificationManager.init();
    if (!success) {
      NotificationManager.showNotification("Test Notification",
          "Die Noten konnten nicht aktualisiert werden. Login fehlgeschlagen. ");
      return await DatabaseHelper.getSubjects();
    }
    //!!!!!!!!!!hier subjects von hs bochum holen!!!!!!!!!!!!!!!!!!
    await DatabaseHelper.setSubjects();
    NotificationManager.showNotification(
        "Test Notification", "This is a test notification, !!!!!!!!");
    var subjects = await DatabaseHelper.getSubjects();
    return subjects;
  }

  Future<bool> login() async {
    /*
    await Future.delayed(const Duration(seconds: 3));
    return false;
    */

    final headers = {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36'
    };

    // Startseite
    String url =
        "https://studonline.hs-bochum.de/qisserver/rds?state=user&type=0";
    var response = await Requests.get(url);
    // Login...
    Map<String, String> payload = {
      "asdf": username!,
      "fdsa": password!,
      "name": "submit"
    };
    url =
        "https://studonline.hs-bochum.de/qisserver/rds?state=user&type=1&category=auth.login";
    response = await Requests.post(
      url,
      headers: headers,
      body: payload,
    );

    //redirect muss manuell erfolgen
    // Überprüfung auf Redirect
    while (response.statusCode >= 300 && response.statusCode < 400) {
      final redirectUrl = response.headers['location'];
      if (redirectUrl == null) {
        throw Exception(
            'Redirect fehlgeschlagen: keine Redirect-URL gefunden.');
      }
      url = redirectUrl;
      response = await Requests.get(url, headers: headers);
    }

    //login checken
    url =
        'https://studonline.hs-bochum.de/qisserver/pages/cs/sys/portal/hisinoneIframePage.faces?id=info_angemeldete_pruefungen&navigationPosition=hisinoneMeinStudium%2Cinfo_angemeldete_pruefungen&recordRequest=true';
    response = await Requests.get(url, headers: headers);
    try {
      var document = parse(response.body);
      var iframe = document.getElementsByTagName('iframe').first;
      var iframeSrc = iframe.attributes['src']!;
      var start = iframeSrc.indexOf('asi%') + 4;
      asi = iframeSrc.substring(start);
    } catch (e) {
      asi = false;
    }

    if (asi == null || asi == false) {
      return Future.value(false);
    }

    return Future.value(true);
  }
}
