import 'package:json_annotation/json_annotation.dart';

part 'training_session.g.dart';

@JsonSerializable()
class TrainingSession {
  final String id;
  final String userId;
  final String textId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int currentSegmentIndex;
  final int totalSegments;
  final List<SegmentResult> segmentResults;

  TrainingSession({
    required this.id,
    required this.userId,
    required this.textId,
    required this.startedAt,
    this.completedAt,
    this.currentSegmentIndex = 0,
    required this.totalSegments,
    required this.segmentResults,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingSessionToJson(this);

  factory TrainingSession.create({
    required String id,
    required String userId,
    required String textId,
    required int totalSegments,
  }) {
    return TrainingSession(
      id: id,
      userId: userId,
      textId: textId,
      startedAt: DateTime.now(),
      totalSegments: totalSegments,
      segmentResults: [],
    );
  }

  bool get isCompleted => completedAt != null;

  int get totalErrors =>
      segmentResults.fold(0, (sum, result) => sum + result.errorCount);

  Duration? get duration => completedAt?.difference(startedAt);

  TrainingSession copyWith({
    String? id,
    String? userId,
    String? textId,
    DateTime? startedAt,
    DateTime? completedAt,
    int? currentSegmentIndex,
    int? totalSegments,
    List<SegmentResult>? segmentResults,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      textId: textId ?? this.textId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      currentSegmentIndex: currentSegmentIndex ?? this.currentSegmentIndex,
      totalSegments: totalSegments ?? this.totalSegments,
      segmentResults: segmentResults ?? this.segmentResults,
    );
  }

  TrainingSession complete() {
    return copyWith(completedAt: DateTime.now());
  }

  TrainingSession addSegmentResult(SegmentResult result) {
    final updatedResults = List<SegmentResult>.from(segmentResults)..add(result);
    return copyWith(
      segmentResults: updatedResults,
      currentSegmentIndex: currentSegmentIndex + 1,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingSession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TrainingSession{id: $id, userId: $userId, textId: $textId, completed: $isCompleted}';
  }
}

@JsonSerializable()
class SegmentResult {
  final int segmentIndex;
  final int errorCount;
  final DateTime completedAt;

  SegmentResult({
    required this.segmentIndex,
    required this.errorCount,
    required this.completedAt,
  });

  factory SegmentResult.fromJson(Map<String, dynamic> json) =>
      _$SegmentResultFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentResultToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SegmentResult &&
          runtimeType == other.runtimeType &&
          segmentIndex == other.segmentIndex;

  @override
  int get hashCode => segmentIndex.hashCode;

  @override
  String toString() {
    return 'SegmentResult{segmentIndex: $segmentIndex, errorCount: $errorCount}';
  }
}