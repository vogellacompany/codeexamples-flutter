import 'package:flutter_overflow/data/models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// requires in pubspec.yaml
// dependencies:
//  path_provider: ^1.4.4

void saveQuestionsToCache(List<Question> questions) async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File(directory.path + "/questions.json");
  if (questions.isNotEmpty) {
    await file.writeAsString(jsonEncode(questions));
  }
}

Future<List<Question>> loadQuestionsFromCache() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(directory.path + "/questions.json");
  if (!await file.exists()) {
    throw QuestionsNotFoundException();
  }
  String json = await file.readAsString();
  var questions = jsonDecode(json);
  return questions
      .map<Question>((question) => Question.fromJson(question))
      .toList();
}

class QuestionsNotFoundException extends Error {}
