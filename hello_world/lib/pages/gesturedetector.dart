import 'package:flutter/material.dart';
import 'package:hello_world/components/actionbar.dart';

class MyGesturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: MyGestureExample(),
    );
  }
}
class MyGestureExample extends StatefulWidget {
  @override
  _MyGestureExampleState createState() => _MyGestureExampleState();
}

class _MyGestureExampleState extends State<MyGestureExample> {
  bool _tabbed = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _changeColor();
      },
      child: Container(
        height: 200.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: _tabbed ? Colors.lightGreen[500] : Colors.red[500],
        ),
        child: Center(
          child: _tabbed ? Text('Engage') : Text('Not engaged'),
        ),
      ),
    );
  }

  _changeColor() {
    setState(() {
      _tabbed = !_tabbed;
    });
  }
}
