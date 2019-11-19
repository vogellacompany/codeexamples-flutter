import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_overflow/data/models.dart';
import 'package:http/http.dart' as http;

const BASE_URL = 'https://api.stackexchange.com/2.2';
const SITE = "stackoverflow"; // could be any stackexchange site
// StackOverflow allows custom filters. These are the ids for both the questions and answers to return their bodies in markdown format
const ANSWER_MARKDOWN_FILTER = '!-*jbN0OTMyTb';
const QUESTION_MARKDOWN_FILTER = '!9Z(-wwK4f';

class QuestionService {
  static Future<List<Question>> fetchLatestQuestions({
    List<String> tags = const [],
  }) async {
    var requestUrl =
        '$BASE_URL/questions?site=$SITE&filter=$QUESTION_MARKDOWN_FILTER';
    if (tags.isNotEmpty) {
      var taggedString = Uri.encodeQueryComponent(tags.join(';'));
      requestUrl += '&tagged=$taggedString';
    }
    var response = await http.get(requestUrl);
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return json['items'].map<Question>((postJson) {
        return Question.fromJson(postJson);
      }).toList();
    } else {
      var error = APIError.fromJson(json);
      developer.log('Error fetching data', error: jsonEncode(json));
      return Future.error(error);
    }
  }

  static Future<List<Answer>> fetchAnswers(int questionId) async {
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
}
