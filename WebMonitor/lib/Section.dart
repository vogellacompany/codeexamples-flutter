import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Data.dart';
import 'dart:async';

class Section extends StatefulWidget{
  final Data input;

  const Section ({ Key key, this.input }): super(key: key);

  @override
  _SectionState createState() => new _SectionState();
}

class _SectionState extends State<Section> {
  bool _isOnline = false;
  int _totalCheck = 0;
  int _totalOnline = 0;
  bool _on = false;

  void _online(){
    setState(() {
      _isOnline = true;
      _totalCheck++;
      _totalOnline++;
    });
  }

    void _offline(){
    setState(() {
      _isOnline = false;
      _totalCheck++;
    });
  }


_press(String url){
  if(!_on){
  _on = true;
  Duration secin = Duration(seconds: widget.input.seconds);
  new Timer.periodic(secin, (Timer t) {
    fetchStatus(url);
    });
  }
}

Future fetchStatus(String url) async {
  final response = await http.get(url);
  if(response.statusCode ==  200){
    _online();
  }
  else{
    _offline();
  }
}

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.blueGrey,
      child: Column(
        children: <Widget>[
        Text(
          widget.input.text,
          style: TextStyle(fontSize: 20),
        ),
        new Row(
          children: <Widget>[
            new Container(
            padding: new EdgeInsets.all(0.0),
            child: new IconButton(
              icon: (_isOnline
                  ? new Icon(Icons.star)
                  : new Icon(Icons.star_border)),
              color: Colors.red[500],
              onPressed: () => _press(widget.input.text),
            ),
          ),
          new AnimatedContainer(
            height: 20,
            color: Colors.blueGrey,
            duration: Duration(seconds:10),
            child: Text(
              (_totalOnline).toString()+'/'+_totalCheck.toString(), 
            style: TextStyle(fontSize: 20),),
            ),
          ],),
        ],),
    );
  }
}
