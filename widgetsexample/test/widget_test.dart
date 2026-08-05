import 'package:flutter_test/flutter_test.dart';

import 'package:widgetsexample/main.dart';

void main() {
  testWidgets('renders the separated list', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Lars'), findsWidgets);
  });
}
