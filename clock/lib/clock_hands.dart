import 'dart:async';

import 'package:clock/hand_hour.dart';
import 'package:clock/hand_minute.dart';
import 'package:clock/hand_second.dart';
import 'package:flutter/material.dart';
class ClockHands extends StatefulWidget {
  @override
  _ClockHandState createState() => new _ClockHandState();
}

class _ClockHandState extends State<ClockHands> {
  Timer _timer;
  DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = new DateTime.now();
    _timer = new Timer.periodic(const Duration(seconds: 1), setTime);
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = new DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            fit: StackFit.expand,
              children: <Widget>[
                  CustomPaint( painter: new HourHandPainter(
                    hours: dateTime.hour, minutes: dateTime.minute),
                  ),
                  CustomPaint( painter: new MinuteHandPainter(
                    seconds: dateTime.second,
                    minutes: dateTime.minute),
                  ),
                  CustomPaint( painter: new SecondHandPainter(
                    seconds:dateTime.second , 
                  ),  
                  ),
                ]
              )
        )

    );
  }
}