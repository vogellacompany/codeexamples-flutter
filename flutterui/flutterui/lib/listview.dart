import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyListView extends StatelessWidget {
  const MyListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (int i = 0; i < 10; i++)
          SizedBox(
            height: 100,
            child: Container(
              child: Text("List elements"),
              color: Colors.blue,
            ),
          ),
      ],
    );
  }

  ListTile buildCachedNetworkImage(int index) {
    return ListTile(
      title: Text('This is a list item with number ${index.toString()}'),
      leading: CachedNetworkImage(
        placeholder: (context, url) => SizedBox(
            width: 40, height: 40, child: Icon(Icons.photo_size_select_small)),
        imageUrl: 'https://picsum.photos/id/$index/200/200',
      ),
      subtitle: Text("Subtitle"),
    );
  }
}
