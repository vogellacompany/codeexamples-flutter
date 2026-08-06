import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/issue.dart';

/// Thrown when the GitHub API answers with an unexpected status code.
class GithubException implements Exception {
  GithubException(this.statusCode, this.uri);

  final int statusCode;
  final Uri uri;

  @override
  String toString() {
    if (statusCode == 403) {
      return 'GitHub rejected the request. Unauthenticated clients are '
          'limited to 60 requests per hour.';
    }
    return 'GitHub request to $uri failed with status $statusCode.';
  }
}

/// Reads issues and comments from the GitHub REST API.
class GithubService {
  GithubService({
    http.Client? client,
    this.owner = 'flutter',
    this.repository = 'flutter',
    this.token,
  }) : _client = client ?? http.Client();

  static const _host = 'api.github.com';

  final http.Client _client;
  final String owner;
  final String repository;

  /// A personal access token. Without one GitHub allows 60 requests per hour.
  final String? token;

  Future<List<Issue>> fetchIssues({int perPage = 20}) async {
    final uri = Uri.https(_host, '/repos/$owner/$repository/issues', {
      'per_page': '$perPage',
    });
    final decoded = await _getJson(uri) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        // GitHub reports pull requests through the issue endpoint as well.
        .where((entry) => !entry.containsKey('pull_request'))
        .map(Issue.fromJson)
        .toList();
  }

  Future<List<IssueComment>> fetchComments(int issueNumber) async {
    final uri = Uri.https(
      _host,
      '/repos/$owner/$repository/issues/$issueNumber/comments',
    );
    final decoded = await _getJson(uri) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        .map(IssueComment.fromJson)
        .toList();
  }

  Future<dynamic> _getJson(Uri uri) async {
    final response = await _client.get(uri, headers: {
      'Accept': 'application/vnd.github+json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
    if (response.statusCode != 200) {
      throw GithubException(response.statusCode, uri);
    }
    return jsonDecode(response.body);
  }
}
