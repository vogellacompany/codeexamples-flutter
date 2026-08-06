// Entry point used to capture the book figures, with a seeded week of
// workouts so the chart and the summary are not empty.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_tracker/main.dart';
import 'package:fitness_tracker/model/workout.dart';
import 'package:fitness_tracker/page/workout_form_page.dart';
import 'package:fitness_tracker/repository/workout_repository.dart';

const screen = String.fromEnvironment('SCREEN', defaultValue: 'home');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  final repository = WorkoutRepository();
  final today = DateTime.now();
  await repository.save(<Workout>[
    _workout(today, WorkoutType.running, 42, 7.5),
    _workout(today.subtract(const Duration(days: 1)), WorkoutType.strength, 55, null),
    _workout(today.subtract(const Duration(days: 2)), WorkoutType.cycling, 78, 31.2),
    _workout(today.subtract(const Duration(days: 4)), WorkoutType.swimming, 35, 1.4),
    _workout(today.subtract(const Duration(days: 5)), WorkoutType.running, 28, 5.1),
  ]);

  runApp(
    screen == 'form'
        ? const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: WorkoutFormPage(),
          )
        : FitnessTrackerApp(repository: repository),
  );
}

Workout _workout(DateTime date, WorkoutType type, int minutes, double? km) {
  return Workout(
    id: '${type.name}-${date.microsecondsSinceEpoch}',
    type: type,
    date: date,
    duration: Duration(minutes: minutes),
    distanceKm: km,
  );
}
