import 'package:flutter/material.dart';
import 'package:hello_world/homepage.dart';
import 'package:http/http.dart' as http;

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