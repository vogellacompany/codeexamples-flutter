// Entry point used to capture the book figures.
// Run it through tool/screenshots.sh in the repository root.
import 'package:flutter/material.dart';

import 'package:github_viewer/model/issue.dart';
import 'package:github_viewer/page/homepage.dart';
import 'package:github_viewer/page/issue_page.dart';
import 'package:github_viewer/service/github_service.dart';

const screen = String.fromEnvironment('SCREEN', defaultValue: 'list');

void main() => runApp(const ScreenshotApp());

class ScreenshotApp extends StatelessWidget {
  const ScreenshotApp({super.key});

  @override
  Widget build(BuildContext context) {
    final service = GithubService();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: screen == 'detail'
          ? _FirstIssue(service: service)
          : Homepage(service: service),
    );
  }
}

/// Opens the detail page of the first issue that has a description.
class _FirstIssue extends StatefulWidget {
  const _FirstIssue({required this.service});

  final GithubService service;

  @override
  State<_FirstIssue> createState() => _FirstIssueState();
}

class _FirstIssueState extends State<_FirstIssue> {
  late final Future<List<Issue>> _issues = widget.service.fetchIssues();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Issue>>(
      future: _issues,
      builder: (context, snapshot) {
        final issues = snapshot.data;
        if (issues == null || issues.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final issue = issues.firstWhere(
          (candidate) => candidate.body.trim().length > 80,
          orElse: () => issues.first,
        );
        return IssuePage(issue: issue, service: widget.service);
      },
    );
  }
}
