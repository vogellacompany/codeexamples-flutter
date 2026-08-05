import 'package:flutter/material.dart';

import '../model/book.dart';

/// Shows the cover of a book, falling back to a placeholder when the work has
/// no cover or the image cannot be loaded.
class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.book,
    this.width = 48,
    this.size = 'M',
  });

  final Book book;
  final double width;
  final String size;

  @override
  Widget build(BuildContext context) {
    final uri = book.coverUri(size: size);
    final placeholder = SizedBox(
      width: width,
      height: width * 1.5,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Icon(Icons.menu_book),
      ),
    );

    if (uri == null) {
      return placeholder;
    }
    return Image.network(
      uri.toString(),
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}
