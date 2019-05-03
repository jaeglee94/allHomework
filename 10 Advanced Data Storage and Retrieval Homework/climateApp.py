from flask import Flask, render_template,jsonify
import sqlite3
import os
from datetime import datetime as dt
from datetime import timedelta

app = Flask(__name__)

@app.route("/")
def hello():
    return(render_template("index.html"))

@app.route("/api/v1.0/precipiation")
def precip():
    conn = sqlite3.connect(os.path.join("Resources","hawaii.sqlite"))
    curs = conn.cursor()
    rows = curs.execute("select * from measurement;")
    pdict = {}
    for row in rows:
        pdict[row[2]] =row[3]
    return jsonify(pdict)
    
@app.route("/api/v1.0/stations")
def station():
    conn = sqlite3.connect(os.path.join("Resources","hawaii.sqlite"))
    curs = conn.cursor()
    sList =[]
    rows = curs.execute("select * from station;")
    for row in rows:
        sList.append(row[1])
    return jsonify(sList)


@app.route("/api/v1.0/tobs")
def temp():
    conn = sqlite3.connect(os.path.join("Resources","hawaii.sqlite"))
    curs = conn.cursor()
    tList =[]
    curs.execute("select max(date) from measurement")
    rows = curs.fetchall()
    for row in rows:
        maxDate =(row[0])
    maxDate = dt.strptime(maxDate,'%Y-%m-%d')
    sDate = maxDate - timedelta(days=365)
    curs.execute("select date, tobs from measurement")
    rows = curs.fetchall()
    for row in rows:
        if row[0] >= str(sDate):
            tList.append(row)
    return jsonify(tList)

@app.route("/api/v1.0/tobs/<stDate>")
def tempDetail(stDate):
    conn = sqlite3.connect(os.path.join("Resources","hawaii.sqlite"))
    curs = conn.cursor()
    tList =[]
    curs.execute("select max(date) from measurement")
    rows = curs.fetchall()
    for row in rows:
        maxDate =(row[0])
    return jsonify(tList)


if __name__ == "__main__":
    app.run(debug=True)
