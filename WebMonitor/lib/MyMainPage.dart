import 'package:flutter/material.dart';
import 'InputUrl.dart';
import 'Section.dart';
import 'Data.dart';

class MyMainPage extends StatefulWidget {
  @override
  _AddUrl createState() => new _AddUrl();
}

class _AddUrl extends State<MyMainPage> {
  List<Data> urls = new List<Data>();

  // function to show the alertdialog for user to enter url
  _showDialog() async {
    var form = new UrlForm();
    await showDialog<String>(
      context: context,
      child:
          new _SystemPadding(
            child: 
              form,
          ),
    );
    Data input = form.getInput();
    if(input.text != "null"){
      _addNewSection(input);
    }
  }

  _addNewSection(Data input){
    setState(() {
      //pass Data and add input
      urls.add(input);
      });
  }

  @override
  Widget build(BuildContext context) {
     List<Widget> _sections =
        new List.generate(urls.length, (int i) => new Section(input: urls[i]));


    return new Scaffold(
        appBar: AppBar(
          title: const Text('Web Monitor'),
          backgroundColor: Colors.blueGrey[900],
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showDialog();
                },
          )
          ]
        ),
        body: Center(
          child: new ListView(
            children: _sections,
            scrollDirection: Axis.vertical,
          ),
        ),
      );    
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({this.child});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    print(mediaQuery.viewInsets.bottom);
    return AnimatedContainer(
      padding: mediaQuery.padding,
      color: Colors.black.withOpacity(.5),
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}