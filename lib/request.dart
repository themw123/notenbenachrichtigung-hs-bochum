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
        '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html lang="de"><head><!-- Generated by node "" in cluster "" using thread ajpnio-0.0.0.0-8009-exec-8 --><title>Hochschule Bochum </title><link rel="stylesheet" type="text/css" href="/qisserver/pub/QISDesign_FHBO.css"><link rel="icon" href="favicon.ico" type="image/gif"><link rel="top" href="https://std-info.hs-bochum.de/qisserver/rds?state=user&amp;type=0&amp;topitem=" title="Top"><link rel="stylesheet" type="text/css" media="print" href="/qisserver/pub/Print.css"><meta http-equiv="content-type" content="text/html; charset=UTF-8"><meta http-equiv="Cache-Control" content="private,must-revalidate,no-cache,no-store"><!--[if gte IE 6]><style type="text/css">html{overflow-x:scroll;}body{margin-right:28px;}</style><![endif]--></head><body><div id="wrapper"><div class="divcontent"><div class="content_full_portal"><a name="lese"></a><h1>Info über angemeldete Prüfungen</h1><div class="abstand_pruefinfo"></div><table summary="Liste der angemeldete Prüfungen des Studierenden" border="0"><caption class="t_capt">Liste der angemeldeten Pr&uuml;fungen des Studierenden</caption><tr><th class="mod_header" id="basic_1">Name des Studierenden</th><td class="mod_n_basic" headers="basic_1">Marvin&nbsp;Walczak</td></tr><tr><th class="mod_header" id="basic_2">Geburtsdatum und -ort</th><td class="mod_n_basic" headers="basic_2">29.06.1998 in Witten</td></tr><tr><th class="mod_header" id="basic_3">(angestrebter) Abschluss</th><td class="mod_n_basic" headers="basic_3">[84]&nbsp;Bachelor</td></tr><tr><th class="mod_header" id="basic_5">Matrikelnummer</th><td class="mod_n_basic" headers="basic_5">18309434</td></tr><tr><th class="mod_header" id="basic_6">Anschrift</th><td class="mod_n_basic" headers="basic_6">Baedekerstraße 18,&nbsp;58453&nbsp;Witten</td></tr></table><div class="abstand_pruefinfo"></div><table border="0" width="100%"><tr><th class="tabelleheader" align="left" colspan="9"> <i>Abschluss:</i> Bachelor<i>Studiengang:</i> Wirtschaftsinformatik</th></tr><tr><th scope="col" align="left" class="tabelleheader">Prüfungsnr.</th><th scope="col" align="left" class="tabelleheader">Prüfungstext</th><th scope="col" align="left" class="tabelleheader">Pr&uuml;fer/-in</th><th scope="col" align="left" class="tabelleheader">Semester</th><th scope="col" align="left" class="tabelleheader">Anmeldedatum</th><th scope="col" align="left" class="tabelleheader">Prüfungsdatum</th><th scope="col" align="left" class="tabelleheader">Pr&uuml;fungsraum</th><th scope="col" align="left" class="tabelleheader">Beginn</th><th scope="col" align="left" class="tabelleheader">Versuch</th></tr><tr><td class="mod_n">3031</td><td class="mod_n">Informations- und Kommunikationssysteme 2</td><td class="mod_n">Brockmann/Schennonek</td><td class="mod_n">SS 23</td><td class="mod_n">03.04.2023</td><td class="mod_n"> </td><td class="mod_n"> </td><td class="mod_n"> </td><td class="mod_n">1</td></tr><tr><td class="mod_n">4021</td><td class="mod_n">Einführung in moderne Webtechnologien 1</td><td class="mod_n">Köhn</td><td class="mod_n">WS 22/23</td><td class="mod_n">28.11.2022</td><td class="mod_n">06.03.2023</td><td class="mod_n"> </td><td class="mod_n">13:00</td><td class="mod_n">1</td></tr></table><br><br><!-- <a class="liste1" href="https://std-info.hs-bochum.de/qisserver/rds?state=hisreports&amp;status=receive&amp;publishid=84,18309434&amp;vmfile=no&amp;moduleCall=AngemeldeteInabschluss&amp;lastState=examsinfosStudent&amp;xslobject=de&amp;asi=HkCAlrnpw.9iVnI5MY61"> --><a class="liste1"href="https://std-info.hs-bochum.de/qisserver/rds?state=hisreports&amp;status=receive&amp;publishid=84&amp;vmfile=no&amp;moduleCall=AngemeldeteInabschluss&amp;lastState=examsinfosStudent&amp;xslobject=de&amp;asi=HkCAlrnpw.9iVnI5MY61"><img src="/QIS/images//print_pdf.svg" alt="PDF-Druck"> </a><br><br><form METHOD="POST"action="https://std-info.hs-bochum.de/qisserver/rds?state=examsinfosStudent&amp;nextdir=qispos/examsinfo/student&amp;asi=HkCAlrnpw.9iVnI5MY61"><input class="submit" type="Submit" name="auswahlButton" value="Auswahlseite"></form></div><div style="clear: both;"></div></div><!--<img src="/QIS/images//his_logoklein.gif" alt="Hochschul Informations-System eG" border="0">--></div><script type="text/javascript" src="/qisserver/resources/bower_components/jquery/dist/jquery.min.js"></script><script type="text/javascript" src="/qisserver/pub/js/qis-00000001.js"></script><script type="text/javascript" src="/qisserver/pub/js/qrCode.js"></script><script type="text/javascript" src="/qisserver/pub/js/lsfpageobserver_functions.js"></script><script type="text/javascript" src="/qisserver/pub/js/lsfpageobserver_language_init.js"></script><script type="text/javascript" src="/qisserver/pub/js/lsfpageobserver.js"></script><script src="/qisserver/pub//js/availability.js" type="text/javascript"></script></body></html>';
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
