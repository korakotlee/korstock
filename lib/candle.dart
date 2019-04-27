import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:korstock/moving_average.dart';

class OHLCVGraph extends StatelessWidget {
  OHLCVGraph({
    Key key,
    @required this.data,
    // this.begin,
    this.maVol,
    this.ichimoku,
    this.lineWidth = 1.0,
    this.fallbackHeight = 100.0,
    this.fallbackWidth = 300.0,
    this.gridLineColor = Colors.grey,
    this.gridLineAmount = 5,
    this.gridLineWidth = 0.5,
    this.gridLineLabelColor = Colors.grey,
    this.labelPrefix = "\$",
    @required this.enableGridLines,
    @required this.volumeProp,
    this.increaseColor = Colors.green,
    this.decreaseColor = Colors.red,
  })  : assert(data != null),
        super(key: key);

  /// OHLCV data to graph  /// List of Maps containing open, high, low, close and volumeto
  /// Example: [["open" : 40.0, "high" : 75.0, "low" : 25.0, "close" : 50.0, "volumeto" : 5000.0}, {...}]
  final List data;
  // final int begin;
  final List maVol;
  final List ichimoku;

  /// All lines in chart are drawn with this width
  final double lineWidth;

  /// Enable or disable grid lines
  final bool enableGridLines;

  /// Color of grid lines and label text
  final Color gridLineColor;
  final Color gridLineLabelColor;

  /// Number of grid lines
  final int gridLineAmount;

  /// Width of grid lines
  final double gridLineWidth;

  /// Proportion of paint to be given to volume bar graph
  final double volumeProp;

  /// If graph is given unbounded space,
  /// it will default to given fallback height and width
  final double fallbackHeight;
  final double fallbackWidth;

  /// Symbol prefix for grid line labels
  final String labelPrefix;

  /// Increase color
  final Color increaseColor;

  /// Decrease color
  final Color decreaseColor;

  @override
  Widget build(BuildContext context) {
    // maVol = ma(data, 5);
    return new LimitedBox(
      maxHeight: fallbackHeight,
      maxWidth: fallbackWidth,
      child: new CustomPaint(
        size: Size.infinite,
        painter: new _OHLCVPainter(data,
            // begin: begin,
            maVol: maVol,
            ichimoku: ichimoku,
            lineWidth: lineWidth,
            gridLineColor: gridLineColor,
            gridLineAmount: gridLineAmount,
            gridLineWidth: gridLineWidth,
            gridLineLabelColor: gridLineLabelColor,
            enableGridLines: enableGridLines,
            volumeProp: volumeProp,
            labelPrefix: labelPrefix,
            increaseColor: increaseColor,
            decreaseColor: decreaseColor),
      ),
    );
  }
}

class _OHLCVPainter extends CustomPainter {
  _OHLCVPainter(this.data,
      {@required this.lineWidth,
      // @required this.begin,
      @required this.maVol,
      @required this.ichimoku,
      @required this.enableGridLines,
      @required this.gridLineColor,
      @required this.gridLineAmount,
      @required this.gridLineWidth,
      @required this.gridLineLabelColor,
      @required this.volumeProp,
      @required this.labelPrefix,
      @required this.increaseColor,
      @required this.decreaseColor});

  final List data;
  // final int begin;
  final List maVol;
  final List ichimoku;
  final double lineWidth;
  final bool enableGridLines;
  final Color gridLineColor;
  final int gridLineAmount;
  final double gridLineWidth;
  final Color gridLineLabelColor;
  final String labelPrefix;
  final double volumeProp;
  final Color increaseColor;
  final Color decreaseColor;

  double _min;
  double _max;
  double _maxVolume;

  final double space = 5.0;

  List<TextPainter> gridLineTextPainters = [];
  TextPainter maxVolumePainter;

