import 'package:flutter/material.dart';
import 'content.dart';
import 'employeepage.dart';
import 'listviewbuilder.dart';
import 'listview.dart';
import 'pagerforlists.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage(this.title); // <.>

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: EmployeeWidget(),
    );
  }
}
