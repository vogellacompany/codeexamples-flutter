import 'package:flutter_test/flutter_test.dart';

import 'package:flexible/main.dart';

void main() {
  testWidgets('shows the home page title', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Flutter Demo Home Page'), findsOneWidget);
  });
}
