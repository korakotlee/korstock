List<double> ma(values, window) {
  int w = window - 1;
  List<double>_ma = [];
  for (int i =0; i< values.length; i++ ) {
    if (i < w) _ma.add(null);
    else {
      List group = values.sublist(i-w,i+1);
      double sum = 0;
      group.forEach((var v) {sum += v['volumeto'];});
      // print("sum $sum");
      _ma.add(sum/window);
    }
  }
  return _ma;
}