  drawIchi(canvas, i, rectWidth, height, heightNormalizer) {
    if (i == 0) return;
    if (ichimoku[i - 1]['base'] == null) return;

    Paint rectPaint = new Paint();
    double val, val1;
    double rectLeft = ((i) * rectWidth) + lineWidth / 2;
    double rectLeft1 = ((i - 1) * rectWidth) + lineWidth / 2;
    double middle = rectLeft + rectWidth / 2 - lineWidth / 2 - space / 2;
    double middle1 = rectLeft1 + rectWidth / 2 - lineWidth / 2 - space / 2;

    rectPaint.strokeWidth = 2;
    // base
    rectPaint.color = Colors.red;
    val = height - (ichimoku[i]["base"] - _min) * heightNormalizer;
    val1 = height - (ichimoku[i - 1]["base"] - _min) * heightNormalizer;
    canvas.drawLine(
      new Offset(middle1, val1), new Offset(middle, val), rectPaint);
    // conversion
    rectPaint.color = Colors.blue;
    val = height - (ichimoku[i]["conversion"] - _min) * heightNormalizer;
    val1 = height - (ichimoku[i - 1]["conversion"] - _min) * heightNormalizer;
    canvas.drawLine(
      new Offset(middle1, val1), new Offset(middle, val), rectPaint);
    // cloud
    double lead1 = ichimoku[i]["lead1"];
    double lead2 = ichimoku[i]["lead2"];
    double lead1_1 = ichimoku[i-1]["lead1"];
    double lead2_1 = ichimoku[i-1]["lead2"];
    if (lead1_1 != null && lead2_1 != null) {
      double val_1, val1_1;
      rectPaint.color = lead1 > lead2 ? Color(0x4453B987) : Color(0x44EB4D5C);
      val = height - (lead1 - _min) * heightNormalizer;
      val1 = height - (lead2 - _min) * heightNormalizer;
      val_1 = height - (lead1_1 - _min) * heightNormalizer;
      val1_1 = height - (lead2_1 - _min) * heightNormalizer;
      double top = val > val1 ? val1 : val;
      double bottom = val > val1 ? val : val1;
      // Rect rect = new Rect.fromLTRB( middle1, top, middle, bottom);
      // canvas.drawRect(rect, rectPaint);
      var path1 = Path()
      ..moveTo(middle1, val_1)
      ..lineTo(middle, val)
      ..lineTo(middle, val1)
      ..lineTo(middle1, val1_1);
      canvas.drawPath(path1, rectPaint);
    }

    // canvas.drawRect(
    //   new Offset(middle1, val1), new Offset(middle, val), rectPaint);
  }

  drawVolumeMA(canvas, i, height, volumeHeight, rectWidth, volumeNormalizer) {
    // print(i);
    if (i == 0) return;
    if (maVol[i - 1] == null) return;

    Paint rectPaint = new Paint()
      ..color = Colors.indigo
      ..strokeWidth = 1;
    if (i > 0 && maVol[i] != null) {
      double rectRight = ((i + 1) * rectWidth) - lineWidth / 2 - space;
      // double rectLeft = ((i) * rectWidth) + lineWidth / 2;
      double rectLeft1 = ((i - 1) * rectWidth) + lineWidth / 2;
      // double middle = rectLeft + (rectWidth  - lineWidth  - space) / 2;
      // double middle1 = rectLeft1 + (rectWidth  - lineWidth  - space) / 2;
      // if (maVol[i - 1] != null) {
      double vol = (height + volumeHeight) -
          (maVol[i] * volumeNormalizer - lineWidth / 2);
      double vol1 = (height + volumeHeight) -
          (maVol[i - 1] * volumeNormalizer - lineWidth / 2);
      canvas.drawLine(
        new Offset(rectLeft1, vol1), new Offset(rectRight, vol), rectPaint);
      // print('$i: ${middle1.toStringAsFixed(0)}, ${vol1.toStringAsFixed(0)} => ${middle.toStringAsFixed(0)}, ${vol.toStringAsFixed(0)}');
      // }
    }
  }

  numCommaParse(number) {
    return number.round().toString().replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
  }

