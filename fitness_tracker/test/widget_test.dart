import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_tracker/main.dart';
import 'package:fitness_tracker/model/weekly_summary.dart';
import 'package:fitness_tracker/model/workout.dart';
import 'package:fitness_tracker/page/workout_form_page.dart';
import 'package:fitness_tracker/repository/workout_repository.dart';

Workout workoutOn(DateTime date, {int minutes = 30, double? km}) {
  return Workout(
    id: '${date.microsecondsSinceEpoch}',
    type: WorkoutType.running,
    date: date,
    duration: Duration(minutes: minutes),
    distanceKm: km,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Workout', () {
    test('survives a JSON round trip', () {
      final workout = Workout(
        id: 'a1',
        type: WorkoutType.cycling,
        date: DateTime(2026, 8, 5, 7, 30),
        duration: const Duration(minutes: 45),
        distanceKm: 18.5,
      );

      expect(Workout.fromJson(workout.toJson()), workout);
    });

    test('omits an absent distance', () {
      final workout = workoutOn(DateTime(2026, 8, 5));

      expect(workout.toJson().containsKey('distanceKm'), isFalse);
      expect(Workout.fromJson(workout.toJson()).distanceKm, isNull);
    });

    test('falls back to a known type for an unknown name', () {
      expect(WorkoutType.fromName('paragliding'), WorkoutType.running);
    });
  });

  group('WeeklySummary', () {
    final today = DateTime(2026, 8, 5);

    test('covers the seven days ending today', () {
      final summary = WeeklySummary(<Workout>[], today: today);

      expect(summary.days, hasLength(7));
      expect(summary.days.first.date, DateTime(2026, 7, 30));
      expect(summary.days.last.date, today);
    });

    test('adds up the workouts of each day', () {
      final summary = WeeklySummary(
        <Workout>[
          workoutOn(DateTime(2026, 8, 5, 8), minutes: 30, km: 5),
          workoutOn(DateTime(2026, 8, 5, 18), minutes: 20, km: 3),
          workoutOn(DateTime(2026, 8, 1), minutes: 60, km: 12),
        ],
        today: today,
      );

      expect(summary.workoutCount, 3);
      expect(summary.totalDuration, const Duration(minutes: 110));
      expect(summary.totalDistanceKm, closeTo(20.0, 0.001));
      expect(summary.days.last.duration, const Duration(minutes: 50));
    });

    test('ignores workouts older than the window', () {
      final summary = WeeklySummary(
        <Workout>[workoutOn(DateTime(2026, 7, 1), minutes: 90)],
        today: today,
      );

      expect(summary.workoutCount, 0);
      expect(summary.totalDuration, Duration.zero);
    });
  });

  group('WorkoutRepository', () {
    test('returns an empty list when nothing was stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});

      expect(await WorkoutRepository().load(), isEmpty);
    });

    test('stores and reads back workouts, newest first', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final repository = WorkoutRepository();
      final older = workoutOn(DateTime(2026, 8, 1));
      final newer = workoutOn(DateTime(2026, 8, 4));

      await repository.save(<Workout>[older, newer]);
      final loaded = await repository.load();

      expect(loaded.map((w) => w.id), <String>[newer.id, older.id]);
    });
  });

  group('WorkoutFormPage', () {
    testWidgets('rejects a missing duration', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WorkoutFormPage()));

      await tester.tap(find.text('Save workout'));
      await tester.pump();

      expect(find.text('Enter the duration in whole minutes'), findsOneWidget);
    });

    testWidgets('rejects a negative distance', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WorkoutFormPage()));

      await tester.enterText(find.widgetWithText(TextFormField, 'Duration'), '30');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Distance (optional)'),
        '-2',
      );
      await tester.tap(find.text('Save workout'));
      await tester.pump();

      expect(
        find.text('Enter a distance greater than zero, or leave empty'),
        findsOneWidget,
      );
    });
  });

  testWidgets('shows the empty state when nothing is stored',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(FitnessTrackerApp(repository: WorkoutRepository()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Add your first workout'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('lists a stored workout and its weekly total',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final repository = WorkoutRepository();
    await repository.save(<Workout>[workoutOn(DateTime.now(), minutes: 40, km: 8)]);

    await tester.pumpWidget(FitnessTrackerApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Running'), findsOneWidget);
    expect(find.textContaining('40 min'), findsOneWidget);
    // One workout, 40 minutes and 8 kilometers in the summary card.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0.7'), findsOneWidget);
    expect(find.text('8.0'), findsOneWidget);
  });
}
