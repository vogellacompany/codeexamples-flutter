import 'package:flutter/material.dart';
import 'package:hello_world/applicationbars.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: new MyContent(),
      bottomNavigationBar: MyBottonBar(),
      drawer: MyDrawer(),
    );
  }
}

class MyContent extends StatelessWidget {
  const MyContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              var snackebar = createSnackBar();
              Scaffold.of(context).showSnackBar(snackebar);
            },
            child: Text('Show'),
          )
        ],
      ),
    );
  }
}

SnackBar createSnackBar() {
  var snackbar = SnackBar(
    content: Text('This is your message'),
    elevation: 6.0,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Delete',
      onPressed: () {},
    ),
  );
  return snackbar;
}
