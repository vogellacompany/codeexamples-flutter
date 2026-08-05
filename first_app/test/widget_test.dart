import 'package:flutter_test/flutter_test.dart';

import 'package:first_app/main.dart';

void main() {
  testWidgets('shows the greeting', (WidgetTester tester) async {
    await tester.pumpWidget(MyApplication());

    expect(find.text('Hello'), findsOneWidget);
  });
}
