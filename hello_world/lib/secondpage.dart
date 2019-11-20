import 'package:flutter/material.dart';
import 'package:hello_world/components/applicationbars.dart';
import 'package:hello_world/components/drawer.dart';

class SecondScreen extends StatelessWidget {
  final String title;
  SecondScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
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

