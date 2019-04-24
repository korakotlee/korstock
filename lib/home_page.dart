import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:korstock/pattern.dart';
import 'package:korstock/quote.dart';
import 'package:korstock/background.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final int n = 20; // number of bars
  final threshold = 0.5;

  List<Map<String, dynamic>> quotes;
  int begin;
  int coins;

  @override
  void initState() {
    super.initState();
    begin = 0;
    coins = 100;
    Quote.getQuoteMap().then((result) {
      setState(() {
        this.quotes = result.reversed.toList();
        // debugPrint(result.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setLandscape();
    return new Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Builder(
            builder: (context) => Stack(children: <Widget>[
                  Background("KorStock"),
                  candle(),
                  coinsWidget(),
                  buttons()
                ]),
          ),
        ));
  }

  void _showSnackBar(String text, Color color) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: color),
      ),
      duration: Duration(milliseconds: 500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget buttons() {
    return Positioned(
        bottom: 40,
        right: 10,
        child: Container(
            height: 300,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 88.0,
                    height: 36.0,
                    buttonColor: Colors.indigo,
                    child: RaisedButton(
                      child: Text(
                        'BUY',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: StadiumBorder(),
                      onPressed: () {
                        setState(() => doBuy());
                      },
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 88.0,
                    height: 36.0,
                    buttonColor: Colors.indigo,
                    child: RaisedButton(
                      child: Text(
                        'HOLD',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: StadiumBorder(),
                      onPressed: () {
                        setState(() => doHold());
                      },
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 88.0,
                    height: 36.0,
                    buttonColor: Colors.indigo,
                    child: RaisedButton(
                      child: Text(
                        'SELL',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: StadiumBorder(),
                      onPressed: () {
                        setState(() => doSell());
                      },
                    ),
                  ),
                ])));
  }

  void _checkCandle() {
    // bool pattern;
    int last = begin + n - 2;
    var q = quotes[last + 1]; // new bar
    var q1 = quotes[last]; // current bar
    var q2 = quotes[last - 1]; // previous bar
    List<Pattern> results = detectPattern(q, q1, q2);

    results.forEach((result) {
      _showSnackBar(result.text, result.color);
    });
  }

  void doBuy() {
    int score = 0;
    double changes = getChange();
    score = changes.round();

    _checkCandle();
    // if (changes >= threshold) {
    //   score = 1;
    // } else if (changes > -threshold) {
    //   score = 0;
    // } else {
    //   score = -1;
    // }
    // int last = begin + n - 2;
    // var q1 = quotes[last];
    // var q = quotes[last + 1];
    // debugPrint('score: $score');
    // debugPrint('new: ${q['close']}, last: ${q1['close']} changes: $changes');

    begin++;
    if (begin > quotes.length - n) {
      begin = 0;
      score = 0;
      _showSnackBar('Data reset', Colors.white);
    }
    coins += score;
  }

  void doHold() {
    _checkCandle();
    begin++;
    if (begin > quotes.length - n) {
      begin = 0;
      _showSnackBar('Data reset', Colors.white);
    }
  }

  void doSell() {
    int score = 0;
    double changes = getChange();
    score = changes.round();

    _checkCandle();
    // if (changes >= threshold) {
    //   score = -1;
    // } else if (changes > -threshold) {
    //   score = 0;
    // } else {
    //   score = 1;
    // }
    begin++;
    if (begin > quotes.length - n) {
      begin = 0;
      score = 0;
      _showSnackBar('Data reset', Colors.white);
    }
    coins += score;
  }

  double getChange() {
    int last = begin + n - 2;
    var q1 = quotes[last];
    var q = quotes[last + 1];
    double changes =  (q['close'] - q1['close']) / q1['close'] * 100;
    debugPrint(changes.toString());
    return changes;
  }

  Widget coinsWidget() {
    return Positioned(
        right: 20.0,
        top: 5.0,
        child: Row(children: <Widget>[
          Image.asset('img/coin.png', width: 30.0),
          Text(' : $coins',
              style: TextStyle(
                  fontSize: 18, fontFamily: "Bitter", color: Color(0xff308eab)))
        ]));
  }

  Widget candle() {
    if (quotes == null) {
      return Container();
    }
    int end = begin + n - 1;
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 10.0, left: 10.0),
            child: OHLCVGraph(
                increaseColor: Color(0xff53B987),
                decreaseColor: Color(0xffEB4D5C),
                data: this.quotes.sublist(begin, end),
                enableGridLines: true,
                labelPrefix: '',
                volumeProp: 0.2),
          ),
        ),
        Container(
          width: 100.0,
        )
      ],
    );
  }

  void setLandscape() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }
}
