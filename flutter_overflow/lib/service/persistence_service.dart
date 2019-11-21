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
    if (questions.isNotEmpty) {
      
      await file.writeAsString(jsonEncode(questions));
    }
  }

  static Future<List<Question>> loadQuestion() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File(directory.path + "/changes.txt");
    String json = await file.readAsString();
    var questions = jsonDecode(json);
    return questions.map<Question>((question) => Question.fromJson(question)).toList();
  }
}
