import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final String text;

  Background(this.text);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width,
        height: height - 25,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(text,
            style: TextStyle(
              fontSize: 48, fontFamily: "Megrim", color: Colors.white)),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
            colors: [
              Colors.amberAccent,
              Color(0xffF5F8FA),
              // Colors.brown,
            ],
          ),
        ));
  }
}
