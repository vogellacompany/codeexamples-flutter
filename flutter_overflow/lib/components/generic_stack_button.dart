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
    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        button: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(
              const Radius.circular(4.0),
            ),
            border: Border.all(width: 1.0, color: const Color(0xFFBBBBBB)),
          ),
          child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'img/logo.png',
                  width: 40.0,
                  height: 40.0,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Lato",
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Sign in with '),
                        TextSpan(
                            text: 'StackOverflow',
                            style: TextStyle(
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