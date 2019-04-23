import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class Quote {
  final String _qDate;
  final double _open;
  final double _hi;
  final double _lo;
  final double _close;
  final double _vol;

  Quote(this._qDate, this._open, this._hi, this._lo, this._close, this._vol, );

  String get qDate => _qDate;
  double get open => _open;
  double get hi => _hi;
  double get lo => _lo;
  double get close => _close;
  double get vol => _vol;

  static Future<String> _getFile() async {
    String content = await rootBundle.loadString("assets/query.json");
    return content;
  }

  static Future<List<Quote>> getQuote() async {
    String s = await _getFile();
    var json = jsonDecode(s);
    var series = json["Time Series (Daily)"];
    List<Quote> quotes = [];
    series.forEach((k,v) {
      String qDate = k;
      double open = double.parse(v['1. open']);
      double hi = double.parse(v['2. high']);
      double lo = double.parse(v['3. low']);
      double close = double.parse(v['4. close']);
      double vol = double.parse(v['6. volume']);
      Quote q = Quote(qDate, open, hi, lo, close, vol);
      quotes.add(q);
    });
    return quotes;
  }

  static Future<List<Map<String, dynamic>>> getQuoteMap() async {
    String s = await _getFile();
    var json = jsonDecode(s);
    var series = json["Time Series (Daily)"];
    List<Map<String, dynamic>> quotes = [];
    Map<String, dynamic> q;
    series.forEach((k,v) {
      String qDate = k;
      double open = double.parse(v['1. open']);
      double hi = double.parse(v['2. high']);
      double lo = double.parse(v['3. low']);
      double close = double.parse(v['4. close']);
      double vol = double.parse(v['6. volume']);
      q = {
        "open": open,
        "high": hi,
        "low": lo,
        "close": close,
        "volumeto": vol,
        "qDate": qDate,
      };
      quotes.add(q);
    });
    return quotes;
  }
}
