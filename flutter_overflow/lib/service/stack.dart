import 'dart:async';
import 'dart:convert';

import 'package:flutter_overflow/data/user.dart';
import 'package:flutter_overflow/data/user_identity.dart';
import 'package:http/http.dart' as http;

Future<UserIdentity> getUserIdentity(String accessToken) async {
  String endpoint = "https://stack.com/api/users.identity?token=$accessToken";
  final http.Response response = await http.get(endpoint);

  return new UserIdentity.fromMap(json.decode(response.body));
}

Future<UserList> getUsers(String accessToken) async {
  String endpoint = "https://stack.com/api/users.list?token=$accessToken";
  final http.Response response = await http.get(endpoint);

  return new UserList.fromMap(json.decode(response.body));
}