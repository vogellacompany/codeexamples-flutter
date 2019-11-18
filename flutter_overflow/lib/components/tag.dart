import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String _text;

  Tag(this._text, {Key key}) : super(key: key);

  static List<Widget> fromTags(List<String> tags) {
    return tags.map((String tag) {
      return Tag(tag);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      margin: EdgeInsets.all(1.5),
    );
  }
}
