import 'package:clock/clock_dial_painter.dart';
import 'package:clock/clock_hands.dart';
import 'package:flutter/material.dart';

class ClockFace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              //dial and numbers go here
              new Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(10.0),
                child: new CustomPaint(
                  painter: new ClockDialPainter(clockText: ClockText.arabic),
                ),
              ),

              //clock hands go here
              // the point in the middle
              Centerpoint(),
              ClockHands(),
            ],
          ),
        ),
      ),
    );
  }
}

class Centerpoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 15.0,
        height: 15.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      ),
    );
  }
}
