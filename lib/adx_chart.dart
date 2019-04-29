import 'package:flutter/material.dart';

class ADXChart extends StatelessWidget {
  
  ADXChart({ Key key, @required this.data});

  final List<double> data;

  Widget build(BuildContext context) {
    // maVol = ma(data, 5);
    return new CustomPaint(
      size: Size.infinite,
      painter: ADXPainter(data)
    );
  }
}

class ADXPainter extends CustomPainter {

  ADXPainter(this.data);

  final List<double> data;
  final double height = 40;
  double min, max;

  @override
  void paint(Canvas canvas, Size size) {
    if (data == null) return;
    Paint paint;
    final double width = size.width;
    final double rectWidth = width / data.length;
    final double lineWidth = 2.0;
    final double space = 3.0;
    double val, val1;

    paint = new Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 2.0;
    findMinMax();
    double normalizer = height / max;

    for (int i = 1; i < data.length; i++) {
      double rectLeft = ((i) * rectWidth) + lineWidth / 2;
      double rectLeft1 = ((i - 1) * rectWidth) + lineWidth / 2;
      double middle = rectLeft + rectWidth / 2 - lineWidth / 2 - space / 2;
      double middle1 = rectLeft1 + rectWidth / 2 - lineWidth / 2 - space / 2;
      val = height - (data[i] - min) * normalizer;
      val1 = height - (data[i-1] - min) * normalizer;
      Offset p1 = new Offset(middle1, val1);
      Offset p2 = new Offset(middle, val);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(ADXPainter old) {
    return data != old.data;
  }

  void findMinMax() {
    max = nz(data[0]);
    min = nz(data[0]);
    data.forEach((v) {
      if (v != null) { 
        max = max > nz(v) ?  max : v;
        min = min < nz(v) ?  min : v;
      }
    } );
  }

  double nz(v) => (v == null ? 1.0 : v);

}
