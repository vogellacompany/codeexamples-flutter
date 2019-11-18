import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_overflow/components/error_screen.dart';
import 'package:flutter_overflow/components/tag.dart';
import 'package:flutter_overflow/data/models.dart';
import 'package:flutter_overflow/service/question_service.dart';
import 'package:flutter_overflow/util.dart';

class QuestionPage extends StatefulWidget {
  final Question _question;

  QuestionPage(this._question, {Key key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Future<List<Answer>> _answers;

  @override
  void initState() {
    _answers = QuestionService.fetchAnswers(widget._question.questionId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget._question.title}'),
      ),
      body: FutureBuilder(
        future: _answers,
        builder: (BuildContext context, AsyncSnapshot<List<Answer>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return ErrorScreen(snapshot.error);
              }
              var answers = snapshot.data;
              answers.sort((answer1, answer2) {
                return answer1.isAccepted ? -1 : answer2.score - answer1.score;
              });
              return ListView(
                children: <Widget>[
                  _QuestionCard(this.widget._question),
                  if (answers.isEmpty)
                    Center(child: Text('There are no answers yet')),
                  // NOTE: This feature is only available in Dart 2.3; SDK version is required 2.2.2
                  ...answers.map((Answer answer) {
                    return _AnswerCard(answer);
                  }),
                ],
              );
            default:
              return ListView(
                children: <Widget>[
                  LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orangeAccent,
                    ),
                  ),
                  _QuestionCard(this.widget._question),
                ],
              );
          }
        },
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question _question;

  const _QuestionCard(this._question, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: Container(
                  child: Text(
                    '${_question.score}',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${_question.title}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Wrap(
                      children: Tag.fromTags(_question.tags),
                    ),
                    Text(
                      'Opened ${formatDate(_question.creationDate)} by ${_question.owner.displayName}',
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.black,
            height: 10.0,
          ),
          MarkdownBody(data: _question.bodyMarkdown),
          Divider(
            color: Colors.black,
            height: 10.0,
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final Answer _answer;

  final Color _headingColor;

  _AnswerCard(this._answer, {Key key})
      : _headingColor = _answer.isAccepted ? Colors.white : Colors.black,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              color: _answer.isAccepted ? Colors.green[800] : Colors.grey[200],
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Container(
                      child: Text(
                        '${_answer.score}',
                        style: TextStyle(
                          fontSize: 25,
                          color: _headingColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Text(
                      'Answered ${formatDate(_answer.creationDate)} by ${_answer.owner.displayName}',
                      style: TextStyle(color: _headingColor),
                    ),
                  ),
                  if (_answer.isAccepted)
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    )
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              height: 0,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: MarkdownBody(
                data: _answer.bodyMarkdown,
              ),
            )
          ],
        ),
      ),
    );
  }
}
