import 'package:flutter/material.dart';
import 'package:flutter_overflow/pages/sign_in.dart';
import 'package:flutter_overflow/service/stack.dart' as stack;

class LoginPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: StackButton(
              clientId: "18040",
              clientSecret: "SjS2cdsgTmh9VlOlQQuyiA((",
              redirectUrl: "https://www.vogella.com",
              onSuccess: () async {
                String accessToken = await Token.getLocalAccessToken();
                UserList users = await stack.getUsers(accessToken);
                
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('We found ' + users.users.length.toString() + " users"),
                ));
              },
              onFailure: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Slack Login Failed'),
                ));
              },
              onCancelledByUser: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Slack Login Cancelled by user'),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}