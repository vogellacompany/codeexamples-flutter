import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Token {
  String accessToken;
  String tokenType;

  Token.fromMap(Map json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Token(String a){
    accessToken = a;
  }

  static Future<String> getLocalAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("stack_access_token");
    return accessToken;
  }

  static Future<void> storeAccessToken(String accessToken) async {
    return SharedPreferences.getInstance().then((sharedPreferences) =>
        sharedPreferences.setString('stack_access_token', accessToken));
  }
}