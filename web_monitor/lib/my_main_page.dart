import 'package:flutter/material.dart';

import 'input_page.dart';
import 'section.dart';
import 'data.dart';

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageSate createState() => new _MyMainPageSate();
}

class _MyMainPageSate extends State<MyMainPage> {
  var urls = new List<Data>();

  inputPage(BuildContext context, Widget page) async {  
    final dataFromInputPage = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
    ) as Data;

    var data = new Data(seconds: dataFromInputPage.seconds, text: dataFromInputPage.text);

    if(data.text!="null"){
      addNewSection(data);
    }
  }

  addNewSection(Data input){
    setState(() {
      //pass Data and add input
      urls.add(input);
      });
  }

  @override
  Widget build(BuildContext context) {
     var sections =
        new List.generate(urls.length, (int i) => new Section(input: urls[i]));


    return new Scaffold(
        appBar: AppBar(
          title: const Text('Web Monitor'),
          backgroundColor: Colors.blueGrey[900],
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  inputPage(context, InputPage());
                },
          )
          ]
        ),
        body: Center(
          child: new ListView(
            children: sections,
            scrollDirection: Axis.vertical,
          ),
        ),
      );    
  }
}
