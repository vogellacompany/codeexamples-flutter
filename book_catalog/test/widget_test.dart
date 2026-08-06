import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:book_catalog/model/book.dart';
import 'package:book_catalog/page/search_page.dart';
import 'package:book_catalog/service/open_library_service.dart';

const _searchJson = '''
{
  "numFound": 2,
  "docs": [
    {
      "key": "/works/OL1W",
      "title": "Flutter for Beginners",
      "author_name": ["Alessandro Biessek"],
      "first_publish_year": 2019,
      "cover_i": 13730334,
      "edition_count": 5,
      "subject": ["Mobile computing"]
    },
    {
      "key": "/works/OL2W",
      "title": "A Work Without Metadata"
    }
  ]
}
''';

OpenLibraryService serviceReturning(String body, {int status = 200}) {
  return OpenLibraryService(
    client: MockClient((request) async => http.Response(body, status)),
  );
}

void main() {
  group('Book', () {
    test('reads a fully populated document', () {
      final book = Book.fromJson({
        'key': '/works/OL1W',
        'title': 'Flutter for Beginners',
        'author_name': <dynamic>['Alessandro Biessek'],
        'first_publish_year': 2019,
        'cover_i': 13730334,
        'edition_count': 5,
        'subject': <dynamic>['Mobile computing'],
      });

      expect(book.authorText, 'Alessandro Biessek');
      expect(book.firstPublishYear, 2019);
      expect(book.coverUri()?.host, 'covers.openlibrary.org');
      expect(book.coverUri()?.path, '/b/id/13730334-M.jpg');
      expect(book.editionText, '5 editions');
    });

    test('tolerates a document with only the required fields', () {
      final book = Book.fromJson({'key': '/works/OL2W', 'title': 'Bare'});

      expect(book.authors, isEmpty);
      expect(book.authorText, 'Unknown author');
      expect(book.firstPublishYear, isNull);
      expect(book.coverUri(), isNull);
      expect(book.editionCount, 0);
      expect(book.editionText, '0 editions');
      expect(book.subjects, isEmpty);
    });
  });

  test('uses the singular for a single edition', () {
    final book = Book.fromJson(
      {'key': '/works/OL3W', 'title': 'Only one', 'edition_count': 1},
    );

    expect(book.editionText, '1 edition');
  });

  group('OpenLibraryService', () {
    test('parses search results', () async {
      final books = await serviceReturning(_searchJson).search('flutter');

      expect(books, hasLength(2));
      expect(books.first.title, 'Flutter for Beginners');
      expect(books.last.authorText, 'Unknown author');
    });

    test('does not call the API for an empty query', () async {
      final service = OpenLibraryService(
        client: MockClient((request) async => fail('should not be called')),
      );

      expect(await service.search('   '), isEmpty);
    });

    test('reports a failed request', () {
      expect(
        serviceReturning('{}', status: 500).search('flutter'),
        throwsA(isA<OpenLibraryException>()),
      );
    });

    test('reads a description given as a plain string', () async {
      final service = serviceReturning('{"description": "A good book"}');

      expect(await service.description('/works/OL1W'), 'A good book');
    });

    test('reads a description given as a map', () async {
      final service =
          serviceReturning('{"description": {"value": "Wrapped text"}}');

      expect(await service.description('/works/OL1W'), 'Wrapped text');
    });

    test('returns null when the work has no description', () async {
      final service = serviceReturning('{"title": "No description"}');

      expect(await service.description('/works/OL1W'), isNull);
    });
  });

  testWidgets('searches and lists the results', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SearchPage(service: serviceReturning(_searchJson))),
    );

    expect(find.text('Search for a book to get started.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Flutter for Beginners'), findsOneWidget);
    expect(find.text('A Work Without Metadata'), findsOneWidget);
  });
}
