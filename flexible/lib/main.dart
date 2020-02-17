import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: buildCustomPainer(context),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            color: Colors.blue,
            child: Text("Hello"),
          ),
        ),
        Flexible(
          flex: 4,
          child: Container(
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget buildCustomPainer(BuildContext context) {
    return CustomPaint(
      child: Center(
        child: Container(
          color: Colors.red,
          width: 200,
          height: 200,
        ),
      ),
      foregroundPainter: MyCustomPainer(),
    );
  }
}

class MyCustomPainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(75, 75), 50, Paint());
    Paint p = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..strokeWidth = 10;
    canvas.drawLine(Offset(200, 200), Offset(20, 40), p);
    canvas.drawRect(Rect.fromPoints(Offset(300, 300), Offset(50, 50)), p);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Widget buildWrap() {
  return Wrap(
    direction: Axis.vertical,
    children: <Widget>[
      MyContainer(Colors.red),
      MyContainer(Colors.blue),
      MyContainer(Colors.yellow),
      MyContainer(Colors.green),
    ],
  );
}

class MyContainer extends StatelessWidget {
  Color myColor;

  MyContainer(this.myColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: myColor,
      width: 200,
      height: 200,
    );
  }
}

Widget buildColumnWrong() {
  return Column(
    children: <Widget>[
      Flexible(
        child: Container(
          color: Colors.black,
        ),
        flex: 2,
      ),
      Flexible(
        fit: FlexFit.tight,
        child: Container(
          color: Colors.red,
          child: Text("Testing"),
        ),
        flex: 1,
      )
    ],
  );
}
