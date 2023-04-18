// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:beautiful_soup_dart/beautiful_soup.dart';
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

  static var headers;
  static var cookieJar;
  static var dio;

  static final Request _singleton = Request._internal();
  factory Request(String username, String password) {
    _singleton.username = username;
    _singleton.password = password;

    //beides wichtig!
    headers = {
      "Accept": "*/*",
      "Content-Type": "application/x-www-form-urlencoded",
    };
    cookieJar = CookieJar();
    dio = Dio(BaseOptions(
        responseType: ResponseType.plain,
        headers: headers,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        }));
    dio.interceptors.add(CookieManager(cookieJar));

    return _singleton;
  }

  Request._internal();

  Future<List<Map<String, dynamic>>> subjects() async {
    //künstliche ladezeit
    //await Future.delayed(const Duration(seconds: 3));

    //!!!!!!!!!!!!!!!!!!!!!!wieder einschalten!!!!!!!!!!!!!!!!!!!!!!
    //bool success = await login();
    bool success = true;
    //!!!!!!!!!!!!!!!!!!!!!!wieder einschalten!!!!!!!!!!!!!!!!!!!!!!

    NotificationManager.init();
    if (!success) {
      NotificationManager.showNotification("Test Notification",
          "Die Noten konnten nicht aktualisiert werden. Login fehlgeschlagen. ");
      return await DatabaseHelper.getSubjects();
    }
    //!!!!!!!!!!hier subjects von hs bochum holen!!!!!!!!!!!!!!!!!!

    /*
    //cookie setzen
    var url =
        'https://studonline.hs-bochum.de/qisserver/rds?state=redirect&sso=qis_mtknr&myre=state%253DexamsinfosStudent%2526next%253Dtree.vm%2526nextdir%253Dqispos/examsinfo/student%2526navigationPosition%253Dfunctions%2CexamsinfosStudent%2526breadcrumb%253Dinfoexams%2526topitem%253Dfunctions%2526subitem%253DexamsinfosStudent%2526asi%$asi';

    var response = await dio.get(url);
    while (response.statusCode == 302) {
      url = response.headers.value('location')!;
      response = await dio.get(url);
    }

    // asi erneut holen von Seite 'Bitte wählen Sie aus:'
    var soup = BeautifulSoup(response.data);
    var pElement = soup.find('p', string: 'Bitte wählen Sie aus:');
    var parentElement = pElement?.parent;
    var action = parentElement?['action'];
    // ignore: prefer_interpolation_to_compose_strings
    int? start = action?.indexOf('asi=');
    asi = action?.substring(start! + 4, action.length);

    if (asi == null || asi == '') {
      NotificationManager.showNotification("Test Notification",
          "Die Noten konnten nicht aktualisiert werden. Zweiter Asi konnte nicht ermittelt werden.");
      return await DatabaseHelper.getSubjects();
    }

    // noten holen
    url =
        'https://std-info.hs-bochum.de/qisserver/rds?state=examsinfosStudent&next=list.vm&nextdir=qispos/examsinfo/student&createInfos=Y&struct=auswahlBaum&nodeID=auswahlBaum%7Cabschluss%3Aabschl%3D84%2Cstgnr%3D1&expand=1&asi=$asi';
    response = await dio.get(url);

    var pruefungen = response.data;
    */
    List<Map<String, dynamic>> subjects = [];
    var html =
        '***REMOVED***';
    var document = parse(html);
    var tables = document.getElementsByTagName('table');
    var secondTable = tables[1];
    final trs = secondTable.querySelectorAll('tr');
    int counter = 0;
    for (var tr in trs) {
      if (counter > 1) {
        final tds = tr.querySelectorAll('td');
        var subject = tds[1].text;
        var pruefer = tds[2].text;
        var datum = tds[5].text;
        var raum = tds[6].text;
        var uhrzeit = tds[7].text;

        subjects.add({
          DatabaseHelper.columnSubject: subject,
          DatabaseHelper.columnPruefer: pruefer,
          DatabaseHelper.columnDatum: datum,
          DatabaseHelper.columnRaum: raum,
          DatabaseHelper.columnUhrzeit: uhrzeit,
          DatabaseHelper.columnOld: 0,
        });
      }
      counter++;
    }
    List<Map<String, dynamic>> subjectsOld = await DatabaseHelper.getSubjects();
    var newGrades = compare(subjects, subjectsOld);
    String newGradesText = "";
    String text = "Note";
    for (var newGrade in newGrades!) {
      newGradesText += newGrade['subject'];
    }
    if (newGrades.isNotEmpty) {
      if (newGrades.length > 1) {
        text = "Noten";
      }
      NotificationManager.showNotification(
          "Neue $text erhalten!", "Du hast neue $text in: $newGradesText .");
    }
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //ergänze noch: wenn neue note in table noten old speichern
    await DatabaseHelper.setSubjects(subjects);
    return await DatabaseHelper.getSubjects();
  }

  List<Map<String, dynamic>>? compare(List<Map<String, dynamic>> subjects,
      List<Map<String, dynamic>> subjectsOld) {
    List<Map<String, dynamic>> newGrades = [];
    for (var subjectOld in subjectsOld) {
      if (!subjects.contains(subjectOld)) {
        newGrades.add(subjectOld);
      }
    }
    return newGrades;
  }

  Future<bool> login() async {
    /*
    await Future.delayed(const Duration(seconds: 3));
    return false;
    */

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
