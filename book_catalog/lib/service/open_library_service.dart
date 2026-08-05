import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/book.dart';

class OpenLibraryException implements Exception {
  OpenLibraryException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'Open Library request failed with status $statusCode.';
}

/// Searches books through the public Open Library API, which needs no key.
class OpenLibraryService {
  OpenLibraryService({http.Client? client}) : _client = client ?? http.Client();

  static const _host = 'openlibrary.org';
  static const _fields =
      'key,title,author_name,first_publish_year,cover_i,edition_count,subject';

  final http.Client _client;

  Future<List<Book>> search(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) {
      return <Book>[];
    }
    final uri = Uri.https(_host, '/search.json', {
      'q': query,
      'limit': '$limit',
      'fields': _fields,
    });
    final decoded = await _getJson(uri) as Map<String, dynamic>;
    final docs = (decoded['docs'] as List<dynamic>).cast<Map<String, dynamic>>();
    return docs.map(Book.fromJson).toList();
  }

  /// The work description, which Open Library returns either as a plain
  /// string, as a map with a value field, or not at all.
  Future<String?> description(String workKey) async {
    final decoded = await _getJson(Uri.https(_host, '$workKey.json'))
        as Map<String, dynamic>;
    final description = decoded['description'];
    if (description is String) {
      return description;
    }
    if (description is Map<String, dynamic>) {
      return description['value'] as String?;
    }
    return null;
  }

  Future<dynamic> _getJson(Uri uri) async {
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw OpenLibraryException(response.statusCode);
    }
    return jsonDecode(response.body);
  }
}
