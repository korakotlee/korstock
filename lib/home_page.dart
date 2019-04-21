import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List sampleData = [
    {"open": 50.0, "high": 100.0, "low": 40.0, "close": 80, "volumeto": 5000.0},
    {"open": 80.0, "high": 90.0, "low": 55.0, "close": 65, "volumeto": 4000.0},
    {"open": 65.0, "high": 120.0, "low": 60.0, "close": 90, "volumeto": 7000.0},
    {"open": 90.0, "high": 95.0, "low": 85.0, "close": 80, "volumeto": 2000.0},
    {"open": 80.0, "high": 85.0, "low": 40.0, "close": 50, "volumeto": 3000.0},
    {"open": 50.0, "high": 100.0, "low": 40.0, "close": 80, "volumeto": 5000.0},
    {"open": 80.0, "high": 90.0, "low": 55.0, "close": 65, "volumeto": 4000.0},
    {"open": 65.0, "high": 120.0, "low": 60.0, "close": 90, "volumeto": 7000.0},
    {"open": 90.0, "high": 95.0, "low": 85.0, "close": 80, "volumeto": 2000.0},
    {"open": 80.0, "high": 85.0, "low": 40.0, "close": 50, "volumeto": 3000.0},
    {"open": 50.0, "high": 100.0, "low": 40.0, "close": 80, "volumeto": 5000.0},
    {"open": 80.0, "high": 90.0, "low": 55.0, "close": 65, "volumeto": 4000.0},
    {"open": 65.0, "high": 120.0, "low": 60.0, "close": 90, "volumeto": 7000.0},
    {"open": 90.0, "high": 95.0, "low": 70.0, "close": 80, "volumeto": 2000.0},
    {"open": 70.0, "high": 100.0, "low": 50.0, "close": 50, "volumeto": 3000.0},
    {"open": 70.0, "high": 100.0, "low": 50.0, "close": 50, "volumeto": 3000.0},
  ];
  int i = 3;
  @override
  Widget build(BuildContext context) {
    setLandscape();
    return new Scaffold(
        body: SafeArea(
            child: Stack(
      children: <Widget>[
        bg("KorStock $i", "Megrim"),
        candle(),
        Positioned(
          right: 20.0,
          top: 5.0,
          child: Text('coins: 100',
              style: TextStyle(
                  fontSize: 18, fontFamily: "Bitter", color: Colors.white)),
        ),
      ],
    )));
  }

  Widget candle() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 10.0, left: 10.0),
            child: OHLCVGraph(
                increaseColor: Colors.greenAccent,
                decreaseColor: Colors.redAccent,
                data: sampleData,
                enableGridLines: true,
                volumeProp: 0.2),
          ),
        ),
        Container(
          width: 100.0,
        )
      ],
    );
  }

  Widget bg(text, font) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width,
        height: height - 25,
        // height: (height - 25) / 3,
        child: Text(text,
            style:
                TextStyle(fontSize: 24, fontFamily: font, color: Colors.white)),
        // child: FittedBox(
        //   fit: BoxFit.contain,
        //   child: Text(text,
        //       style: TextStyle(fontFamily: font, color: Colors.white)),
        // ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
            colors: [
              Colors.brown,
              Colors.amberAccent,
            ],
          ),
        ));
  }

  void setLandscape() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }
}
