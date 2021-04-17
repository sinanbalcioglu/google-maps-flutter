import 'dart:convert';
import 'dart:io';
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
  var _randomQuote = '-';

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Famous Quotes'),
      ),
      body: new Center(

        child : new Padding(
          padding: new EdgeInsets.all(20.0),
          child : new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(_randomQuote,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.toDouble())),
              spacer,
              spacer,
              new ElevatedButton(
                onPressed: _getRandomQuote,
                child: new Text('Get a Random Quote'),
              ),
            ],
          ),
        ),
      ),
    );
}


_getRandomQuote() async {
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
        var pickup = data[i]['tpep_pickup_datetime'].toString();
        var passCount = data[i]['passenger_count'].toString();
        var line = pickup + " - " + passCount + "\n";
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
    _randomQuote = result;
  });
}
}