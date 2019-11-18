import 'package:flutter/material.dart';
import 'package:flutter_overflow/data/models.dart';

class ErrorScreen extends StatelessWidget {
  final APIError _error;

  ErrorScreen(this._error, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('An error ocurred'),
          Text('code: ${_error.statusCode}'),
          Text('name: ${_error.errorName}'),
          Text('message: ${_error.errorMessage}')
        ],
      ),
    );
  }
}
