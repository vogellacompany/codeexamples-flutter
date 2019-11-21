import 'package:flutter/material.dart';
import 'package:hello_world/components/applicationbars.dart';
import 'package:hello_world/components/drawer.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ListContent(),
    );
  }
}

class ListContent extends StatefulWidget {
  @override
  _ListContentState createState() => _ListContentState();
}

class _ListContentState extends State<ListContent> {
  List<String> _list = ["Hello", "Testing"];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView(
          children: _list.map((f) => Text(f)).toList(),
        ),
        RaisedButton(
          onPressed: _swapList,
          child: Text("Swap"),
        )
      ],
    );
  }

  void _swapList() {
    _list = ["Stuff", "More Stuff"];
  }
}
