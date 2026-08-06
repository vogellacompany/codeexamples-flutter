import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:web_app_prototype/main.dart';

void main() {
  testWidgets('shows the login form', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Login'), findsWidgets);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
