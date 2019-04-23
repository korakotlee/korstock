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
  final int n = 20; // number of bars
  final threshold = 1.0;

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
    final snackBar = SnackBar( content: Text(text), duration: Duration(milliseconds: 500),);
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
                        setState(() => doSell() );
                      },
                    ),
                  ),
                ])));
  }

  void _checkCandle() {
    double dojiSize = 0.05;
    int last = begin + n - 2;
    // var close = quotes[last];
    var close1 = quotes[last + 1];
    bool doji = ((close1['open'] - close1['close']).abs() <= (close1['high'] - close1['low']) * dojiSize);
    if (doji) _showSnackBar('doji');
    
// data2=(close[2] > open[2] and min(open[1], close[1]) > close[2] and open < min(open[1], close[1]) and close < open )
// plotshape(data2, title= "Evening Star", color=red, style=shape.arrowdown, text="Evening\nStar")

// data3=(close[2] < open[2] and max(open[1], close[1]) < close[2] and open > max(open[1], close[1]) and close > open )
// plotshape(data3,  title= "Morning Star", location=location.belowbar, color=lime, style=shape.arrowup, text="Morning\nStar")

// data4=(open[1] < close[1] and open > close[1] and high - max(open, close) >= abs(open - close) * 3 and min(close, open) - low <= abs(open - close))
// plotshape(data4, title= "Shooting Star", color=red, style=shape.arrowdown, text="Shooting\nStar")

// data5=(((high - low)>3*(open -close)) and  ((close - low)/(.001 + high - low) > 0.6) and ((open - low)/(.001 + high - low) > 0.6))
// plotshape(data5, title= "Hammer", location=location.belowbar, color=white, style=shape.diamond, text="H")

// data5b=(((high - low)>3*(open -close)) and  ((high - close)/(.001 + high - low) > 0.6) and ((high - open)/(.001 + high - low) > 0.6))
// plotshape(data5b, title= "Inverted Hammer", location=location.belowbar, color=white, style=shape.diamond, text="IH")


// data6=(close[1] > open[1] and open > close and open <= close[1] and open[1] <= close and open - close < close[1] - open[1] )
// plotshape(data6, title= "Bearish Harami",  color=red, style=shape.arrowdown, text="Bearish\nHarami")

// data7=(open[1] > close[1] and close > open and close <= open[1] and close[1] <= open and close - open < open[1] - close[1] )
// plotshape(data7,  title= "Bullish Harami", location=location.belowbar, color=lime, style=shape.arrowup, text="Bullish\nHarami")

// data8=(close[1] > open[1] and open > close and open >= close[1] and open[1] >= close and open - close > close[1] - open[1] )
// plotshape(data8,  title= "Bearish Engulfing", color=red, style=shape.arrowdown, text="Bearish\nEngulfing")

// data9=(open[1] > close[1] and close > open and close >= open[1] and close[1] >= open and close - open > open[1] - close[1] )
// plotshape(data9, title= "Bullish Engulfing", location=location.belowbar, color=lime, style=shape.arrowup, text="Bullish\nEngulfling")

// upper = highest(10)[1]
// data10=(close[1] < open[1] and  open < low[1] and close > close[1] + ((open[1] - close[1])/2) and close < open[1])
// plotshape(data10, title= "Piercing Line", location=location.belowbar, color=lime, style=shape.arrowup, text="Piercing\nLine")

// lower = lowest(10)[1]
// data11=(low == open and  open < lower and open < close and close > ((high[1] - low[1]) / 2) + low[1])
// plotshape(data11, title= "Bullish Belt", location=location.belowbar, color=lime, style=shape.arrowup, text="Bullish\nBelt")

// data12=(open[1]>close[1] and open>=open[1] and close>open)
// plotshape(data12, title= "Bullish Kicker", location=location.belowbar, color=lime, style=shape.arrowup, text="Bullish\nKicker")

// data13=(open[1]<close[1] and open<=open[1] and close<=open)
// plotshape(data13, title= "Bearish Kicker", color=red, style=shape.arrowdown, text="Bearish\nKicker")

// data14=(((high-low>4*(open-close))and((close-low)/(.001+high-low)>=0.75)and((open-low)/(.001+high-low)>=0.75)) and high[1] < open and high[2] < open)
// plotshape(data14,  title= "Hanging Man", color=red, style=shape.arrowdown, text="Hanging\nMan")

// data15=((close[1]>open[1])and(((close[1]+open[1])/2)>close)and(open>close)and(open>close[1])and(close>open[1])and((open-close)/(.001+(high-low))>0.6))
// plotshape(data15, title= "Dark Cloud Cover", color=red, style=shape.arrowdown, text="Dark\nCloudCover")


  }

  void doBuy() {
    int score = 0;
    double changes = getChange();

    _checkCandle();
    if (changes >= threshold) {
      score = 2;
    } else if (changes > -threshold) {
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
    _checkCandle();
    begin++;
    if (begin > quotes.length - n) {
      begin = 0;
      _showSnackBar('Data reset');
    }
  }

  void doSell() {
    int score = 0;
    double changes = getChange();

    _checkCandle();
    if (changes >= threshold) {
      score = -2;
    } else if (changes > -threshold) {
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
