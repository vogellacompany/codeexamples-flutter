import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello_world/components/actionbar.dart';
import 'package:hello_world/components/drawer.dart';
import 'package:image_picker/image_picker.dart';

class UserValidation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPhotoSelection()),
                  );
                  // If the form is valid, display a Snackbar.
                  // Scaffold.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Processing Data')));

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

class UserPhotoSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserPhotoSelection();
}

class _UserPhotoSelection extends State<StatefulWidget> {
  File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: _image== null? Icon(Icons.add_a_photo): Image.file(_image),
            ),
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                          leading: Icon(Icons.camera),
                          title: Text('Camera'),
                          onTap: () {
                            getImage(ImageSource.camera);
                            // this is how you dismiss the modal bottom sheet after making a choice
                            Navigator.pop(context);
                          }),
                      ListTile(
                          leading: Icon(Icons.image),
                          title: Text('Gallery'),
                          onTap: () {
                            getImage(ImageSource.gallery);
                            // this is how you dismiss the modal bottom sheet after making a choice
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                );
              });
        },
        tooltip: 'Pick profile image',
        child: Icon(Icons.add),
      ),
    );
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }
}
