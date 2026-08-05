import 'package:flutter/material.dart';

import '../model/book.dart';
import '../service/open_library_service.dart';
import '../widget/book_cover.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key, required this.book, required this.service});

  final Book book;
  final OpenLibraryService service;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late Future<String?> _description;

  @override
  void initState() {
    super.initState();
    _description = widget.service.description(widget.book.key);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(book.title, maxLines: 1)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Center(
            child: BookCover(book: book, width: 180, size: 'L'),
          ),
          const SizedBox(height: 16),
          Text(book.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(book.authorText, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (book.firstPublishYear != null)
                Chip(label: Text('First published ${book.firstPublishYear}')),
              if (book.editionCount > 0)
                Chip(label: Text(book.editionText)),
            ],
          ),
          const Divider(height: 32),
          FutureBuilder<String?>(
            future: _description,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final description = snapshot.data;
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              if (description == null || description.isEmpty) {
                return Text(
                  'This work has no description yet.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                );
              }
              return Text(description, style: theme.textTheme.bodyMedium);
            },
          ),
          if (book.subjects.isNotEmpty) ...<Widget>[
            const Divider(height: 32),
            Text('Subjects', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: book.subjects
                  .take(12)
                  .map((subject) => Chip(label: Text(subject)))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
