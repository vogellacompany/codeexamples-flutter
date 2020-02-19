import 'package:flutter/material.dart';

class EmployeeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
            child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.vogella.com/img/people/jonashungershausen.png'),
              ),
            ),
            Text(
              "Jonas",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Jonas Hungershausen"),
            Text(
              "Wohnort",
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Eclipse Dartboard project lead and Spring master developer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.call,
                ),
                onPressed: () {
                  print("Hello");
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.sms,
                ),
                onPressed: () {
                  print("Hello");
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.sms,
                ),
                onPressed: () {
                  print("Hello");
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
