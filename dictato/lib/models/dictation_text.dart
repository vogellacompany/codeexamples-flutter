import 'package:json_annotation/json_annotation.dart';

part 'dictation_text.g.dart';

@JsonSerializable()
class DictationText {
  final String id;
  final String title;
  final String content;
  final String language; // 'en' or 'de'
  final String? userId; // null means available to all users
  final DateTime createdAt;
  final List<String> segments; // Pre-segmented text parts for dictation

  DictationText({
    required this.id,
    required this.title,
    required this.content,
    required this.language,
    this.userId,
    required this.createdAt,
    required this.segments,
  });

  factory DictationText.fromJson(Map<String, dynamic> json) =>
      _$DictationTextFromJson(json);

  Map<String, dynamic> toJson() => _$DictationTextToJson(this);

  /// Creates a new DictationText with segments automatically generated
  /// by splitting the content into meaningful chunks
  factory DictationText.create({
    required String id,
    required String title,
    required String content,
    required String language,
    String? userId,
  }) {
    final segments = _segmentText(content);
    return DictationText(
      id: id,
      title: title,
      content: content,
      language: language,
      userId: userId,
      createdAt: DateTime.now(),
      segments: segments,
    );
  }

  /// Segments text into meaningful chunks for dictation
  /// Splits on sentence boundaries and keeps chunks reasonably short
  static List<String> _segmentText(String text) {
    // Simple segmentation - split by sentences but keep reasonable length
    final sentences = text.split(RegExp(r'[.!?]+\s*'));
    final segments = <String>[];
    
    for (final sentence in sentences) {
      final trimmedSentence = sentence.trim();
      if (trimmedSentence.isEmpty) continue;
      
      // If sentence is very long, split it further
      if (trimmedSentence.length > 120) {
        // Split on commas or conjunctions
        final parts = trimmedSentence.split(RegExp(r',\s*|and\s+|or\s+|but\s+'));
        String currentSegment = '';
        
        for (final part in parts) {
          final trimmedPart = part.trim();
          if (trimmedPart.isEmpty) continue;
          
          if (currentSegment.isNotEmpty && 
              (currentSegment.length + trimmedPart.length) > 80) {
            segments.add(currentSegment.trim());
            currentSegment = trimmedPart;
          } else {
            if (currentSegment.isNotEmpty) {
              currentSegment += ', $trimmedPart';
            } else {
              currentSegment = trimmedPart;
            }
          }
        }
        
        if (currentSegment.isNotEmpty) {
          segments.add(currentSegment.trim());
        }
      } else {
        // Add sentence as is (or reconstruct with period)
        final segmentText = trimmedSentence.endsWith('.') || 
                           trimmedSentence.endsWith('!') || 
                           trimmedSentence.endsWith('?')
            ? trimmedSentence 
            : '$trimmedSentence.';
        segments.add(segmentText);
      }
    }

    return segments.isEmpty ? [text] : segments;
  }

  DictationText copyWith({
    String? id,
    String? title,
    String? content,
    String? language,
    String? userId,
    DateTime? createdAt,
    List<String>? segments,
  }) {
    return DictationText(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      language: language ?? this.language,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      segments: segments ?? this.segments,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DictationText &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DictationText{id: $id, title: $title, language: $language, segments: ${segments.length}}';
  }
}