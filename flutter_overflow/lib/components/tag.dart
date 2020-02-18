import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String _text;
  final Function(String tag) onDelete;

  bool get deletable => onDelete != null;

  Tag(this._text, {this.onDelete, Key key}) : super(key: key);

  static List<Widget> fromTags(List<String> tags,
      {Function(String tag) onDelete}) {
    return tags.map((String tag) {
      return Tag(
        tag,
        onDelete: onDelete,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(deletable ? 5.0 : 3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: GestureDetector(
        child: Text(
          _text,
          style: Theme.of(context).primaryTextTheme.body1
        ),
        onTap: () {
          if (onDelete != null) onDelete(_text);
        },
      ),
      margin: EdgeInsets.all(1.5),
    );
  }
}
