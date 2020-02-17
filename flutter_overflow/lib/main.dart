import 'package:flutter/material.dart';
import 'package:flutter_overflow/pages/homepage.dart';
import 'package:flutter_overflow/service/provider_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => StackOverflowService(),
      child: MaterialApp(
        title: 'FlutterOverflow',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Homepage(),
      ),
    );
  }
}
