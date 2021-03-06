import 'package:flutter/material.dart';
import 'package:hello_world/components/actionbar.dart';
import 'package:hello_world/components/drawer.dart';

class ListOfEmployees extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: ListView(
        children: <Widget>[
          EmployeeWidget(
            name: 'Lars Vogel',
            url: 'https://www.vogella.com/img/people/larsvogel.png',
          ),
          EmployeeWidget(
            name: 'Jonas Hungershausen',
            url: 'https://www.vogella.com/img/people/jonashungershausen.png',
          ),
        ],
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage('$url'),
                  child: Text('$name'),
                ),
              ),
              Container(
                child: Center(
                  
                  child: Text('$name',
                   style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),),
                ),
              ),
            ],
          ),
        ),
        Icon(
  Icons.star,
  color: Colors.red[500],
),
        TitleSection(name),
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'For the customers of the vogella GmbH he delivers development, consulting, coaching and training in the areas of Eclipse, Android and Git. These customers include Fortune 100 corporations as well as individual developers.',
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
                  'Haindaalwisch 17a',
                ),
              ),
              Text(
                'Hamburg, Germany',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
