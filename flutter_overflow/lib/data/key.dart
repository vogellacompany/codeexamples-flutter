import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable(explicitToJson: true)
class StackSecret{
  @JsonKey(name: 'stack_key')
  final String stackKey;
  @JsonKey(name: 'api_key')
  final String apiKey;
  StackSecret({this.stackKey = "", this.apiKey = ""});

  factory StackSecret.fromJson(Map<String, dynamic> jsonMap){
    return StackSecret(stackKey: jsonMap["stack_key"], apiKey: jsonMap["api_key"]);
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
