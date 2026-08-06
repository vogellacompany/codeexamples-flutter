import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../model/issue.dart';
import '../service/github_service.dart';
import '../util/util.dart';

const stateColors = {'open': Colors.green, 'closed': Colors.red};

class IssuePage extends StatefulWidget {
  const IssuePage({super.key, required this.issue, required this.service});

  final Issue issue;
  final GithubService service;

  @override
  State<IssuePage> createState() => _IssueState();
}

class _IssueState extends State<IssuePage> {
  late Future<List<IssueComment>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = widget.service.fetchComments(widget.issue.number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('#${widget.issue.number}')),
      body: FutureBuilder<List<IssueComment>>(
        future: _comments,
        builder: (context, snapshot) {
          final children = <Widget>[_IssueContent(issue: widget.issue)];

          if (snapshot.hasError) {
            children.add(
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            final comments = snapshot.data!;
            if (comments.isNotEmpty) {
              children.add(const Divider());
              children.addAll(
                comments.map((comment) => _IssueComment(comment: comment)),
              );
            }
          } else {
            children.add(
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return ListView(children: children);
        },
      ),
    );
  }
}

class _IssueContent extends StatelessWidget {
  const _IssueContent({required this.issue});

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(issue.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _IssueStateRow(issue: issue),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: MarkdownBody(data: issue.body),
            ),
          ],
        ),
      ),
    );
  }
}

class _IssueStateRow extends StatelessWidget {
  const _IssueStateRow({required this.issue});

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: stateColors[issue.state] ?? Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
          ),
          child: Text(
            issue.state,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ItemInfo(
            firstPart: issue.userName,
            secondPart: 'opened this ${formatDate(issue.createdAt)} ago',
          ),
        ),
      ],
    );
  }
}

class _IssueComment extends StatelessWidget {
  const _IssueComment({required this.comment});

  final IssueComment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _ItemInfo(
              firstPart: comment.userName,
              secondPart: 'commented ${formatDate(comment.createdAt)} ago',
            ),
            const SizedBox(height: 8),
            MarkdownBody(data: comment.body),
          ],
        ),
      ),
    );
  }
}

class _ItemInfo extends StatelessWidget {
  const _ItemInfo({required this.firstPart, required this.secondPart});

  final String firstPart;
  final String secondPart;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: firstPart,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' $secondPart',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
