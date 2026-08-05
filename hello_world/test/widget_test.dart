import 'package:flutter_test/flutter_test.dart';

import 'package:hello_world/main.dart';

void main() {
  testWidgets('shows the home page content', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Show'), findsOneWidget);
  });
}
