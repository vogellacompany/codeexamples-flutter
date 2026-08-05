import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:web_monitor/main.dart';
import 'package:web_monitor/my_main_page.dart';

void main() {
  testWidgets('starts on the main page', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(MyMainPage), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
