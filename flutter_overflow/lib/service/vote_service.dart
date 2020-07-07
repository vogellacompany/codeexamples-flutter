import 'dart:convert';

import 'package:flutter_overflow/data/key.dart';
import 'package:flutter_overflow/data/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const BASE_URL = 'https://api.stackexchange.com/2.2';

Future<Answer> upvoteAnswer(int answerId) async {
  StackSecret secret = await SecretLoader(secretPath: "assets/secret.json").load();
  print(secret.apiKey);
  var accessToken = await getAccessToken();
  if(accessToken == null){
    return null;
  }
  print("access"+accessToken);
  var response = await http.post(
    '$BASE_URL/answers/$answerId/downvote?access_token=$accessToken&key=$secret.apiKey&preview=true&filter=default&site=stackoverflow'
  );
  var json = jsonDecode(response.body);
  print(json);
  if (response.statusCode == 200) {
    return Answer.fromJson(json);
  } else {
    var error = APIError.fromJson(json);
    return Future.error(error);
  }
}

Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    String value = prefs.getString(key) ?? "";
    return value;
}