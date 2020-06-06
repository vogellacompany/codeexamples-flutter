import 'package:flutter/material.dart';

import 'data.dart';

class InputPage extends StatefulWidget{
  @override
  _InputPageSate createState() => new _InputPageSate();
}

class _InputPageSate extends State<InputPage>{
  var myController = TextEditingController();
  var myTimeController = TextEditingController();
  var url = "null";
  var d = Data(text: "null", seconds: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  handleUrl() async {
    var urlPattern = r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    RegExp regExp = new RegExp(urlPattern, caseSensitive: false, multiLine: false,);
    var result = regExp.hasMatch(myController.text); 
    if(!result){
      Navigator.pop(context);
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid URL'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Please enter a new one'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, d); 
                },
              ),
            ],
          );
        },
      );
    }
    else{
      url = myController.text;
      d.text = url;
      int timeInterval = int.parse(myTimeController.text);
      d.seconds = timeInterval;
      Navigator.pop(context, d); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
     new Scaffold(
        appBar: AppBar(
          title: const Text('Type In'),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: Center(
          child: Container(
            height: 300,
              child: Column(
              children: <Widget>[
                    TextField(
                          autofocus: true,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 5.0),
                          ),
                          labelText: 'Enter Valid URL', hintText: 'http://www.vogella.com'),
                          controller: myController,
                    ),
                    TextField(
                          autofocus: true,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 5.0),
                          ),
                          labelText: 'Enter the Time Interval', hintText: 'e.g. 10'),
                          controller: myTimeController,
                    ),
                new FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context, d); 
                  }),
                new FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    handleUrl();                    
                  }),
                ],
              ),
            ),
        ),
      );
  }
}
