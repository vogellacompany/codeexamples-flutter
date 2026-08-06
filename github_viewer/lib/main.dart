import 'package:flutter/material.dart';

import 'page/homepage.dart';
import 'service/github_service.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Issue Viewer',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: Homepage(service: GithubService()),
    );
  }
}
