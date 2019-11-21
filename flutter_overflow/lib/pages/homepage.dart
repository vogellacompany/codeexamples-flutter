import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overflow/components/error_screen.dart';
import 'package:flutter_overflow/components/tag.dart';
import 'package:flutter_overflow/data/models.dart';
import 'package:flutter_overflow/pages/question_page.dart';
import 'package:flutter_overflow/service/persistence_service.dart';
import 'package:flutter_overflow/service/question_service.dart';
import 'package:flutter_overflow/util.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<List<Question>> _questions;
  final TextEditingController _tagsTextEditingController = TextEditingController();
  List<String> _tags = [];

  void _showTagsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tags'),
          content: TextField(
            controller: _tagsTextEditingController,
            decoration: InputDecoration(hintText: 'Tags...'),
          ),
          actions: <Widget>[
            SimpleDialogOption(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            RaisedButton(
              child: Text('Search'),
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  _tags = _tagsTextEditingController.text.split(', ');
                  _questions = QuestionService.fetchLatestQuestions(
                    tags: _tags,
                  );
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _questions = QuestionService.fetchLatestQuestions(tags: _tags);
    super.initState();
  }

  List<Widget> _buildQuestionTiles(List<Question> questions) {
    // TODO just for testing persist data and read it again
    FilePersistance.saveQuestions(questions);
    FilePersistance.loadQuestion().then((t) => print(t));

    return questions.map((Question question) {
      return _QuestionTile(question);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.label),
            onPressed: () => _showTagsDialog(context),
          )
        ],
        title: Text('StackOverflow'),
      ),
      body: FutureBuilder(
        future: _questions,
        builder:
            (BuildContext context, AsyncSnapshot<List<Question>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return ErrorScreen(snapshot.error);
              }
              if (snapshot.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('No questions matched your filter'),
                      RaisedButton(
                        child: Text('Adjust tags'),
                        onPressed: () => _showTagsDialog(context),
                      )
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: _buildQuestionTiles(snapshot.data),
                ),
                onRefresh: () async {
                  setState(() {
                    _questions =
                        QuestionService.fetchLatestQuestions(tags: _tags);
                  });
                },
              );
            default:
              return LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              );
          }
        },
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final Question _question;

  const _QuestionTile(this._question, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_question.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(children: Tag.fromTags(_question.tags)),
          Text(
            'Opened ${formatDate(_question.creationDate)} by ${_question.owner.displayName}',
          )
        ],
      ),
      trailing: _question.isAnswered
          ? Icon(Icons.check, color: Colors.green[800])
          : null,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuestionPage(_question),
          ),
        );
      },
    );
  }
}
