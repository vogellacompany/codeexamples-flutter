import 'package:flutter_test/flutter_test.dart';

import 'package:clock_example/clock_face.dart';
import 'package:clock_example/main.dart';

void main() {
  testWidgets('renders the clock face', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(ClockFrame), findsOneWidget);
    expect(find.byType(ClockFace), findsOneWidget);
  });
}
