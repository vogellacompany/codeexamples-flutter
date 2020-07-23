import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_overflow/data/models.dart';
import 'package:flutter_overflow/service/question_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import 'test_data.dart';

class MockClient extends Mock implements http.Client {}

const BASE_URL = 'https://api.stackexchange.com/2.2';
const SITE = "stackoverflow"; // could be any stackexchange site
// StackOverflow allows custom filters. These are the ids for both the questions and answers to return their bodies in markdown format
const ANSWER_MARKDOWN_FILTER = '!-*jbN0OTMyTb';
const QUESTION_MARKDOWN_FILTER = '!9Z(-wwK4f';

main() {
  group('fetchQuestion', () {
    test('testing for successful result', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel channel =
          MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return './';
      });

      final client = MockClient();
      final _tags = ['c++'];
      var taggedString = Uri.encodeQueryComponent(_tags.join(';'));
      when(client.get(
              '$BASE_URL/questions?site=$SITE&filter=$QUESTION_MARKDOWN_FILTER' +
                  '&tagged=$taggedString'))
          .thenAnswer((_) async {
        return Response(json.encode(mapJson), 200);
      });

      expect(
          fetchLatestQuestions(
            tags: _tags,
            force: true,
            client: client,
          ),
          isA<Future<List<Question>>>());
    });

    test('throw exception when error', () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      const MethodChannel channel =
          MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return './';
      });

      final client = MockClient();
      final _tags = ['c++'];
      var taggedString = Uri.encodeQueryComponent(_tags.join(';'));
      when(client.get(
              '$BASE_URL/questions?site=$SITE&filter=$QUESTION_MARKDOWN_FILTER' +
                  '&tagged=$taggedString'))
          .thenAnswer((_) async {
        return Response('not found', 500);
      });

      expect(fetchLatestQuestions(tags: _tags, client: client, force: true),
          throwsA(const TypeMatcher<APIError>()));
    });
  });
}
