import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;



  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
 
}

 class _MyHomePageState extends State<MyHomePage> {
  List<String> labels = ['Testing', 'Lars'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                
                Column(children: labels.map((element) => Text(element)).toList())
          ])
          ,
      ),
    );
  }  


  
  void update(List<String> labels) {
    labels.add("Testing");
  }
 } 

class _MyButton extends StatelessWidget {
   List<String> labels = ['Testing', 'Lars'];
  _MyButton({StatefulWidget this.widget, List<String> this.labels});

  @override
  Widget build(BuildContext context) {
    return RaisedButton (onPressed: () {
                  widget.setState(() {
                    update(labels);
                  });
                  
                }, child: Text('Add element')),;
  }    
  }
  
Future<void> _ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Not in stock'),
        content: const Text('This item is no longer available'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}