import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_overflow/data/tocken.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:http/http.dart' as http;

class StackLoginWebViewPage extends StatefulWidget {
  const StackLoginWebViewPage({
    this.clientId,
    this.clientSecret,
    this.redirectUrl,
    this.scope,
  });

  final String clientId;
  final String clientSecret;
  final String redirectUrl;
  final List scope;

  @override
  _StackLoginWebViewPageState createState() =>
      new _StackLoginWebViewPageState();
}

class _StackLoginWebViewPageState extends State<StackLoginWebViewPage> {
  bool setupUrlChangedListener = false;

  @override
  Widget build(BuildContext context) {
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    final String clientId = widget.clientId;
    final String redirectUrl = widget.redirectUrl;
    final String scope = widget.scope.join(',');

    if (!setupUrlChangedListener) {
      flutterWebviewPlugin.onUrlChanged.listen((String changedUrl) async {
        if (changedUrl.startsWith(widget.redirectUrl)) {
          Uri uri = new Uri().resolve(changedUrl);
          String code = uri.queryParameters["code"];
          final http.Response response =
              await http.post("https://stackoverflow.com/oauth/access_tocken", body: {
            "client_id": widget.clientId,
            "redirect_uri": widget.redirectUrl,
            "client_secret": widget.clientSecret,
            "code": code,
          });

          Token token = new Token.fromMap(json.decode(response.body));
          await Token.storeAccessToken(token.accessToken);
          Navigator.of(context).pop(true);
        }
      });
      setupUrlChangedListener = true;
    }


    return new WebviewScaffold(
      appBar: new AppBar(
        title: new Text("Log in with Stack Overflow"),
      ),
      url:
        "https://stackoverflow.com/oauth?client_id=18040&redirect_uri=https://www.vogella.com",
    );
  }
}