  update() {
    _min = double.infinity;
    _max = -double.infinity;
    _maxVolume = -double.infinity;
    for (var i in data) {
      if (i["high"] > _max) {
        _max = i["high"].toDouble();
      }
      if (i["low"] < _min) {
        _min = i["low"].toDouble();
      }
      if (i["volumeto"] > _maxVolume) {
        _maxVolume = i["volumeto"].toDouble();
      }
    }

    if (enableGridLines) {
      double gridLineValue;
      for (int i = 0; i < gridLineAmount; i++) {
        // Label grid lines
        gridLineValue = _max - (((_max - _min) / (gridLineAmount - 1)) * i);

        String gridLineText;
        if (gridLineValue < 1) {
          gridLineText = gridLineValue.toStringAsPrecision(4);
        } else if (gridLineValue < 999) {
          gridLineText = gridLineValue.toStringAsFixed(2);
        } else {
          gridLineText = gridLineValue.round().toString().replaceAllMapped(
              new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => "${m[1]},");
        }

        gridLineTextPainters.add(new TextPainter(
            text: new TextSpan(
                text: labelPrefix + gridLineText,
                style: new TextStyle(
                    color: gridLineLabelColor,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold)),
            textDirection: TextDirection.ltr));
        gridLineTextPainters[i].layout();
      }

      // Label volume line
      maxVolumePainter = new TextPainter(
          text: new TextSpan(
              text: numCommaParse(_maxVolume),
              // text: "\$" + numCommaParse(_maxVolume),
              style: new TextStyle(
                  color: gridLineLabelColor,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold)),
          textDirection: TextDirection.ltr);
      maxVolumePainter.layout();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // print('*** paint');
    if (_min == null || _max == null || _maxVolume == null) {
      update();
    }

    final double volumeHeight = size.height * volumeProp;
    final double volumeNormalizer = volumeHeight / _maxVolume;

    double width = size.width;
    final double height = size.height * (1 - volumeProp);

    if (enableGridLines) {
      width = size.width - gridLineTextPainters[0].text.text.length * 6;
      Paint gridPaint = new Paint()
        ..color = gridLineColor
        ..strokeWidth = gridLineWidth;

      double gridLineDist = height / (gridLineAmount - 1);
      double gridLineY;

      // Draw grid lines
      for (int i = 0; i < gridLineAmount; i++) {
        gridLineY = (gridLineDist * i).round().toDouble();
        canvas.drawLine(new Offset(0.0, gridLineY),
            new Offset(width, gridLineY), gridPaint);

        // Label grid lines
        gridLineTextPainters[i]
            .paint(canvas, new Offset(width + 2.0, gridLineY - 6.0));
      }

      // Label volume line
      // maxVolumePainter.paint(canvas, new Offset(0.0, gridLineY + 2.0));
    }

    final double heightNormalizer = height / (_max - _min);
    final double rectWidth = width / data.length;

    double rectLeft;
    double rectTop;
    double rectRight;
    double rectBottom;

    Paint rectPaint;

    // Loop through all data
    for (int i = 0; i < data.length; i++) {
      rectLeft = (i * rectWidth) + lineWidth / 2;
      rectRight = ((i + 1) * rectWidth) - lineWidth / 2 - space;

      double volumeBarTop = (height + volumeHeight) -
          (data[i]["volumeto"] * volumeNormalizer - lineWidth / 2);
      double volumeBarBottom = height + volumeHeight + lineWidth / 2;

      // draw volume ma(20)
      drawVolumeMA(
          canvas, i, height, volumeHeight, rectWidth, volumeNormalizer);
      drawIchi(canvas, i, rectWidth, height, heightNormalizer);

      if (data[i]["open"] > data[i]["close"]) {
        // Draw candlestick if decrease
        rectTop = height - (data[i]["open"] - _min) * heightNormalizer;
        rectBottom = height - (data[i]["close"] - _min) * heightNormalizer;
        rectPaint = new Paint()
          ..color = decreaseColor
          ..strokeWidth = lineWidth;

        Rect ocRect =
            new Rect.fromLTRB(rectLeft, rectTop, rectRight, rectBottom);
        canvas.drawRect(ocRect, rectPaint);

        // Draw volume bars
        Rect volumeRect = new Rect.fromLTRB(
            rectLeft, volumeBarTop, rectRight, volumeBarBottom);
        rectPaint.color = Colors.blueAccent[100];
        canvas.drawRect(volumeRect, rectPaint);
      } else {
        // Draw candlestick if increase
        rectTop = (height - (data[i]["close"] - _min) * heightNormalizer) +
            lineWidth / 2;
        rectBottom = (height - (data[i]["open"] - _min) * heightNormalizer) -
            lineWidth / 2;
        rectPaint = new Paint()
          ..color = increaseColor
          ..strokeWidth = lineWidth;

        Rect ocRect =
            new Rect.fromLTRB(rectLeft, rectTop, rectRight, rectBottom);
        canvas.drawRect(ocRect, rectPaint);

        // canvas.drawLine(new Offset(rectLeft, rectBottom - lineWidth / 2),
        //     new Offset(rectRight, rectBottom - lineWidth / 2), rectPaint);
        // canvas.drawLine(new Offset(rectLeft, rectTop + lineWidth / 2),
        //     new Offset(rectRight, rectTop + lineWidth / 2), rectPaint);
        // canvas.drawLine(new Offset(rectLeft + lineWidth / 2, rectBottom),
        //     new Offset(rectLeft + lineWidth / 2, rectTop), rectPaint);
        // canvas.drawLine(new Offset(rectRight - lineWidth / 2, rectBottom),
        //     new Offset(rectRight - lineWidth / 2, rectTop), rectPaint);

        // Draw volume bars
        Rect volumeRect = new Rect.fromLTRB(
            rectLeft, volumeBarTop, rectRight, volumeBarBottom);
        rectPaint.color = Colors.blueAccent[100];
        canvas.drawRect(volumeRect, rectPaint);
        // canvas.drawLine(new Offset(rectLeft, volumeBarBottom - lineWidth / 2),
        //     new Offset(rectRight, volumeBarBottom - lineWidth / 2), rectPaint);
        // canvas.drawLine(new Offset(rectLeft, volumeBarTop + lineWidth / 2),
        //     new Offset(rectRight, volumeBarTop + lineWidth / 2), rectPaint);
        // canvas.drawLine(new Offset(rectLeft + lineWidth / 2, volumeBarBottom),
        //     new Offset(rectLeft + lineWidth / 2, volumeBarTop), rectPaint);
        // canvas.drawLine(new Offset(rectRight - lineWidth / 2, volumeBarBottom),
        //     new Offset(rectRight - lineWidth / 2, volumeBarTop), rectPaint);
      }

      // Draw low/high candlestick wicks
      double low = height - (data[i]["low"] - _min) * heightNormalizer;
      double high = height - (data[i]["high"] - _min) * heightNormalizer;
      rectPaint = new Paint()
        ..color =
            data[i]["open"] > data[i]["close"] ? decreaseColor : increaseColor
        ..strokeWidth = 2.0;
      canvas.drawLine(
          new Offset(
              rectLeft + rectWidth / 2 - lineWidth / 2 - space / 2, rectBottom),
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2 - space / 2, low),
          rectPaint);
      canvas.drawLine(
          new Offset(
              rectLeft + rectWidth / 2 - lineWidth / 2 - space / 2, rectTop),
          new Offset(
              rectLeft + rectWidth / 2 - lineWidth / 2 - space / 2, high),
          rectPaint);
      // canvas.drawLine(
      //     new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectBottom),
      //     new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, low),
      //     rectPaint);
      // canvas.drawLine(
      //     new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectTop),
      //     new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, high),
      //     rectPaint);
    }
  }

  @override
  bool shouldRepaint(_OHLCVPainter old) {
    return data != old.data ||
        lineWidth != old.lineWidth ||
        enableGridLines != old.enableGridLines ||
        gridLineColor != old.gridLineColor ||
        gridLineAmount != old.gridLineAmount ||
        gridLineWidth != old.gridLineWidth ||
        volumeProp != old.volumeProp ||
        gridLineLabelColor != old.gridLineLabelColor;
  }
}
