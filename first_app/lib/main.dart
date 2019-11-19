import 'package:flutter/material.dart';

main(List<String> args) {
  runApp(MyApplication());
}

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int help = 5;
    print("Hello $help");
    return MaterialApp (
      title: 'Testing Flutter',
      home: Scaffold(
        appBar: AppBar(
          
        ),
        body: Text('Hello'),
      ) 
    );
  }
}
