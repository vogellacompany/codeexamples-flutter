import 'package:flutter/material.dart';
import 'MyMainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
    @override
    _MyApp createState() => new _MyApp();
}


class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: MyMainPage(),
    );
  }
}