import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GenericStackButton extends StatelessWidget{
  final VoidCallback onSuccess;
  final VoidCallback onCancelledByUser;
  final VoidCallback onFailure;
  final VoidCallback onTap;

  final String clientId;
  final String clientSecret;
  final String redirectUrl;

  const GenericStackButton(
    {
      @required this.clientId,
      @required this.clientSecret,
      @required this.onSuccess,
      @required this.onFailure,
      @required this.onCancelledByUser,
      @required this.onTap,
      this.redirectUrl
    }
  );

  bool get enabled =>  onSuccess != null;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: new Semantics(
        button: true,
        child: new DecoratedBox(
          decoration: new BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: new BorderRadius.all(
              const Radius.circular(4.0),
            ),
            border: new Border.all(width: 1.0, color: const Color(0xFFBBBBBB)),
          ),
          child: new Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'img/logo.png',
                  width: 40.0,
                  height: 40.0,
                ),
                new Padding(
                  padding: new EdgeInsets.only(right: 12.0),
                  child: new RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Lato",
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'Sign in with '),
                        new TextSpan(
                            text: 'StackOverflow',
                            style: new TextStyle(
                                fontFamily: "Lato",
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}