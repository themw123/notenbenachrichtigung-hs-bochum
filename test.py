#!/usr/bin/env python3
# -- coding: utf-8 --

import hashlib
import sys
import urllib.parse as urlparse
from pathlib import Path
from urllib.parse import parse_qs

import lxml.html as lh
import requests
from bs4 import BeautifulSoup

session_requests = requests.session()
session_requests.headers.update({
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36'})


# startseite
url = "https://studonline.hs-bochum.de/qisserver/rds?state=user&type=0"
print("Rufe Startseite auf\n")
result = session_requests.get(url)


# login...
print("Einloggen...\n")
payload = {
    "asdf": "***REMOVED***",
    "fdsa": "***REMOVED***",
    "name": "submit"
}
url = "https://studonline.hs-bochum.de/qisserver/rds?state=user&type=1&category=auth.login"
result = session_requests.post(
    url,
    data=payload
)


# asi erstmals holen von Seite 'Bitte wählen Sie aus:' mit erstmaligen Aufruf
url = "https://studonline.hs-bochum.de/qisserver/pages/cs/sys/portal/hisinoneIframePage.faces?id=info_angemeldete_pruefungen&navigationPosition=hisinoneMeinStudium%2Cinfo_angemeldete_pruefungen&recordRequest=true"
result = session_requests.get(url)

asi = None
soup = BeautifulSoup(result.text, 'html.parser')
iframe = soup.find('iframe')
iframe_src = iframe['src']
start = iframe_src.find('asi%')+4
asi = iframe_src[start:len(iframe_src)]

if asi is None or asi == "":
    print("asi couldn't be extracted")
    sys.exit()


# cookie setzten mittels asi
print("cookie setzten\n")
url = "https://studonline.hs-bochum.de/qisserver/rds?state=redirect&sso=qis_mtknr&myre=state%253DexamsinfosStudent%2526next%253Dtree.vm%2526nextdir%253Dqispos/examsinfo/student%2526navigationPosition%253Dfunctions%2CexamsinfosStudent%2526breadcrumb%253Dinfoexams%2526topitem%253Dfunctions%2526subitem%253DexamsinfosStudent%2526asi%"+asi
result = session_requests.get(url)
test = result.content


# asi erneut holen
# asi erneut holen von Seite 'Bitte wählen Sie aus:'
asi = None
soup = BeautifulSoup(result.text, 'html.parser')
p_element = soup.find('p', string='Bitte wählen Sie aus:')
parent_element = p_element.parent
action = parent_element['action']
start = action.find('asi=')+4
asi = action[start:len(action)]

if asi is None or asi == "":
    print("asi couldn't be extracted")
    sys.exit()

# noten
print("Austehende Pruefungen holen\n")
url = "https://std-info.hs-bochum.de/qisserver/rds?state=examsinfosStudent&next=list.vm&nextdir=qispos/examsinfo/student&createInfos=Y&struct=auswahlBaum&nodeID=auswahlBaum|abschluss%3Aabschl%3D84%2Cstgnr%3D1&expand=1&asi="+asi
result = session_requests.get(url)


pruefungen = result.content
print(pruefungen)
