import 'dart:math';

import 'package:flutter/material.dart';

class Pattern {
  String text;
  Color color;
  String direction;

  Pattern(this.text, this.color, this.direction);
}

List<Pattern> detectPattern(var q, var q1, var q2) {
  double dojiSize = 0.05;
  bool pattern;
  List<Pattern> p = [];
  pattern = (q['open'] - q['close']).abs() <= (q['high'] - q['low']) * dojiSize;
  if (pattern) p.add(Pattern('doji', Colors.blue, ''));

  pattern = (q2['close'] > q2['open'] &&
      min<double>(q1['open'], q1['close']) > q2['close'] &&
      q['open'] < min<double>(q1['open'], q1['close']) &&
      q['close'] < q['open']);
  if (pattern) p.add(Pattern('Evening Star [3]', Colors.red, 'down'));
// data2=(close[2] > open[2] and min(open[1], close[1]) > close[2] and open < min(open[1], close[1]) and close < open )
// plotshape(data2, title= "Evening Star", color=red, style=shape.arrowdown, text="Evening\nStar")

  pattern = (q2['close'] < q2['open'] &&
      max<double>(q1['open'], q1['close']) < q2['close'] &&
      q['open'] > max<double>(q1['open'], q1['close']) &&
      q['close'] > q['open']);
  if (pattern) p.add(Pattern('Morning Star [3]', Colors.green, 'up'));
// data3=(close[2] < open[2] and max(open[1], close[1]) < close[2] and open > max(open[1], close[1]) and close > open )
// plotshape(data3,  title= "Morning Star", location=location.belowbar, color=green, style=shape.arrowup, text="Morning\nStar")

  pattern = (q1['open'] < q1['close'] &&
      q['open'] > q1['close'] &&
      q['high'] - max<double>(q['open'], q['close']) >=
          (q['open'] - q['close']).abs() * 3 &&
      min<double>(q['close'], q['open']) - q['low'] <=
          (q['open'] - q['close']).abs());
  if (pattern) p.add(Pattern('Shooting Star [2]', Colors.red, 'down'));
// data4=(open[1] < close[1] and open > close[1] and high - max(open, close) >= abs(open - close) * 3 and min(close, open) - low <= abs(open - close))
// plotshape(data4, title= "Shooting Star", color=red, style=shape.arrowdown, text="Shooting\nStar")

  pattern = (((q['high'] - q['low']) > 3 * (q['open'] - q['close'])) &&
      ((q['close'] - q['low']) / (.001 + q['high'] - q['low']) > 0.6) &&
      ((q['open'] - q['low']) / (.001 + q['high'] - q['low']) > 0.6));
  if (pattern) p.add(Pattern('Hammer [1]', Colors.black, ''));
// data5=(((high - low)>3*(open -close)) and  ((close - low)/(.001 + high - low) > 0.6) and ((open - low)/(.001 + high - low) > 0.6))
// plotshape(data5, title= "Hammer", location=location.belowbar, color=black, style=shape.diamond, text="H")

  pattern = (((q['high'] - q['low']) > 3 * (q['open'] - q['close'])) &&
      ((q['high'] - q['close']) / (.001 + q['high'] - q['low']) > 0.6) &&
      ((q['high'] - q['open']) / (.001 + q['high'] - q['low']) > 0.6));
  if (pattern) p.add(Pattern('Inverted Hammer [1]', Colors.black, ''));
// plotshape(data5b, title= "Inverted Hammer", location=location.belowbar, color=black, style=shape.diamond, text="IH")

  pattern = (q1['close'] > q1['open'] &&
      q['open'] > q['close'] &&
      q['open'] <= q1['close'] &&
      q1['open'] <= q['close'] &&
      q['open'] - q['close'] < q1['close'] - q1['open']);
  if (pattern) p.add(Pattern('Bearish Harami [2]', Colors.red, 'down'));
// plotshape(data6, title= "Bearish Harami",  color=red, style=shape.arrowdown, text="Bearish\nHarami")

  pattern = (q1['open'] > q1['close'] &&
      q['close'] > q['open'] &&
      q['close'] <= q1['open'] &&
      q1['close'] <= q['open'] &&
      q['close'] - q['open'] < q1['open'] - q1['close']);
  if (pattern) p.add(Pattern('Bullish Harami [2]', Colors.green, 'up'));
// plotshape(data7,  title= "Bullish Harami", location=location.belowbar, color=green, style=shape.arrowup, text="Bullish\nHarami")

  pattern = (q1['close'] > q1['open'] &&
      q['open'] > q['close'] &&
      q['open'] >= q1['close'] &&
      q1['open'] >= q['close'] &&
      q['open'] - q['close'] > q1['close'] - q1['open']);
  if (pattern) p.add(Pattern('Bearish Engulfing [2]', Colors.red, 'down'));
// plotshape(data8,  title= "Bearish Engulfing", color=red, style=shape.arrowdown, text="Bearish\nEngulfing")

  pattern = (q1['open'] > q1['close'] &&
      q['close'] > q['open'] &&
      q['close'] >= q1['open'] &&
      q1['close'] >= q['open'] &&
      q['close'] - q['open'] > q1['open'] - q1['close']);
  if (pattern) p.add(Pattern('Bullish Engulfing [2]', Colors.green, 'up'));
// plotshape(data9, title= "Bullish Engulfing", location=location.belowbar, color=green, style=shape.arrowup, text="Bullish\nEngulfling")

  pattern = (q1['open'] > q1['close'] &&
      q['open'] >= q1['open'] &&
      q['close'] > q['open']);
  if (pattern) p.add(Pattern('Bullish Kicker [2]', Colors.green, 'up'));
// plotshape(data12, title= "Bullish Kicker", location=location.belowbar, color=green, style=shape.arrowup, text="Bullish\nKicker")

  pattern = (q1['open'] < q1['close'] &&
      q['open'] <= q1['open'] &&
      q['close'] <= q['open']);
  if (pattern) p.add(Pattern('Bearish Kicker [2]', Colors.red, 'down'));
// plotshape(data13, title= "Bearish Kicker", color=red, style=shape.arrowdown, text="Bearish\nKicker")

  pattern = (((q['high'] - q['low'] > 4 * (q['open'] - q['close'])) &&
          ((q['close'] - q['low']) / (.001 + q['high'] - q['low']) >= 0.75) &&
          ((q['open'] - q['low']) / (.001 + q['high'] - q['low']) >= 0.75)) &&
      q1['high'] < q['open'] &&
      q2['high'] < q['open']);
  if (pattern) p.add(Pattern('Hanging Man [3]', Colors.red, 'down'));
// plotshape(data14,  title= "Hanging Man", color=red, style=shape.arrowdown, text="Hanging\nMan")

  pattern = ((q1['close'] > q1['open']) &&
      (((q1['close'] + q1['open']) / 2) > q1['close']) &&
      (q['open'] > q['close']) &&
      (q['open'] > q1['close']) &&
      (q['close'] > q1['open']) &&
      ((q['open'] - q['close']) / (.001 + (q['high'] - q['low'])) > 0.6));
  if (pattern) p.add(Pattern('Dark Cloud Cover [2]', Colors.red, 'down'));
// plotshape(data15, title= "Dark Cloud Cover", color=red, style=shape.arrowdown, text="Dark\nCloudCover")

// upper = highest(10)[1]
  pattern = (q1['close'] < q1['open'] &&
      q['open'] < q1['low'] &&
      q['close'] > q1['close'] + ((q1['open'] - q1['close']) / 2) &&
      q['close'] < q1['open']);
  if (pattern) p.add(Pattern('Piercing Line [2]', Colors.green, 'up'));
// plotshape(data10, title= "Piercing Line", location=location.belowbar, color=green, style=shape.arrowup, text="Piercing\nLine")

// lower = lowest(10)[1]
// data11=(low == open and  open < lower and open < close and close > ((high[1] - low[1]) / 2) + low[1])
// plotshape(data11, title= "Bullish Belt", location=location.belowbar, color=green, style=shape.arrowup, text="Bullish\nBelt")

  return p;
}
