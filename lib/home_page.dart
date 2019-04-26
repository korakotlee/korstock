import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:korstock/candle.dart';
import 'package:korstock/pattern.dart';
import 'package:korstock/quote.dart';
import 'package:korstock/background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'moving_average.dart';
import 'ichimoku.dart';

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
  List maVol;
  List ichimoku;
  int begin = 0;
  int coins = 100;
  int last;
  double price;
  double change;
  String help;

  @override
  void initState() {
    super.initState();
    change = 0;
    last = n-2;
    if (begin != 0) getSharedPrefs();
    setSharedPrefs();
    rootBundle.loadString("assets/help.txt").then((text) => this.help = text);
    Quote.getQuoteMap().then((result) {
      setState(() {
        this.quotes = result.reversed.toList();
        maVol = ma(quotes, 20);
        Ichimoku ichi = new Ichimoku(quotes);
        ichimoku = ichi.calc();
        price = quotes[last]['close'];
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
                  buttons(),
                  showPrice(),
                ]),
          ),
        ));
  }

  void showHelp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xffFDF6E3),
            actions: <Widget>[
              FlatButton(
                  child: Text('OK', style: TextStyle(color: Colors.indigo)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
            title: Text('KorStock'),
            content: Text(help),
          );
        });
  }

  Future<Null> setSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("coins", coins);
    prefs.setInt("begin", begin);
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int result;
    result = prefs.getInt("coins");
    if (result != null)
      coins = result;
    else
      coins = 100;
    result = prefs.getInt("begin");
    if (result != null)
      begin = result;
    else
      begin = 0;
    last = begin + n - 2;
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

  Widget button(String text, Function action) {
    return ButtonTheme(
      minWidth: 88.0,
      height: 36.0,
      buttonColor: Colors.indigo,
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        shape: StadiumBorder(),
        onPressed: () {
          setState(() => action());
        },
      ),
    );
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
            button('BUY', doBuy),
            button('HOLD', doHold),
            button('SELL', doSell),
            button('HELP', showHelp),
          ])));
  }

  Widget showPrice() {
    if (price==null) return Container();
    return Positioned(
      right: 150,
      bottom: 100,
      child: Text(
        '$price (${change.toStringAsFixed(2)}%)',
        style: TextStyle(fontFamily: "Bitter", fontSize: 18.0),
      ),
    );
  }

  void _checkCandle() {
    last = begin + n - 2;
    var q = quotes[last + 1]; // new bar
    var q1 = quotes[last]; // current bar
    var q2 = quotes[last - 1]; // previous bar
    price = q['close'];
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
    getChange();
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
    begin++;
    if (begin > quotes.length - n) {
      begin = 0;
      score = 0;
      _showSnackBar('Data reset', Colors.white);
    }
    coins -= score;
  }

  double getChange() {
    int last = begin + n - 2;
    var q1 = quotes[last];
    var q = quotes[last + 1];
    double changes = (q['close'] - q1['close']) / q1['close'] * 100;
    change = changes;
    setSharedPrefs();
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
                // begin: begin,
                maVol: this.maVol.sublist(begin, end),
                ichimoku: this.ichimoku.sublist(begin, end),
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
