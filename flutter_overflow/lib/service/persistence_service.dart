import 'package:flutter_overflow/data/models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// requires in pubspec.yaml
// dependencies:
//  path_provider: ^1.4.4

class FilePersistance {
  static void saveQuestions(List<Question> questions) async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File(directory.path + "/changes.txt");
    // just for testing
    print(directory);
    if (questions.length > 0) {
      file.writeAsString(Question.toJson(questions[0]).toString());
    }
  }

  static Future<Question> loadQuestion() async {
    //TODO throughs an exception if not commented out
    // final directory = await getApplicationDocumentsDirectory();
    // File file = File(directory.path + "/changes.txt");
    // String json = await file.readAsString();
    // Question question = Question.fromJson(jsonDecode(json));
    // print(question);
    //return question;
    return Future.delayed(Duration(seconds: 1));
  }
}
