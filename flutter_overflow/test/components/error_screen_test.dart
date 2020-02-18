import 'package:flutter/material.dart';
import 'package:flutter_overflow/components/error_screen.dart';
import 'package:flutter_overflow/data/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorScreen', () {
    testWidgets('display correct values', (WidgetTester tester) async {
      final error = APIError(500, 'some description', 'some name');

      await tester.pumpWidget(MaterialApp(home: ErrorScreen(error)));

      expect(find.text('code: 500'), findsOneWidget);
      expect(find.text('name: some name'), findsOneWidget);
      expect(find.text('message: some description'), findsOneWidget);
    });
  });
}
