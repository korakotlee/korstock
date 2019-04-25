Map<String, List<double>> ichi(data) {
  // int w = window - 1;
  List<double>_base = [];
  List<double>_conversion = [];
  List<double>_lead1 = [];
  List<double>_lead2 = [];
  List<double>_lag = [];
  // for (int i =0; i< values.length; i++ ) {
  //   if (i < w) _ma.add(null);
  //   else {
  //     List group = values.sublist(i-w,i+1);
  //     double sum = 0;
  //     group.forEach((var v) {sum += v['volumeto'];});
  //     // print("sum $sum");
  //     _ma.add(sum/window);
  //   }
  // }
  return {
    'base': _base,
    'conversion': _conversion,
    'lead1': _lead1,
    'lead2': _lead2,
    'lag': _lag,
  };
}


// conversionPeriods = input(9, minval=1, title="Conversion Line Periods"),
// basePeriods = input(26, minval=1, title="Base Line Periods")
// laggingSpan2Periods = input(52, minval=1, title="Lagging Span 2 Periods"),
// displacement = input(26, minval=1, title="Displacement")
// hivolume = input(1.5, minval=2, title="Hi Volume")

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
