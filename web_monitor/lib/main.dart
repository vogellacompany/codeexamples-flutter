import 'package:flutter/material.dart';

import 'my_main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyMainPage(),
    );
  } 
}