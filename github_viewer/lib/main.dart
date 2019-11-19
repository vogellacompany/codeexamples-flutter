import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_viewer/page/homepage.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}
