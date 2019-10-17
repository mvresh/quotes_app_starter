import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MaterialApp(
    home: QuotesPage(),
  ));
}
bool apiCall = false;
class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  String quote = 'Time is not the main thing. It is the only thing.';
  String author = 'Miles Davis';

  Future<Map> getQuote() async {
    Map decodedMap;
    Response response = await get('https://favqs.com/api/qotd');
    if (response.statusCode == 200) {
      decodedMap = jsonDecode(response.body);
    }
    return decodedMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$quote',
                style: TextStyle(fontFamily: 'Playfair', fontSize: 30),
                textAlign: TextAlign.left,
              ),
              SizedBox(height:20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$author',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.left,
                  )),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RawMaterialButton(
                  constraints: BoxConstraints.tightFor(width: 60,height: 60),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  onPressed: () async{
                    setState(() {
                      apiCall = true;
                    });
                    Map finalQuoteMap = await getQuote();
                    setState(() {
                      quote = finalQuoteMap['quote']['body'];
                      author = finalQuoteMap['quote']['author'];
                      apiCall = false;
                    });
                  },
                  child: apiCall == false?Icon(Icons.arrow_forward,color: Colors.red,size: 30,):CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green),strokeWidth: 1,),
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
