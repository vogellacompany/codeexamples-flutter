import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart';

class StackSecret{
  final String stackKey;

  StackSecret({this.stackKey = ""});

  factory StackSecret.fromJson(Map<String, dynamic> jsonMap){
    return new StackSecret(stackKey: jsonMap["stack_key"]);
  }
}

class SecretLoader{
 final String secretPath;

 SecretLoader({this.secretPath});

 Future<StackSecret> load() {
   return rootBundle.loadStructuredData<StackSecret>(this.secretPath,
   (jsonStr) async{
     final secret = StackSecret.fromJson(json.decode(jsonStr));
     return secret;
   });
 }
}