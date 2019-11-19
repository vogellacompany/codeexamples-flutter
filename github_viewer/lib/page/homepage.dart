import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<List<Issue>> getIssues() async {
//	const url = 'https://api.github.com/repos/flutter/flutter/issues';

	const url = 'https://api.stackexchange.com/2.2/search?order=desc&sort=votes&tagged=flutter&site=stackoverflow';
	var response = await http.get(url);
	var data = jsonDecode(response.body);
	if (response.statusCode != 200) {
		print('The API fetch failed: $data');
		return Future.error(data);
	}
  
  var items = data['items'];
	return items
			.map<Issue>((entry) {
        
			  return Issue()
				..state = 'Test'
				..title = entry['title']
				..body = entry['link']
				..userName = entry['owner']['display_name'];
			})
			.toList();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Issue Viewer'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('AppBar action pressed'); // <1>
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: FutureBuilder(
        future: getIssues(),
        builder: (BuildContext context, AsyncSnapshot<List<Issue>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length, // <1>
              itemBuilder: (BuildContext context, int index) {
                return _IssueCard(snapshot.data[index]); // <2>
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class Issue {
  // <1>
  int number = 1;
  String state = 'open';
  String title = 'Issue title';
  String body = 'Issue body';
  String userName = 'userName';
  DateTime createdAt = DateTime.now();
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
          subtitle: Text('${issue.userName} opened on ${issue.createdAt}'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            print('Issue tile tapped');
          },
        ),
      ),
    );
  }
}
