import 'package:flutter/material.dart';

class MyReoderableListView extends StatefulWidget {
  @override
  _MyReoderableListViewState createState() => _MyReoderableListViewState();
}

class _MyReoderableListViewState extends State<MyReoderableListView> {
  final List<String> myItems = [
    "Example 1",
    "Example 2",
    "Example 3",
    "Example 4",
    "Example 5",
    "Example 5",
    "Example 6",
  ];

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      header: Text(
        "Reorderable Listview",
        style: TextStyle(fontSize: 40),
      ),
      padding: EdgeInsets.all(16.0),
      onReorder: (int oldPosition, int newPosition) {
        setState(() {
          String s = myItems.removeAt(oldPosition);
          myItems.insert(newPosition, s);
        });
      },
      children: <Widget>[
        for (var stuff in myItems)
          ListTile(
            key: ValueKey(stuff),
            title: Text("$stuff"),
            trailing: Icon(Icons.drag_handle),
          ),
      ],
    );
  }
}
