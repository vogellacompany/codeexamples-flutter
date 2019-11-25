import 'package:flutter/material.dart';
import 'package:hello_world/pages/homepage.dart';
import 'package:hello_world/pages/employeepage.dart';
import 'package:hello_world/pages/chartpage.dart';
import 'package:hello_world/pages/keyspage.dart';
import 'package:hello_world/pages/toogle.dart';
import 'package:hello_world/pages/updatelisteview.dart';
import 'package:hello_world/pages/userinputpage.dart';
import 'package:hello_world/pages/gesturedetector.dart';

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
            title: Text('Start Screen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage("Home")),
              );
              // Update the state of the app.
            },
          ),
          ListTile(
            title: Text('vogella Employees'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListOfEmployees()),
              );
            },
          ),
          ListTile(
            title: Text('Chart view'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyChartPage()),
              );
            },
          ),
          ListTile(
            title: Text('Color switch'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PositionedTiles()),
              );
            },
          ),
          ListTile(
            title: Text('Input validation'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserValidation()),
              );
            },
          ),
          ListTile(
            title: Text('Stateful list'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPage()),
              );
            },
          ),
          ListTile(
            title: Text('Toogle widgets'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SampleApp()),
              );
            },
          ),
           ListTile(
            title: Text('Gesture Detector'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyGesturePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
