import 'dart:math';

class ADX {
  final List<Map<String, dynamic>> data;
  final int len = 14;
  List<double> dxList = [0.0];

  ADX(this.data);

  List<double> calc() {
    // List<double> adx = [0.0];
    calcDX();
    return ma(dxList, len);
  }

  List<double> ma(values, window) {
    int w = window - 1;
    List<double> _ma = [];
    for (int i =0; i< values.length; i++ ) {
      if (i < w) _ma.add(null);
      else {
        List group = values.sublist(i-w,i+1);
        double sum = 0;
        group.forEach((var v) {sum += v;});
        _ma.add(sum/window);
      }
    }
    return _ma;
  }

  void calcDX() {
    List<double> trueRangeList = [0.0];
    List<double> dmPlusList = [0.0];
    List<double> dmMinusList = [0.0];

    for (int i=1; i<data.length; i++) {
      // double close = data[i]['close'];
      double high = data[i]['high'];
      double low = data[i]['low'];
      double close1 = data[i-1]['close'];
      double high1 = data[i-1]['high'];
      double low1 = data[i-1]['low'];

      double trueRange = max<double>(
        max<double>(high-low, (high-nz(close1)).abs()),
        (low-nz(close1)).abs());
      double dmPlus = high-nz(high1) > nz(low1)-low ?
        max<double>(high-nz(high1), 0.0): 0.0;
      double dmMinus = nz(low1)-low > high-nz(high1) ?
        max(nz(low1)-low, 0.0): 0.0;
      if (i == 1) {
        trueRangeList.add(trueRange);
        dmPlusList.add(dmPlus);
        dmMinusList.add(dmMinus);
      }
      else {
        trueRangeList.add( smooth(trueRange, trueRangeList[i-1]) );
        dmPlusList.add( smooth(dmPlus, dmPlusList[i-1]) );
        dmMinusList.add( smooth(dmMinus, dmMinusList[i-1]) );
      }
      double diPlus = dmPlusList[i] / trueRangeList[i] * 100;
      double diMinus = dmMinusList[i] / trueRangeList[i] * 100;
      dxList.add( (diPlus - diMinus).abs() / (diPlus + diMinus) *100);
    }
    // return dxList;
  }

  double smooth(data, data1) {
    return nz(data1) - (nz(data1)/len) + data;
  }

  double nz(double v) {
    return v == null ? 0 : v;
  } 

  // double maxList(List<double> data) {
  //   double max = data[0];
  //   data.forEach((v) { max = max > v ? max : v; });
  //   return max;
  // }
}

// len = input(title="Length", type=integer, defval=14)
// th = input(title="threshold", type=integer, defval=20)

// TrueRange = max(max(high-low, abs(high-nz(close[1]))), abs(low-nz(close[1])))
// DirectionalMovementPlus = high-nz(high[1]) > nz(low[1])-low ? max(high-nz(high[1]), 0): 0
// DirectionalMovementMinus = nz(low[1])-low > high-nz(high[1]) ? max(nz(low[1])-low, 0): 0


// SmoothedTrueRange = nz(SmoothedTrueRange[1]) - (nz(SmoothedTrueRange[1])/len) + TrueRange
// SmoothedDirectionalMovementPlus = nz(SmoothedDirectionalMovementPlus[1]) - (nz(SmoothedDirectionalMovementPlus[1])/len) + DirectionalMovementPlus
// SmoothedDirectionalMovementMinus = nz(SmoothedDirectionalMovementMinus[1]) - (nz(SmoothedDirectionalMovementMinus[1])/len) + DirectionalMovementMinus

// DIPlus = SmoothedDirectionalMovementPlus / SmoothedTrueRange * 100
// DIMinus = SmoothedDirectionalMovementMinus / SmoothedTrueRange * 100
// DX = abs(DIPlus-DIMinus) / (DIPlus+DIMinus)*100
// ADX = sma(DX, len)
