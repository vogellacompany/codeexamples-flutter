import 'package:flutter/material.dart';
import 'package:hello_world/components/actionbar.dart';
import 'package:hello_world/components/drawer.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: MyContent(),
      bottomNavigationBar: MyBottonBar(),
      drawer: MyDrawer(),
    );
  }
}

class MyContent extends StatelessWidget {
  const MyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              var snackebar = createSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackebar);
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
