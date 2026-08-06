import 'package:flutter_test/flutter_test.dart';

import 'package:helloflutter/main.dart';

void main() {
  testWidgets('shows the title and the platform buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Testing'), findsOneWidget);
    expect(find.text('Android'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
  });
}
