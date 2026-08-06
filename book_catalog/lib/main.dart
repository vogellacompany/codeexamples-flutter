import 'package:flutter/material.dart';

import 'page/search_page.dart';
import 'service/open_library_service.dart';

void main() => runApp(const BookCatalogApp());

class BookCatalogApp extends StatelessWidget {
  const BookCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book catalog',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: SearchPage(service: OpenLibraryService()),
    );
  }
}
