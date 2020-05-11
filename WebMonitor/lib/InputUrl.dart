import 'package:flutter/material.dart';
import 'Data.dart';

//textfield with input management
class UrlForm extends StatefulWidget {

  final _UrlFormState state = new _UrlFormState();
  
  getInput(){
    return state.d;
  }

  @override
  _UrlFormState createState() => state;
}


class _UrlFormState extends State<UrlForm> {
  final myController = TextEditingController();
  final myTimeController = TextEditingController();
  String url = "null";
  Data d = Data(text: "null", seconds: 0);

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
                  Navigator.of(context).pop();
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
    }

    int timeInterval = int.parse(myTimeController.text);
    d.seconds = timeInterval;
  }

  @override
  Widget build(BuildContext context) {
    return 
     new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: 
            Container(
              height: 100.0,
              child: Column(
              children: <Widget>[
                  new Expanded(
                    child: TextField(
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
                  ),
                  new Expanded(
                    child: TextField(
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
                  )
                ],
              ),),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // this need to be put first, cannot have two alert at the same time
                    handleUrl();                    
                  })
            ],
     );
  }
}