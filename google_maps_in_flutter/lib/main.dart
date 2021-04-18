import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: Scaffold(
          body: Center(
              child: Column(children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
                    child: Image(
                      image: AssetImage('assets/mainLogo.png'),
                      height: 300,
                      width: 300,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20.0,50,20.0,0),
                    child: ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Text('Query 1'),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new firstQueryResponse()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    )),
                Container(
                    child: ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Text('Query 2'),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new secondQueryInput()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    )),
                Container(
                    child: ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Text('Query 3'),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new firstQueryResponse()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    )),
              ])),
        ));
  }
}

// ignore: camel_case_types
class firstQueryResponse extends StatefulWidget {
  @override
  createState() => new firstQueryState();
}

// ignore: camel_case_types
class firstQueryState extends State<firstQueryResponse> {
  var _queryResult = '';

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: Text('First Query Results'),
      ),
      body: Center(
          child : Column(children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 50) ,
                child: Text("En fazla yolcu taşınan 5 gün ve toplam yolcu sayıları", textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20) ,
                child: Column(children: <Widget>[
                  Text("Tarih/Saat            Yolcu Sayısı", textAlign: TextAlign.left ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                ],
                )
              ),
            ),
            Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child : Text(_queryResult,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                ),
              )
            ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getFirstQueryResult();
  }

  _getFirstQueryResult() async {
    var url = 'https://us-central1-heroic-muse-310011.cloudfunctions.net/firstQuery';
    var httpClient = new HttpClient();
    String result="";
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonResponse = await response.transform(utf8.decoder).join();
        var newResponse = jsonResponse.substring(1,jsonResponse.length-1);
        print(newResponse);
        var data = json.decode(newResponse);

        for(var i=0; i<5; i++){
          var pickup = (DateFormat('dd.MM.yyyy hh:mm aaa').format(DateTime.fromMillisecondsSinceEpoch(data[i]['tpep_pickup_datetime']*1000))).toString();
          var passCount = data[i]['passenger_count'].toString();
          var line = pickup + "     -    " + passCount + "\n\n";
          result = result + line;
        }

      } else {
        result =
        'Error getting a random quote:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getRandomQuote function.';
    }

    setState(() {
      _queryResult = result;
    });
  }
}

class secondQueryInput extends StatefulWidget {
  @override
  createState() => new _sqIState();
}

var timestamp1,timestamp2;
class _sqIState extends State<secondQueryInput>{
  DateTime? _dateTime1,_dateTime2;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: Text(''),
      ),
      body: Center(
        child : Column(
            children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 40) ,
              child: Column(
                children: <Widget>[
                  Text("İki tarih arasında seyahat edilen en az mesafeli 5 yolculuk", textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
              ],
              )
          ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)),
                  onPressed: (){
                    showDatePicker(
                        context: context,
                        initialDate: DateTime(2020,12),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2021)
                    ).then((date){
                      setState(() {
                        _dateTime1 = date;
                        timestamp1 = (date!.microsecondsSinceEpoch/1000000).round();
                        print(timestamp1);
                      });
                    });
                  },
                  child: Text(_dateTime1 == null ? 'Başlangıç Tarihini Seç' : _dateTime1.toString()),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber) ),
                  onPressed: (){
                    showDatePicker(
                        context: context,
                        initialDate: DateTime(2020,12),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2021)
                    ).then((date){
                      setState(() {
                        _dateTime2 = date;
                        timestamp2 = (date!.microsecondsSinceEpoch/1000000).round();
                        print(timestamp2);
                      });
                    });
                  },
                  child: Text(_dateTime2 == null ? 'Bitiş Tarihini Seç' : _dateTime2.toString()),
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 40) ,
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => new secondQueryResult()),
                      );
                    },
                    child: Text('Sorgula!', textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.toDouble())),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class secondQueryResult extends StatefulWidget {
  @override
  createState() => new _sQRState();
}

class _sQRState extends State<secondQueryResult> {
  var _queryResult = '';

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: Text('Second Query Results'),
      ),
      body: Center(
        child : Column(children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 50) ,
              child: Text("İki tarih arasında seyahat edilen en az mesafeli 5 yolculuk", textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
            ),
          ),
          Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20) ,
                child: Column(children: <Widget>[
                  Text("Tarih/Saat            Mesafe", textAlign: TextAlign.left ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                ],
                )
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child : Text(_queryResult,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
            ),
          )
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getSecondQueryResult();
  }

  _getSecondQueryResult() async {
    var startDate = timestamp1.toString();
    var endDate = timestamp2.toString();
    var url = 'https://us-central1-heroic-muse-310011.cloudfunctions.net/secondQuery?startDate='+startDate+'&endDate='+endDate;
    var httpClient = new HttpClient();
    String result="";
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonResponse = await response.transform(utf8.decoder).join();
        var newResponse = jsonResponse.substring(1,jsonResponse.length-1);
        print(newResponse);
        var data = json.decode(newResponse);

        for(var i=0; i<5; i++){
          var pickup = (DateFormat('dd.MM.yyyy hh:mm aaa').format(DateTime.fromMillisecondsSinceEpoch(data[i]['tpep_pickup_datetime']*1000))).toString();
          var passCount = data[i]['trip_distance'].toString();
          var line = pickup + "     -    " + passCount + "\n\n";
          result = result + line;
        }

      } else {
        result =
        'Error getting a random quote:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getRandomQuote function.';
    }

    setState(() {
      _queryResult = result;
    });
  }
}