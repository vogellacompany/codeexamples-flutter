import 'package:flutter/material.dart';
import 'package:hello_world/pages/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Welcome to Flutter',
      home: MyHomePage("Testing"),
    );
  }
}