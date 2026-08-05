/// A work returned by the Open Library search API.
class Book {
  Book({
    required this.key,
    required this.title,
    this.authors = const <String>[],
    this.firstPublishYear,
    this.coverId,
    this.editionCount = 0,
    this.subjects = const <String>[],
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      key: json['key'] as String,
      title: json['title'] as String,
      // Most fields are optional, a work may have no known author or cover.
      authors: (json['author_name'] as List<dynamic>?)?.cast<String>() ??
          const <String>[],
      firstPublishYear: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
      editionCount: json['edition_count'] as int? ?? 0,
      subjects:
          (json['subject'] as List<dynamic>?)?.cast<String>() ?? const <String>[],
    );
  }

  final String key;
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final int? coverId;
  final int editionCount;
  final List<String> subjects;

  String get authorText =>
      authors.isEmpty ? 'Unknown author' : authors.join(', ');

  String get editionText =>
      editionCount == 1 ? '1 edition' : '$editionCount editions';

  /// Cover image, or null when Open Library has no cover for this work.
  Uri? coverUri({String size = 'M'}) {
    final id = coverId;
    return id == null
        ? null
        : Uri.https('covers.openlibrary.org', '/b/id/$id-$size.jpg');
  }
}
