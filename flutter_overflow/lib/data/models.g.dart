// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
      (json['tags'] as List)?.map((e) => e as String)?.toList(),
      json['owner'] == null
          ? null
          : User.fromJson(json['owner'] as Map<String, dynamic>),
      json['title'] == null ? null : unescapeHtml(json['title'] as String),
      json['question_id'] as int,
      json['creation_date'] == null
          ? null
          : creationDateFromJson(json['creation_date'] as int))
    ..isAnswered = json['is_answered'] as bool
    ..score = json['score'] as int
    ..bodyMarkdown = json['body_markdown'] == null
        ? null
        : unescapeHtml(json['body_markdown'] as String);
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'tags': instance.tags,
      'owner': instance.owner,
      'title': instance.title,
      'question_id': instance.questionId,
      'creation_date': instance.creationDate?.toIso8601String(),
      'is_answered': instance.isAnswered,
      'score': instance.score,
      'body_markdown': instance.bodyMarkdown
    };

Answer _$AnswerFromJson(Map<String, dynamic> json) {
  return Answer(
      json['owner'] == null
          ? null
          : User.fromJson(json['owner'] as Map<String, dynamic>),
      json['is_accepted'] as bool,
      json['score'] as int,
      json['creation_date'] == null
          ? null
          : creationDateFromJson(json['creation_date'] as int),
      json['answer_id'] as int,
      json['body_markdown'] == null
          ? null
          : unescapeHtml(json['body_markdown'] as String));
}

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'owner': instance.owner,
      'is_accepted': instance.isAccepted,
      'score': instance.score,
      'creation_date': instance.creationDate?.toIso8601String(),
      'answer_id': instance.answerId,
      'body_markdown': instance.bodyMarkdown
    };

APIError _$APIErrorFromJson(Map<String, dynamic> json) {
  return APIError(json['error_id'] as int, json['error_message'] as String,
      json['error_name'] as String);
}

Map<String, dynamic> _$APIErrorToJson(APIError instance) => <String, dynamic>{
      'error_id': instance.statusCode,
      'error_message': instance.errorMessage,
      'error_name': instance.errorName
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(json['reputation'] as int, json['user_id'] as int,
      json['display_name'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'reputation': instance.reputation,
      'user_id': instance.userId,
      'display_name': instance.displayName
    };
