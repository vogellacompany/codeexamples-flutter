import 'package:flutter/material.dart';

import '../model/issue.dart';
import '../service/github_service.dart';
import '../util/util.dart';
import 'issue_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.service});

  final GithubService service;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Issue>> _issues;

  @override
  void initState() {
    super.initState();
    _issues = widget.service.fetchIssues();
  }

  Future<void> _refresh() async {
    final issues = widget.service.fetchIssues();
    setState(() => _issues = issues);
    await issues;
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    return Scaffold(
      appBar: AppBar(
        title: Text('${service.owner}/${service.repository}'),
      ),
      body: FutureBuilder<List<Issue>>(
        future: _issues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ErrorMessage(
              message: '${snapshot.error}',
              onRetry: _refresh,
            );
          }
          final issues = snapshot.data;
          if (issues == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (issues.isEmpty) {
            return const Center(
              child: Text('This repository has no open issues.'),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: issues.length,
              itemBuilder: (context, index) => IssueCard(
                issue: issues[index],
                service: service,
              ),
            ),
          );
        },
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  const IssueCard({super.key, required this.issue, required this.service});

  final Issue issue;
  final GithubService service;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${issue.title} #${issue.number}'),
        subtitle: Text(
          '${issue.userName} opened this ${formatDate(issue.createdAt)} ago',
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => IssuePage(issue: issue, service: service),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
