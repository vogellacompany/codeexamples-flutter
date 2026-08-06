import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/workout.dart';

/// Stores the workouts as a JSON list in the shared preferences.
class WorkoutRepository {
  WorkoutRepository({SharedPreferences? preferences})
      : _preferences = preferences;

  static const _key = 'workouts';

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async =>
      _preferences ??= await SharedPreferences.getInstance();

  Future<List<Workout>> load() async {
    final stored = (await _prefs).getString(_key);
    if (stored == null || stored.isEmpty) {
      return <Workout>[];
    }
    final decoded = jsonDecode(stored) as List<dynamic>;
    final workouts = decoded
        .cast<Map<String, dynamic>>()
        .map(Workout.fromJson)
        .toList();
    // Newest first, which is the order the list page shows them in.
    workouts.sort((a, b) => b.date.compareTo(a.date));
    return workouts;
  }

  Future<void> save(List<Workout> workouts) async {
    final encoded =
        jsonEncode(workouts.map((workout) => workout.toJson()).toList());
    await (await _prefs).setString(_key, encoded);
  }
}
