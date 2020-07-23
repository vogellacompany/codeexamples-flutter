import 'package:flutter/material.dart';
import 'package:flutter_overflow/pages/stack_login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('stack login layout', (WidgetTester tester) async {
    //must use material app here to wrap the widget
    await tester.pumpWidget(MaterialApp(
        home: StackLoginWebViewPage(
      clientId: 'test_id',
      clientSecret: 'test_secret',
      scope: ['test_scope'],
      redirectUrl: 'test_url',
    )));
    expect(find.text('Log in with Stack Overflow'), findsOneWidget);
  });
}
