import 'package:flutter/foundation.dart';

enum WorkoutType {
  running('Running'),
  cycling('Cycling'),
  swimming('Swimming'),
  strength('Strength');

  const WorkoutType(this.label);

  final String label;

  static WorkoutType fromName(String name) {
    return WorkoutType.values.firstWhere(
      (type) => type.name == name,
      orElse: () => WorkoutType.running,
    );
  }
}

@immutable
class Workout {
  const Workout({
    required this.id,
    required this.type,
    required this.date,
    required this.duration,
    this.distanceKm,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      type: WorkoutType.fromName(json['type'] as String),
      date: DateTime.parse(json['date'] as String),
      duration: Duration(minutes: json['minutes'] as int),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );
  }

  final String id;
  final WorkoutType type;
  final DateTime date;
  final Duration duration;

  /// Distance in kilometers, absent for workouts that do not cover ground.
  final double? distanceKm;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type.name,
        'date': date.toIso8601String(),
        'minutes': duration.inMinutes,
        if (distanceKm != null) 'distanceKm': distanceKm,
      };

  Workout copyWith({
    WorkoutType? type,
    DateTime? date,
    Duration? duration,
    double? distanceKm,
  }) {
    return Workout(
      id: id,
      type: type ?? this.type,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Workout &&
      other.id == id &&
      other.type == type &&
      other.date == date &&
      other.duration == duration &&
      other.distanceKm == distanceKm;

  @override
  int get hashCode => Object.hash(id, type, date, duration, distanceKm);
}
