import 'package:flutter/material.dart';
import 'package:flutter_overflow/pages/homepage.dart';
import 'package:flutter_overflow/service/theme_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(FlutterOverflowApp());

class FlutterOverflowApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, widget) {
          return MaterialApp(
            title: 'FlutterOverflow',
            theme: themeProvider.themeData,
            home: Homepage(),
          );
        },
      ),
    );
  }
}
