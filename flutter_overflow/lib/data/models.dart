import 'package:flutter_overflow/util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  int reputation;
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'display_name')
  String displayName;

  User(this.reputation, this.userId, this.displayName);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }
}

@JsonSerializable(explicitToJson: true)
class Question {
  List<String> tags;
  User owner;
  @JsonKey(fromJson: unescapeHtml)
  String title;
  @JsonKey(name: 'question_id')
  int questionId;
  @JsonKey(
      name: 'creation_date',
      fromJson: creationDateFromJson,
      toJson: creationDateToJson)
  DateTime creationDate;
  @JsonKey(name: 'is_answered')
  bool isAnswered;
  int score;
  @JsonKey(name: 'body_markdown', fromJson: unescapeHtml)
  String bodyMarkdown;

  Question(this.tags, this.owner, this.title, this.questionId,
      this.creationDate, this.isAnswered, this.score, this.bodyMarkdown);

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() {
    return _$QuestionToJson(this);
  }
}

@JsonSerializable(explicitToJson: true)
class Answer {
  User owner;
  @JsonKey(name: 'is_accepted')
  bool isAccepted;
  int score;
  @JsonKey(name: 'creation_date', fromJson: creationDateFromJson)
  DateTime creationDate;
  @JsonKey(name: 'answer_id')
  int answerId;
  @JsonKey(name: 'body_markdown', fromJson: unescapeHtml)
  String bodyMarkdown;

  Answer(
    this.owner,
    this.isAccepted,
    this.score,
    this.creationDate,
    this.answerId,
    this.bodyMarkdown,
  );

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() {
    return _$AnswerToJson(this);
  }
}

@JsonSerializable()
class APIError {
  @JsonKey(name: 'error_id')
  int statusCode;
  @JsonKey(name: 'error_message')
  String errorMessage;
  @JsonKey(name: 'error_name')
  String errorName;

  APIError(this.statusCode, this.errorMessage, this.errorName);

  factory APIError.fromJson(Map<String, dynamic> json) =>
      _$APIErrorFromJson(json);
}
