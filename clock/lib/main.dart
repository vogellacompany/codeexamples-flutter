import 'package:flutter/material.dart';
import 'package:clock/clock_face.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.ac_unit),
              onPressed: null,
            ),
          ],
        ),
        body: Clock(),
      ),
    );
  }
}

class Clock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
              aspectRatio: 1.0,
              child: Stack(children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0.0, 5.0),
                        blurRadius: 5.0,
                      )
                    ],
                  ),
                ),
                ClockFace(),
              ]))
        ],
      ),
    );
  }
}
