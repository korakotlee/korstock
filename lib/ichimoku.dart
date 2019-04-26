class Ichimoku {
  final List<Map<String, dynamic>> data;
  final int basePeriods = 26;

  Ichimoku(this.data);

  List<Map<String, double>> calc() {
    List<Map<String, double>> _ichi = [];
    // List<double> _conversion = [];
    // List<double> _lead1 = [];
    // List<double> _lead2 = [];
    // List<double> _lag = [];
    for (int i = 0; i < data.length; i++) {
      // double lo = lowest(i, 5);
      // double hi = highest(i, 5);
      // double don = donchian(i, basePeriods);
      _ichi.add({"base": donchian(i, basePeriods)});
      // print('i: $i data: ${data[i]['low']} low: $lo hi: $hi don:$don');
    }
    // print(_ichi);
    return _ichi;
  }

  double lowest(i, len) {
    double low = 9999.0;
    if (i < len - 1) return null;
    for (int j = i; j > i - len; j--) {
      double dataLow = data[j]['low'];
      if (dataLow < low) low = dataLow;
    }
    return low;
  }

  double highest(i, len) {
    double high = 0.0;
    if (i < len - 1) return null;
    for (int j = i; j > i - len; j--) {
      double dataHigh = data[j]['high'];
      if (dataHigh > high) high = dataHigh;
    }
    return high;
  }

  double donchian(i, len) {
    if (i < len - 1) return null;
    return (lowest(i, len) + highest(i, len)) / 2;
  }
}
// conversionPeriods = input(9, minval=1, title="Conversion Line Periods"),
// basePeriods = input(26, minval=1, title="Base Line Periods")
// laggingSpan2Periods = input(52, minval=1, title="Lagging Span 2 Periods"),
// displacement = input(26, minval=1, title="Displacement")

// donchian(len) => avg(lowest(len), highest(len))

// conversionLine = donchian(conversionPeriods)
// baseLine = donchian(basePeriods)
// leadLine1 = avg(conversionLine, baseLine)
// leadLine2 = donchian(laggingSpan2Periods)

// plot(conversionLine, color=#0496ff, title="Conversion Line", linewidth=2)
// plot(baseLine, color=#991515, title="Base Line", linewidth=2)
// plot(close, offset = -displacement, color=#ff00ff, linewidth=3, title="Lagging Span")
// bottomcloud=leadLine2[displacement-1]
// uppercloud=leadLine1[displacement-1]
// minCloud = bottomcloud<uppercloud ? bottomcloud : uppercloud
// maxCloud = bottomcloud<uppercloud ? uppercloud : bottomcloud
// crossDown = crossover(baseLine, conversionLine) and conversionLine<minCloud ? 1 : 0
// crossUp = crossover(conversionLine, baseLine) and conversionLine>maxCloud ? 1 : 0

// //plotchar(sl and crossUp ? crossUp : na, title="Buy Signal Strict Criteria", char='B', location=location.bottom, color=lime, transp=0, offset=0)
// plotchar(crossUp ? crossUp : na, title="Buy Signal Strict Criteria", char='B', location=location.bottom, color=lime, transp=0, offset=0, size=size.normal)
// plotchar(crossDown ? crossDown : na, title="Sell Signal Strict Criteria", char='S', location=location.bottom, color=red, transp=0, offset=0, size=size.normal)
// alertcondition(cross(baseLine, conversionLine), title="TK Cross", message="TK Cross")

// p1 = plot(leadLine1, offset = displacement, color=green,
//     title="Lead 1")
// p2 = plot(leadLine2, offset = displacement, color=red,
//     title="Lead 2")
// fill(p1, p2, color = leadLine1 > leadLine2 ? green : red)
