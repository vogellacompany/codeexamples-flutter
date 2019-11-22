import 'package:flutter/material.dart';
import 'package:hello_world/components/applicationbars.dart';
import 'package:hello_world/components/drawer.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ListContent(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _,
      // ),
    );
  }
}

class ListContent extends StatefulWidget {
  @override
  _ListContentState createState() => _ListContentState();
}

class _ListContentState extends State<ListContent> {
  List<String> _list = ["Hello", "Testing"];
  List<Widget> _widgets ;
  @override
  Widget build(BuildContext context) {
    _widgets = getList( _list);
    return Row(
      children: <Widget>[
        SizedBox(
          height: 200,
          width: 200,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: _widgets
          ),
        ),
        RaisedButton(
          child: Text("Update"),
          onPressed: _swapList,
        )
      ],
    );
  }

  void _swapList() {
    setState(() {
      _widgets = getList(["Andoid", "Flutter"]);
    });
  }

static List<Widget> getList(List<String> list) {
    return list.map((f) => Text(f)).toList();
  }
}
