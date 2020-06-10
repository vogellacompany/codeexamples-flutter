import 'package:flutter/material.dart';
import 'page/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Communication',
      home: LoginPage(),
    );
  }
}

