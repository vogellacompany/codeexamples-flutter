import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overflow/components/error_screen.dart';
import 'package:flutter_overflow/components/tag.dart';
import 'package:flutter_overflow/data/models.dart';
import 'package:flutter_overflow/pages/question_page.dart';
import 'package:flutter_overflow/service/theme_provider.dart';
import 'package:flutter_overflow/util.dart';
import 'package:provider/provider.dart';

import 'package:flutter_overflow/service/question_service.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> _tags = [];

  Future<List<Question>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = fetchLatestQuestions(tags: _tags);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeService, widget) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.lightbulb_outline),
                onPressed: () {
                  themeService.toggle();
                },
              ),
              FlatButton.icon(
                label: Text('${_tags.length}'),
                icon: Icon(Icons.label),
                onPressed: () => _showTagsDialog(context),
              )
            ],
            title: Text('StackOverflow'),
          ),
          body: FutureBuilder(
            future: _questionsFuture,
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
                        _questionsFuture =
                            fetchLatestQuestions(tags: _tags, force: true);
                      });
                    },
                  );
                default:
                  return LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor),
                  );
              }
            },
          ),
        );
      },
    );
  }

  void _showTagsDialog(BuildContext context) async {
    List<String> newTags = await showDialog(
      context: context,
      builder: (context) {
        return _TagDialog(
          initialTags: _tags,
        );
      },
    );
    if (newTags == null) {
      // Dismiss through clicking outside of dialog
      return;
    }

    if (!listEquals(_tags, newTags)) {
      setState(() {
        _tags = newTags;
        _questionsFuture = fetchLatestQuestions(tags: _tags, force: true);
      });
    }
  }

  List<Widget> _buildQuestionTiles(List<Question> questions) {
    return questions.map((Question question) {
      return _QuestionTile(question);
    }).toList();
  }
}

class _TagDialog extends StatefulWidget {
  final List<String> initialTags;

  _TagDialog({@required this.initialTags});

  @override
  State<StatefulWidget> createState() {
    return _TagDialogState();
  }
}

class _TagDialogState extends State<_TagDialog> {
  final TextEditingController _textController = TextEditingController();

  Set<String> _tags = Set();

  @override
  void initState() {
    super.initState();
    this._tags = Set.from(widget.initialTags ?? []);
  }

  void _addCurrentTag() {
    final enteredText = _textController.text;
    if (enteredText.isEmpty) {
      return;
    }
    if (_tags.length > 5) {
      _textController.clear();
      return;
    }
    setState(() {
      _tags.add(enteredText);
    });
    Future.microtask(() => _textController.clear());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tags'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: Tag.fromTags(
              _tags.toList(),
              onDelete: (text) {
                setState(() {
                  _tags.remove(text);
                });
              },
            ),
          ),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Add tag',
              suffixIcon: FlatButton(
                child: Text('Add'),
                onPressed: _addCurrentTag,
              ),
            ),
            onSubmitted: (_) => _addCurrentTag(),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Clear'),
          onPressed: () => Navigator.pop(context, <String>[]),
        ),
        RaisedButton(
          child: Text('Search'),
          onPressed: () {
            _addCurrentTag();
            Navigator.pop(context, _tags.toList());
          },
        )
      ],
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final Question _question;

  const _QuestionTile(this._question, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child: ListTile(
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
      ),
    );
  }
}
