import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:hello_world/homepage.dart';
import 'package:hello_world/secondpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(),
        body: Text('This is Flutter'),
      ),
    );
  }

  void _called() {
    print("Debug");
  }
}

class MyBottonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.call),
              onPressed: _called,
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: _called,
            ),
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: _called,
            ),
            IconButton(
              icon: Icon(Icons.access_alarm),
              onPressed: _called,
            ),
          ],
        ),
      ),
    );
  }

  void _called() {
    print("Debug");
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
        ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              new PopupMenuItem(
                child: Text('Hello'),
              )
            ];
          },
        )
      ],
    );
  }

  void _called() {
    print("Debug");
  }

  @override
  Size get preferredSize => Size.fromHeight(40);
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage("Home")),
              );
              // Update the state of the app.
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondScreen("Next")),
              );
            },
          ),
        ],
      ),
    );
  }
}
