import 'package:flutter_overflow/data/models.dart';

import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

class StackOverflowService {
  Future<List<Question>> _questions;
  StackOverflowService() : _questions = _QuestionService.fetchLatestQuestions();

  Future<List<Question>> getQuestions() {
    return _questions;
  }
   Future<List<Question>> updateQuestions() {
     _questions = _QuestionService.fetchLatestQuestions();
    return _questions;
  }
}

const BASE_URL = 'https://api.stackexchange.com/2.2'; // <1>
const SITE = "stackoverflow"; // could be any stackexchange site
// StackOverflow allows custom filters. These are the ids for both the questions and answers to return their bodies in markdown format
const ANSWER_MARKDOWN_FILTER = '!-*jbN0OTMyTb';
const QUESTION_MARKDOWN_FILTER = '!9Z(-wwK4f';

class _QuestionService {
  static Future<List<Question>> fetchLatestQuestions() async {
    var requestUrl =
        '$BASE_URL/questions?site=$SITE&filter=$QUESTION_MARKDOWN_FILTER'; // <1>
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
}

