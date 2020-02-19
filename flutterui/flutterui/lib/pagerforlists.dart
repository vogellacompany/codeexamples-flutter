import 'package:flutter/material.dart';
import 'listreorder.dart';
import 'listview.dart';
import 'listviewbuilder.dart';
import 'futurebuilder.dart';

class MyPager extends StatelessWidget {
  final PageController myController = PageController(
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        controller: myController,
        children: <Widget>[
          TodoList(),
          MyReoderableListView(),
          MyListView(), // a custom widget
          ListViewBuilder(), // another custom widget
        ],
      ),
    );
  }
}
