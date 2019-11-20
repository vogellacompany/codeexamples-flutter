import 'package:flutter/material.dart';
import 'package:hello_world/components/applicationbars.dart';
import 'package:hello_world/components/drawer.dart';

class UserValidation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: MyAppBar(),
      body: MyInputValidation(),
    );
  }
}

class MyInputValidation extends StatefulWidget {
  @override
  _MyInputValidationState createState() => _MyInputValidationState();
}

class _MyInputValidationState extends State<MyInputValidation> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "User"),
              validator: (value) {
                if (value == null && value.isEmpty) {
                  return 'User cannot be empty';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'User cannot be empty';
                }
                return null;
              },
              obscureText: true,
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                } else {}
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
