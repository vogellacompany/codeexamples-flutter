/// An issue of a GitHub repository.
class Issue {
  Issue({
    required this.number,
    required this.state,
    required this.title,
    required this.body,
    required this.userName,
    required this.createdAt,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      number: json['number'] as int,
      state: json['state'] as String,
      // An issue without a description has a null body.
      body: json['body'] as String? ?? '',
      title: json['title'] as String,
      userName: (json['user'] as Map<String, dynamic>)['login'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final int number;
  final String state;
  final String title;
  final String body;
  final String userName;
  final DateTime createdAt;
}

/// A comment on a GitHub issue.
class IssueComment {
  IssueComment({
    required this.body,
    required this.userName,
    required this.createdAt,
  });

  factory IssueComment.fromJson(Map<String, dynamic> json) {
    return IssueComment(
      body: json['body'] as String? ?? '',
      userName: (json['user'] as Map<String, dynamic>)['login'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final String body;
  final String userName;
  final DateTime createdAt;
}
