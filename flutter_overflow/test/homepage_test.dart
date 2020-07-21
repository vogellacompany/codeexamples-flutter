import 'package:flutter/material.dart';
import 'package:flutter_overflow/main.dart';
import 'package:flutter_overflow/service/theme_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_overflow/pages/homepage.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('homepage layout test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
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
      ),
    );

    final findLogin = find.text('Login');
    final findStack = find.text('StackOverflow');

    expect(findLogin, findsOneWidget);
    expect(findStack, findsOneWidget);
  });
}
