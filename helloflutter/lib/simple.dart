import 'package:flutter/material.dart';

class VogellaSimpleWidget extends StatelessWidget {

VogellaSimpleWidget({Key key, this.title}) : super(key: key);

final String title;
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body:
        Text('Hello')
    );
  }
}


