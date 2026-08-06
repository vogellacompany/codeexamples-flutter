import 'dart:async';

import 'package:flutter/material.dart';

import '../model/book.dart';
import '../service/open_library_service.dart';
import '../widget/book_cover.dart';
import 'book_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.service, this.initialQuery});

  final OpenLibraryService service;

  /// Query to run as soon as the page opens.
  final String? initialQuery;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _debounce = Duration(milliseconds: 400);

  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  Future<List<Book>>? _results;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialQuery;
    if (initial != null && initial.isNotEmpty) {
      _controller.text = initial;
      _results = widget.service.search(initial);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Waits for a pause in typing so one request is sent per search, not one
  /// per keystroke.
  void _onQueryChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => _search(query));
  }

  void _search(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _results = null;
      });
      return;
    }
    // Start the request first: setState must not return a Future.
    final results = widget.service.search(query);
    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book catalog'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _controller,
              onChanged: _onQueryChanged,
              onSubmitted: _search,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search for a title or an author',
                prefixIcon: Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final results = _results;
    if (results == null) {
      return const Center(child: Text('Search for a book to get started.'));
    }

    return FutureBuilder<List<Book>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final books = snapshot.data;
        if (books == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (books.isEmpty) {
          return const Center(child: Text('No book matched that search.'));
        }
        return ListView.separated(
          itemCount: books.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) => _BookTile(
            book: books[index],
            service: widget.service,
          ),
        );
      },
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({required this.book, required this.service});

  final Book book;
  final OpenLibraryService service;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: BookCover(book: book),
      title: Text(book.title),
      subtitle: Text(
        book.firstPublishYear == null
            ? book.authorText
            : '${book.authorText}, ${book.firstPublishYear}',
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => BookPage(book: book, service: service),
        ),
      ),
    );
  }
}
