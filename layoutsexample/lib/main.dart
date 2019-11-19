import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layouting',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('vogella employee'),
        ),

        body: ListView(children: <Widget>[
          new EmployeeWidget(
            name: 'Lars Vogel',
            url: 'https://www.vogella.com/img/people/larsvogel.png',
          ),
         new EmployeeWidget(
            name: 'Jonas Hungershausen',
            url: 'https://www.vogella.com/img/people/jonashungershausen.png',
          ),
        ],
        ),
        
      ),
    );
  }
}

class EmployeeWidget extends StatelessWidget {
  final String name;
  final String url;

  EmployeeWidget({this.name, this.url});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          child: Image.network(
            '$url',
            height: 100,
          ),
        ),
        TitleSection(name),
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'For the customers of the vogella GmbH....',
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ButtonBarWidget(),
      ],
    );
  }
}

class ButtonBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildColumn("Call", Icons.call),
          buildColumn("Send SMS", Icons.sms),
          buildColumn("Help", Icons.help)
        ],
      ),
    );
  }

  Column buildColumn(String text, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon),
        Container(
          padding: EdgeInsets.only(top: 16),
          child: Text(text),
        )
      ],
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;

  TitleSection(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 8, top: 16),
                child: Text(
                  'Adresse 1',
                ),
              ),
              Text(
                'Hamburg, Germany',
                style: TextStyle(
                  color: Colors.red[500],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
