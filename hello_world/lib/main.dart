import 'package:flutter/material.dart';
import 'package:hello_world/pages/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
			'/': (context) => MyHomePage("Testing"),
			// etc.
		},
		initialRoute: '/', // <1>
    title: 'Welcome to Flutter',
    );
  }
}
