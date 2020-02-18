import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_overflow/data/models.dart';
import 'package:flutter_overflow/service/persistence_service.dart';
import 'package:http/http.dart' as http;

const BASE_URL = 'https://api.stackexchange.com/2.2';
const SITE = "stackoverflow"; // could be any stackexchange site
// StackOverflow allows custom filters. These are the ids for both the questions and answers to return their bodies in markdown format
const ANSWER_MARKDOWN_FILTER = '!-*jbN0OTMyTb';
const QUESTION_MARKDOWN_FILTER = '!9Z(-wwK4f';

Future<List<Question>> fetchLatestQuestions({
  List<String> tags,
  bool force = false,
}) async {
  if (force) {
    var requestUrl =
        '$BASE_URL/questions?site=$SITE&filter=$QUESTION_MARKDOWN_FILTER';
    if (tags != null && tags.isNotEmpty) {
      var taggedString = Uri.encodeQueryComponent(tags.join(';'));
      requestUrl += '&tagged=$taggedString';
    }
    try {
      var response = await http.get(requestUrl);
      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var questions = json['items'].map<Question>((postJson) {
          return Question.fromJson(postJson);
        }).toList();

        saveQuestionsToCache(questions);

        return questions;
      } else {
        var error = APIError.fromJson(json);
        developer.log('Error fetching data', error: jsonEncode(json));
        return Future.error(error);
      }
    } catch (e) {
      var error = APIError(999, 'Failed to fetch data', '');
      return Future.error(error);
    }
  } else {
    try {
      return await loadQuestionsFromCache();
    } on QuestionsNotFoundException catch (_) {
      return fetchLatestQuestions(tags: tags, force: true);
    }
  }
}

Future<List<Answer>> fetchAnswers(int questionId) async {
  var response = await http.get(
    '$BASE_URL/questions/$questionId/answers?site=$SITE&filter=$ANSWER_MARKDOWN_FILTER',
  );
  var json = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return json['items'].map<Answer>((answerJson) {
      return Answer.fromJson(answerJson);
    }).toList();
  } else {
    var error = APIError.fromJson(json);
    return Future.error(error);
  }
}
