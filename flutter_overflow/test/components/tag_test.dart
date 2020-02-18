import 'package:flutter/material.dart';
import 'package:flutter_overflow/components/tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('Tag', () {
    testWidgets('displays correct text', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Tag("some-random-tag")));

      expect(find.text('some-random-tag'), findsOneWidget);
    });
    testWidgets('callback is called on tap', (WidgetTester tester) async {
      var onDeleteMock = OnDeleteMock();
      await tester.pumpWidget(
        MaterialApp(
          home: Tag(
            "some-random-tag",
            onDelete: onDeleteMock,
          ),
        ),
      );

      await tester.tap(find.text('some-random-tag'));
      await tester.pump();

      verify(onDeleteMock.call("some-random-tag")).called(1);
    });
  });
}

class OnDeleteMock extends Mock {
  void call(String text);
}
