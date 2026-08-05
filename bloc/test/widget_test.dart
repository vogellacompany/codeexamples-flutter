import 'package:flutter_test/flutter_test.dart';

import 'package:bloc/main.dart';

void main() {
  testWidgets('shows the catalog and counts items added to the cart',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Sweater'), findsOneWidget);
    expect(find.text('Socks'), findsOneWidget);

    // The badge on the cart button starts at zero.
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Sweater'));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
