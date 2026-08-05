import 'workout.dart';

/// Aggregates workouts into the seven days ending today.
class WeeklySummary {
  WeeklySummary(List<Workout> workouts, {DateTime? today})
      : _days = _buildDays(workouts, today ?? DateTime.now());

  final List<DaySummary> _days;

  List<DaySummary> get days => List<DaySummary>.unmodifiable(_days);

  Duration get totalDuration => _days.fold(
        Duration.zero,
        (total, day) => total + day.duration,
      );

  double get totalDistanceKm =>
      _days.fold(0.0, (total, day) => total + day.distanceKm);

  int get workoutCount => _days.fold(0, (total, day) => total + day.count);

  static List<DaySummary> _buildDays(List<Workout> workouts, DateTime today) {
    final start = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 6));

    return List<DaySummary>.generate(7, (index) {
      final day = start.add(Duration(days: index));
      final onThatDay = workouts.where(
        (workout) =>
            workout.date.year == day.year &&
            workout.date.month == day.month &&
            workout.date.day == day.day,
      );
      return DaySummary(
        date: day,
        duration: onThatDay.fold(
          Duration.zero,
          (total, workout) => total + workout.duration,
        ),
        distanceKm: onThatDay.fold(
          0.0,
          (total, workout) => total + (workout.distanceKm ?? 0),
        ),
        count: onThatDay.length,
      );
    });
  }
}

class DaySummary {
  const DaySummary({
    required this.date,
    required this.duration,
    required this.distanceKm,
    required this.count,
  });

  final DateTime date;
  final Duration duration;
  final double distanceKm;
  final int count;
}
