import 'dart:io';

import 'package:http/http.dart';

import 'package:html/parser.dart' show parse;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'notification.dart';
import 'database.dart';

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

    //cookie setzen
    /*
    //redirect
    url =
        'https://studonline.hs-bochum.de/qisserver/rds?state=redirect&sso=qis_mtknr&myre=state%253DexamsinfosStudent%2526next%253Dtree.vm%2526nextdir%253Dqispos/examsinfo/student%2526navigationPosition%253Dfunctions%2CexamsinfosStudent%2526breadcrumb%253Dinfoexams%2526topitem%253Dfunctions%2526subitem%253DexamsinfosStudent%2526asi%$asi';

    response = await Requests.get(url, headers: headers);
    //redirect
    */

/*

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

    //header obj
    //accept wichtig sonnst geht redirect nicht!
    var headers = {
      "Accept": "*/*",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    var cookieJar = CookieJar(); // some dio configurations
    var dio = Dio(BaseOptions(
        responseType: ResponseType.plain,
        headers: headers,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        }));
    dio.interceptors.add(CookieManager(cookieJar));

    // Startseite
    String url =
        "https://studonline.hs-bochum.de/qisserver/rds?state=user&type=0";

    var response = await dio.get(url);
    while (response.statusCode == 302) {
      url = response.headers.value('location')!;
      response = await dio.get(url);
    }

    // Login...
    Map<String, String> payload = {
      "asdf": username!,
      "fdsa": password!,
      "name": "submit"
    };
    url =
        "https://studonline.hs-bochum.de/qisserver/rds?state=user&type=1&category=auth.login";
    response = await dio.post(
      url,
      data: payload,
    );

    while (response.statusCode == 302) {
      url = response.headers.value('location')!;
      response = await dio.get(url);
    }

    //login checken
    url =
        'https://studonline.hs-bochum.de/qisserver/pages/cs/sys/portal/hisinoneIframePage.faces?id=info_angemeldete_pruefungen&navigationPosition=hisinoneMeinStudium%2Cinfo_angemeldete_pruefungen&recordRequest=true';
    response = await dio.get(url);
    try {
      var document = parse(response.data);
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
