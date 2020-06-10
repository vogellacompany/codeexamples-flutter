import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_overflow/components/generic_stack_button.dart';
import 'package:flutter_overflow/pages/stack_login.dart';

export '../data/user.dart';
export '../data/tocken.dart';
export '../service/stack.dart';
export 'stack_login.dart';

class StackButton extends StatelessWidget{
  final VoidCallback onSuccess;
  final VoidCallback onCancelledByUser;
  final VoidCallback onFailure;

  final String clientId;
  final String clientSecret;
  final String redirectUrl;
  final List scope;

  const StackButton(
    {
      @required this.clientId,
      @required this.clientSecret,
      @required this.onSuccess,
      @required this.onCancelledByUser,
      @required this.onFailure,
      this.scope = const [
        'read_inbox',
        'no_expiry'
      ],
      this.redirectUrl
    }
  );

  bool get enabled =>  onSuccess != null;


  @override
  Widget build(BuildContext context) {
    return GenericStackButton (
      clientId: clientId,
      clientSecret: clientSecret,
      onCancelledByUser: onCancelledByUser,
      onFailure: onFailure,
      onSuccess: onSuccess,
      onTap: (){
        onTap(context);

      }
    );
  }

  onTap(BuildContext context) async {
    bool success = await Navigator.of(context).push(MaterialPageRoute<bool>(
      builder: (BuildContext context) => StackLoginWebViewPage(
        clientId: clientId,
        clientSecret: clientSecret,
        scope: scope,
        redirectUrl: redirectUrl == null ? "https://www.vogella.com" :redirectUrl,
      ),
    ));
    
    if(success == null){
      onCancelledByUser();
    }
    else if(success == false){
      onFailure();
    }
    else if(success){
      onSuccess();
    }
  }
}