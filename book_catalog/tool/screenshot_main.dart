// Entry point used to capture the book figures. Build it with
// `flutter build linux -t tool/screenshot_main.dart --dart-define=SCREEN=detail`.
import 'package:flutter/material.dart';

import 'package:book_catalog/model/book.dart';
import 'package:book_catalog/page/book_page.dart';
import 'package:book_catalog/page/search_page.dart';
import 'package:book_catalog/service/open_library_service.dart';

const screen = String.fromEnvironment('SCREEN', defaultValue: 'search');
const query = String.fromEnvironment('QUERY', defaultValue: 'flutter dart');

void main() => runApp(const ScreenshotApp());

class ScreenshotApp extends StatelessWidget {
  const ScreenshotApp({super.key});

  @override
  Widget build(BuildContext context) {
    final service = OpenLibraryService();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: screen == 'detail'
          ? _FirstResult(service: service)
          : SearchPage(service: service, initialQuery: query),
    );
  }
}

/// Opens the detail page of the first search result that has a cover.
class _FirstResult extends StatefulWidget {
  const _FirstResult({required this.service});

  final OpenLibraryService service;

  @override
  State<_FirstResult> createState() => _FirstResultState();
}

class _FirstResultState extends State<_FirstResult> {
  late final Future<List<Book>> _books = widget.service.search(query);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _books,
      builder: (context, snapshot) {
        final books = snapshot.data;
        if (books == null || books.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final book = books.firstWhere(
          (candidate) => candidate.coverId != null,
          orElse: () => books.first,
        );
        return BookPage(book: book, service: widget.service);
      },
    );
  }
}
