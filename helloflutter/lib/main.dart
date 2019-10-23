import 'package:flutter/material.dart';
import 'package:helloflutter/lib.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
   static String user = "Test";
   var message = """
      $user!
      Welcome to Programming Dart!
      """;
      print($message)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}



