import 'package:flutter/material.dart';

class MyContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Wrap(
          children: <Widget>[
            // <.>
            FlatButton(
              onPressed: () {
                _ackAlert(context);
              },
              child: Text('Show Alert'),
            ),
            RaisedButton(
                onPressed: () {
                  var snackebar = _createSnackBar();
                  Scaffold.of(context).showSnackBar(snackebar);
                },
                child: Text('Show dialog')),
            for (int i = 1; i < 200; i++)
              RaisedButton(
                onPressed: () {},
                child: Text(i.toString()),
              ),
          ],
        ),
      ),
    );
  }

  SnackBar _createSnackBar() {
    var snackbar = SnackBar(
      content: Text('This is your message'),
      action: SnackBarAction(
        label: 'Delete',
        onPressed: () {},
      ),
    );
    return snackbar;
  }

  // <.>
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
}
