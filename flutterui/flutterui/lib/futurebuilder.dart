import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyTool extends StatelessWidget {
  const MyTool({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}

class TodoList extends StatelessWidget {
  final Future<List<Todo>> test = _getTodos();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, number) {
              return ListTile(
                title: Text(
                    "Item+ $number ${(snapshot.data[number] as Todo).userId}"),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      future: _getTodos(),
    ));
  }
}

class Todo {
  int userId;
  Todo._internal({this.userId});
  factory Todo(Map<String, dynamic> map) {
    var userId = map['userId'];
    return Todo._internal(userId: userId);
  }
}

Future<List<Todo>> _getTodos() async {
  List<Todo> todos = List();
  http.Response response =
      await http.get("https://jsonplaceholder.typicode.com/todos");
  if (response.statusCode == 200) {
    String body = response.body;
    var json = jsonDecode(body);
    for (Map<String, dynamic> map in json) {
      todos.add(Todo(map));
    }
  }
  return todos;
}
