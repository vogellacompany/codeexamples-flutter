import 'package:flutter/material.dart';
import 'package:hello_world/applicationbars.dart';

class SecondScreen extends StatelessWidget {
  final String title;
  SecondScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: new SecondPageContent(),
      drawer: MyDrawer(),
    );
  }
}

class SecondPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Hello");
  }
}

