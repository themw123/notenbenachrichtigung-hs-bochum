import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:html/parser.dart' show parse;
import 'notification.dart';
import 'database.dart';
import 'package:requests/requests.dart';

class Request {
  final headers = {
    'Connection': 'keep-alive',
    'Accept': "*/*",
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36'
  };
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

    //cookie setzen
    //diesmal ohne request library. Stattdessen mit der standard http library.
    //weil requests library keine manuellen redirects unterstützt, die nicht 300-400 als status zurückgibt.

    //deshalb cookie auslesen und manuell einfügen
    String cookies = await getCookies();

    final client = HttpClient();
    var url = Uri.parse(
        "https://studonline.hs-bochum.de/qisserver/rds?state=redirect&sso=qis_mtknr&myre=state%253DexamsinfosStudent%2526next%253Dtree.vm%2526nextdir%253Dqispos/examsinfo/student%2526navigationPosition%253Dfunctions%2CexamsinfosStudent%2526breadcrumb%253Dinfoexams%2526topitem%253Dfunctions%2526subitem%253DexamsinfosStudent%2526asi%$asi");
    var request = await client.getUrl(url);
    request.followRedirects = false;
    //request.headers.set('Cookie', cookies);
    var response = await request.close();

    while (response.isRedirect) {
      await response.drain();
      final location = response.headers.value(HttpHeaders.locationHeader);
      if (location != null) {
        url = url.resolve(location);
        request = await client.getUrl(url);
        // Set the body or headers as desired.
        request.followRedirects = false;
        response = await request.close();
      }
    }
    // Do something with the final response.
    String body = await utf8.decodeStream(response);

    /*
    //redirect
    url =
        'https://studonline.hs-bochum.de/qisserver/rds?state=redirect&sso=qis_mtknr&myre=state%253DexamsinfosStudent%2526next%253Dtree.vm%2526nextdir%253Dqispos/examsinfo/student%2526navigationPosition%253Dfunctions%2CexamsinfosStudent%2526breadcrumb%253Dinfoexams%2526topitem%253Dfunctions%2526subitem%253DexamsinfosStudent%2526asi%$asi';

    response = await Requests.get(url, headers: headers);
    //redirect
    */

/*
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    var test = "";
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    // asi erneut holen von Seite 'Bitte wählen Sie aus:'
    var soup = BeautifulSoup(body);
    var pElement = soup.find('p', string: 'Bitte wählen Sie aus:');
    var parentElement = pElement?.parent;
    var action = parentElement?['action'];
    var start = action?.indexOf('asi=') ?? 0 + 4;
    asi = action?.substring(start, action.length);

    if (asi == null || asi == '') {
      NotificationManager.showNotification("Test Notification",
          "Die Noten konnten nicht aktualisiert werden. Zweiter Asi konnte nicht ermittelt werden.");
      return await DatabaseHelper.getSubjects();
    }

    // noten
    url =
        'https://std-info.hs-bochum.de/qisserver/rds?state=examsinfosStudent&next=list.vm&nextdir=qispos/examsinfo/student&createInfos=Y&struct=auswahlBaum&nodeID=auswahlBaum|abschluss%3Aabschl%3D84%2Cstgnr%3D1&expand=1&asi=$asi';
    response = await Requests.get(url);
    var pruefungen = response.body;
  */
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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

  Future<String> getCookies() async {
    String uri = "https://studonline.hs-bochum.de/";
    String hostname = Requests.getHostname(uri);
    var cookieJar = await Requests.getStoredCookies(hostname);
    var cookiesHeader = [
      "${cookieJar.delegate.keys.first}=${cookieJar.delegate.values.first.value}",
      "${cookieJar.delegate.keys.elementAt(1)}=${cookieJar.delegate.values.elementAt(1).value}",
    ];
    return cookiesHeader.join('; ');
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie']!;
    // ignore: unnecessary_null_comparison
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
