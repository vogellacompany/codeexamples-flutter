import 'package:flutter_test/flutter_test.dart';

import 'package:batterylevel/main.dart';

void main() {
  testWidgets('shows the battery level button and its initial state',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Get Battery Level'), findsOneWidget);
    expect(find.text('Unknown battery level.'), findsOneWidget);
  });
}
