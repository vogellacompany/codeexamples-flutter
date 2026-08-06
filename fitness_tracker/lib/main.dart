import 'package:flutter/material.dart';

import 'page/home_page.dart';
import 'repository/workout_repository.dart';

void main() => runApp(FitnessTrackerApp(repository: WorkoutRepository()));

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key, required this.repository});

  final WorkoutRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness tracker',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: HomePage(repository: repository),
    );
  }
}
