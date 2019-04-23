import 'dart:math';

import 'package:flutter/material.dart';

class Pattern {
  String _text;
  Color _color;
  // String _color;

  Pattern(this._text, this._color);

  String get text => _text;
  Color get color => _color;

  set text(String text) {
    this._text = text;
  }

  set color(Color color) {
    this._color = color;
  }
}

List<Pattern> detectPattern(var q, var q1, var q2) {
  double dojiSize = 0.05;
  bool pattern;
  List<Pattern> p = [];
  pattern = (q['open'] - q['close']).abs() <= (q['high'] - q['low']) * dojiSize;
  if (pattern) p.add(Pattern('doji', Colors.blue));

  pattern = (q2['close'] > q2['open'] &&
      min<double>(q1['open'], q1['close']) > q2['close'] &&
      q['open'] < min<double>(q1['open'], q1['close']) &&
      q['close'] < q['open']);
  if (pattern) p.add(Pattern('Evening Star', Colors.red));
// data2=(close[2] > open[2] and min(open[1], close[1]) > close[2] and open < min(open[1], close[1]) and close < open )
// plotshape(data2, title= "Evening Star", color=red, style=shape.arrowdown, text="Evening\nStar")

  pattern = (q2['close'] < q2['open'] &&
      max<double>(q1['open'], q1['close']) < q2['close'] &&
      q['open'] > max<double>(q1['open'], q1['close']) &&
      q['close'] > q['open']);
  if (pattern) p.add(Pattern('Morning Star', Colors.lime));
// data3=(close[2] < open[2] and max(open[1], close[1]) < close[2] and open > max(open[1], close[1]) and close > open )
// plotshape(data3,  title= "Morning Star", location=location.belowbar, color=lime, style=shape.arrowup, text="Morning\nStar")

  pattern = (q1['open'] < q1['close'] &&
      q['open'] > q1['close'] &&
      q['high'] - max<double>(q['open'], q['close']) >=
          (q['open'] - q['close']).abs() * 3 &&
      min<double>(q['close'], q['open']) - q['low'] <=
          (q['open'] - q['close']).abs());
  if (pattern) p.add(Pattern('Shooting Star', Colors.red));
// data4=(open[1] < close[1] and open > close[1] and high - max(open, close) >= abs(open - close) * 3 and min(close, open) - low <= abs(open - close))
// plotshape(data4, title= "Shooting Star", color=red, style=shape.arrowdown, text="Shooting\nStar")

  pattern = (((q['high'] - q['low'])>3*(q['open'] -q['close'])) &&
    ((q['close'] - q['low'])/(.001 + q['high'] - q['low']) > 0.6) &&
     ((q['open'] - q['low'])/(.001 + q['high'] - q['low']) > 0.6));
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

  return p;
}
