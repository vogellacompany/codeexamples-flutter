import 'package:flutter/foundation.dart';

enum Repeat {
  never('Never'),
  daily('Every day'),
  weekly('Every week');

  const Repeat(this.label);

  final String label;

  static Repeat fromName(String name) => Repeat.values.firstWhere(
        (repeat) => repeat.name == name,
        orElse: () => Repeat.never,
      );
}

@immutable
class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    required this.dueAt,
    this.notes = '',
    this.repeat = Repeat.never,
    this.done = false,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      title: json['title'] as String,
      dueAt: DateTime.parse(json['dueAt'] as String),
      notes: json['notes'] as String? ?? '',
      repeat: Repeat.fromName(json['repeat'] as String? ?? 'never'),
      done: json['done'] as bool? ?? false,
    );
  }

  final String id;
  final String title;
  final DateTime dueAt;
  final String notes;
  final Repeat repeat;
  final bool done;

  bool isOverdue(DateTime now) => !done && dueAt.isBefore(now);

  bool isDueOn(DateTime day) =>
      dueAt.year == day.year &&
      dueAt.month == day.month &&
      dueAt.day == day.day;

  /// The next occurrence after [from], or null for a one-off reminder.
  DateTime? nextOccurrence(DateTime from) {
    switch (repeat) {
      case Repeat.never:
        return null;
      case Repeat.daily:
      case Repeat.weekly:
        final step = repeat == Repeat.daily
            ? const Duration(days: 1)
            : const Duration(days: 7);
        var next = dueAt;
        while (!next.isAfter(from)) {
          next = next.add(step);
        }
        return next;
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'dueAt': dueAt.toIso8601String(),
        'notes': notes,
        'repeat': repeat.name,
        'done': done,
      };

  Reminder copyWith({
    String? title,
    DateTime? dueAt,
    String? notes,
    Repeat? repeat,
    bool? done,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      notes: notes ?? this.notes,
      repeat: repeat ?? this.repeat,
      done: done ?? this.done,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Reminder &&
      other.id == id &&
      other.title == title &&
      other.dueAt == dueAt &&
      other.notes == notes &&
      other.repeat == repeat &&
      other.done == done;

  @override
  int get hashCode => Object.hash(id, title, dueAt, notes, repeat, done);
}
