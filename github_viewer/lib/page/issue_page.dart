import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github_viewer/page/homepage.dart';
import 'package:github_viewer/util/util.dart';
import 'package:http/http.dart' as http;

class IssuePage extends StatefulWidget {
  final Issue issue;

  IssuePage(this.issue);

  @override
  State<StatefulWidget> createState() {
    return _IssueState();
  }
}

class IssueComment {
  String body;
  String userName;
  DateTime createdAt;
}

class _IssueState extends State<IssuePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.issue.title),
      ),
      body: FutureBuilder(
        future: getComments(),
        builder:
            (BuildContext context, AsyncSnapshot<List<IssueComment>> snapshot) {
          if (snapshot.hasData) {
            var widgets = <Widget>[_IssueContent(widget.issue)];
            if (snapshot.data.length > 0) {
              widgets.add(Divider());
              widgets.addAll(snapshot.data
                  .map<Widget>((comment) => _IssueComment(comment))
                  .toList());
            }

            return ListView(children: widgets);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<List<IssueComment>> getComments() async {
    var url =
        'https://api.stackexchange.com/2.2/questions/${widget.issue.number}/answers?order=desc&sort=activity&site=stackoverflow';
    var response = await http.get(url);

    var data = jsonDecode(response.body);

    return data['items']
        .map<IssueComment>((entry) => IssueComment()
          ..body = entry['url']
          ..userName = entry['owner']['display_name']
          ..createdAt = DateTime.now())
        .toList();
  }
}

class _IssueComment extends StatelessWidget {
  final IssueComment comment;

  _IssueComment(this.comment);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(right: 12.0, left: 12, bottom: 12),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: _ItemInfo(
                      comment.userName,
                      'commented ${formatDate(DateTime.now())} ago',
                    ),
                  ),
                )
              ],
            ),
            Text(comment.body),
          ],
        ),
      ),
    );
  }
}

class _ItemInfo extends StatelessWidget {
  final String firstPart;
  final String secondPart;

  _ItemInfo(this.firstPart, this.secondPart);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstPart,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' $secondPart',
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}

class _IssueContent extends StatelessWidget {
  final Issue issue;
  _IssueContent(this.issue);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            _IssueStateRow(issue),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: MarkdownBody(data: issue.body),
            ),
          ],
        ),
      ),
    );
  }
}

const stateColors = {'open': Colors.green, 'closed': Colors.red};

class _IssueStateRow extends StatelessWidget {
  final Issue issue;

  _IssueStateRow(this.issue);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Container(
              padding: EdgeInsets.all(3),
              child: Text(
                '${issue.state}',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                color: stateColors[issue.state],
                borderRadius: BorderRadiusDirectional.all(
                  Radius.circular(3),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: _ItemInfo(
            issue.userName,
            'opened this issue 3 days ago',
          ),
        )
      ],
    );
  }
}
