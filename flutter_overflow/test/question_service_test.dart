import 'package:flutter/services.dart';
import 'package:flutter_overflow/data/models.dart';
import 'package:flutter_overflow/service/question_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

class MockClient extends Mock implements http.Client {}

const BASE_URL = 'https://api.stackexchange.com/2.2';
const SITE = "stackoverflow"; // could be any stackexchange site
// StackOverflow allows custom filters. These are the ids for both the questions and answers to return their bodies in markdown format
const ANSWER_MARKDOWN_FILTER = '!-*jbN0OTMyTb';
const QUESTION_MARKDOWN_FILTER = '!9Z(-wwK4f';

main(){
 /* group('fetchQuestion', (){
    
    test('load from cache', ()async{
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return './';
      });
   
      final client = MockClient();

      when(client.get('$BASE_URL/questions?site=$SITE&filter=$QUESTION_MARKDOWN_FILTER'))
      .thenAnswer((_) async => http.Response('{"title": "test"}', 200));

      expect(fetchLatestQuestions(client: client), isA<Future<List<Question>>>());
    });
    
    test('wrong json format', ()async{
      TestWidgetsFlutterBinding.ensureInitialized();

      const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return './';
      });

      
      
      final client = MockClient();

      when(client.get('$BASE_URL/questions?site=$SITE&filter=$QUESTION_MARKDOWN_FILTER'))
      .thenAnswer((_) async => http.Response('{"title": "test"}', 200));

      expect(fetchLatestQuestions(client: client, force:true), throwsA(const TypeMatcher<APIError>()));
    });
    test('throw exception when error', ()async{
      TestWidgetsFlutterBinding.ensureInitialized();

      const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return './';
      });

      
      
      final client = MockClient();

      when(client.get('$BASE_URL/questions?site=$SITE&filter=$QUESTION_MARKDOWN_FILTER'))
      .thenAnswer((_) async => http.Response('not found', 404));


      expect(fetchLatestQuestions(client: client, force: true), throwsA(const TypeMatcher<APIError>()));
    });

  }); */
}