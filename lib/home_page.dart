import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:korstock/quote.dart';
import 'package:korstock/background.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> quotes;
  int n = 20;
  int begin;
  int coins;

  @override
  void initState() {
    super.initState();
    begin = 0;
    coins = 100;
    Quote.getQuoteMap().then((result) {
      setState(() {
        this.quotes = result;
        debugPrint(result.length.toString());
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

  void _showSnackBar(String text) {
    final snackBar = SnackBar( content: Text(text), );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    // Scaffold.of(context).showSnackBar(snackBar);
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
                        setState(() => doSell() );
                      },
                    ),
                  ),
                ])));
  }

  void doBuy() {
    int score = 0;
    double changes = getChange();
    if (changes >= 2.0) {
      score = 2;
    } else if (changes > -2) {
      score = -1;
    } else {
      score = -2;
    }
    begin++;
    if (begin > quotes.length - n) {
      begin = 0;
      score = 0;
      _showSnackBar('Data reset');
    }
    coins += score;
  }

  void doHold() {
    begin++;
    if (begin > quotes.length - n) {
      begin = 0;
      _showSnackBar('Data reset');
    }
  }

  void doSell() {
    int score = 0;
    double changes = getChange();
    if (changes >= 2.0) {
      score = -2;
    } else if (changes > -2) {
      score = -1;
    } else {
      score = 2;
    }
    begin++;
    if (begin > quotes.length - n) {
      begin = 0;
      score = 0;
      _showSnackBar('Data reset');
    }
    coins += score;
  }

  double getChange() {
    int last = begin + n - 2;
    var close = quotes[last];
    var close1 = quotes[last + 1];
    return (close1['close'] - close['close']) / close['close'] * 100;
  }

  Widget coinsWidget() {
    return Positioned(
        right: 20.0,
        top: 5.0,
        child: Row(children: <Widget>[
          Image.asset('img/coin.png', width: 40.0),
          Text('  coins: $coins',
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
                increaseColor: Colors.greenAccent,
                decreaseColor: Colors.redAccent,
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
