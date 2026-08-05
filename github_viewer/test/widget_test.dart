import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:github_viewer/page/homepage.dart';
import 'package:github_viewer/service/github_service.dart';

const _issuesJson = '''
[
  {
    "number": 1,
    "state": "open",
    "title": "First issue",
    "body": "Something is broken",
    "user": {"login": "alice"},
    "created_at": "2026-08-01T10:00:00Z"
  },
  {
    "number": 2,
    "state": "open",
    "title": "A pull request",
    "body": null,
    "user": {"login": "bob"},
    "created_at": "2026-08-02T10:00:00Z",
    "pull_request": {"url": "https://example.com/pull/2"}
  }
]
''';

GithubService serviceReturning(String body, {int status = 200}) {
  return GithubService(
    client: MockClient((request) async => http.Response(body, status)),
  );
}

void main() {
  test('parses issues and skips pull requests', () async {
    final issues = await serviceReturning(_issuesJson).fetchIssues();

    expect(issues, hasLength(1));
    expect(issues.single.title, 'First issue');
    expect(issues.single.userName, 'alice');
    expect(issues.single.state, 'open');
  });

  test('reports a rejected request', () {
    expect(
      serviceReturning('{}', status: 403).fetchIssues(),
      throwsA(isA<GithubException>()),
    );
  });

  testWidgets('lists the issues returned by the service', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Homepage(service: serviceReturning(_issuesJson))),
    );
    await tester.pump();

    expect(find.textContaining('First issue'), findsOneWidget);
    expect(find.textContaining('A pull request'), findsNothing);
  });
}
