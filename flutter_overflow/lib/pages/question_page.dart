import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_overflow/components/error_screen.dart';
import 'package:flutter_overflow/components/tag.dart';
import 'package:flutter_overflow/data/models.dart';
import 'package:flutter_overflow/service/question_service.dart';
import 'package:flutter_overflow/util.dart';
import 'package:provider/provider.dart';

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
    super.initState();
    _answers = fetchAnswers(widget._question.questionId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeService, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget._question.title}'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.lightbulb_outline),
                onPressed: () {
                  themeService.toggle();
                },
              ),
            ],
          ),
          body: FutureBuilder(
            future: _answers,
            builder:
                (BuildContext context, AsyncSnapshot<List<Answer>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return ErrorScreen(snapshot.error);
                  }
                  var answers = snapshot.data;
                  // The accepted answer should be on top, after that it should be sorted by score (desc)
                  answers.sort((answer1, answer2) {
                    return answer1.isAccepted
                        ? -1
                        : answer2.score - answer1.score;
                  });
                  return ListView(
                    children: <Widget>[
                      _QuestionPart(this.widget._question),
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
                          Theme.of(context).accentColor,
                        ),
                      ),
                      _QuestionPart(this.widget._question),
                    ],
                  );
              }
            },
          ),
        );
      },
    );
  }
}

class _QuestionPart extends StatelessWidget {
  final Question _question;

  _QuestionPart(this._question, {Key key}) : super(key: key);

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
                    Text('${_question.title}', style: TextStyle(fontSize: 20)),
                    Wrap(children: Tag.fromTags(_question.tags)),
                    Text(
                      'Opened ${formatDate(_question.creationDate)} by ${_question.owner.displayName}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            height: 10.0,
          ),
          MarkdownBody(data: _question.bodyMarkdown),
          Divider(
            color: Theme.of(context).dividerColor,
            height: 10.0,
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final Answer _answer;

  _AnswerCard(this._answer, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _headingColor = _answer.isAccepted
        ? Colors.white
        : Theme.of(context).textTheme.body1.color;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              color: _answer.isAccepted
                  ? Colors.green
                  : Theme.of(context).backgroundColor,
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
