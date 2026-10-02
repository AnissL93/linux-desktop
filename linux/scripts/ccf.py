#!/usr/bin/env python3

from bs4 import BeautifulSoup
import pprint
import requests
import xmltodict


url = "https://ccf.atom.im/"

req = requests.get(url)

if req.status_code != 200:
    print("URL invalid")
    exit(-1)

page = BeautifulSoup(req.text, "html.parser")
tbody = page.find_all("tbody")

print(len(tbody))
for body in tbody:
    trs = body.find_all("tr")
    print(len(trs))
    for tr in trs:
        tds = tr.find_all("td")
        short = tds[0].text
        full = tds[1].text
        rank = tds[2].text
        type = tds[3].text
        field = tds[4].text

        if len(short) > 0:
            key = short + " (" + full + ") [" + rank + "] " + type + " " + field + ";"
        else:
            key = full + " [" + rank + "] " + type + " " + field + ";"

        print(key)
