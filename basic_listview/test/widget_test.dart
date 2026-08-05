import 'package:flutter_test/flutter_test.dart';

import 'package:basic_listview/main.dart';

void main() {
  testWidgets('shows the greeting and the dialog button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Show dialog'), findsOneWidget);
  });
}
