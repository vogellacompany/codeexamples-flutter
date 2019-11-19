import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_viewer/page/issue_page.dart';
import 'package:github_viewer/util/util.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class Issue {
  int number;
  String state;
  String title;
  String body;
  String userName;
  DateTime createdAt;
}

class _HomepageState extends State<Homepage> {
  Future<List<Issue>> issues;

  @override
  Widget build(BuildContext context) {
    issues = getIssues();
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Issue Viewer'),
      ),
      body: FutureBuilder(
        future: issues,
        builder: (BuildContext context, AsyncSnapshot<List<Issue>> snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async {
                return issues = getIssues();
              },
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return _IssueCard(snapshot.data[index]);
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Container(
              padding: EdgeInsets.all(80.0),
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Issue>> getIssues() async {
    const url =
        'https://api.stackexchange.com/2.2/search?order=desc&sort=votes&tagged=flutter&site=stackoverflow';
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      print('The API fetch failed: $data');
      return Future.error(data);
    }

    var items = data['items'];
    return items.map<Issue>((entry) {
      return Issue()
        ..state = 'Test'
        ..number = entry['question_id']
        ..title = entry['title']
        ..body = entry['link']
        ..userName = entry['owner']['display_name'];
    }).toList();
  }
}

class _IssueCard extends StatelessWidget {
  final Issue issue;

  _IssueCard(this.issue);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text('${issue.title} #${issue.number}'),
          subtitle: Text(
              '${issue.userName}'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => IssuePage(issue),
              ),
            );
          },
        ),
      ),
    );
  }
}
