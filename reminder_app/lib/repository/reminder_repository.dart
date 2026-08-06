import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/reminder.dart';

/// Stores the reminders as a JSON list in the shared preferences.
class ReminderRepository {
  ReminderRepository({SharedPreferences? preferences})
      : _preferences = preferences;

  static const _key = 'reminders';

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async =>
      _preferences ??= await SharedPreferences.getInstance();

  Future<List<Reminder>> load() async {
    final stored = (await _prefs).getString(_key);
    if (stored == null || stored.isEmpty) {
      return <Reminder>[];
    }
    final decoded = jsonDecode(stored) as List<dynamic>;
    final reminders = decoded
        .cast<Map<String, dynamic>>()
        .map(Reminder.fromJson)
        .toList();
    reminders.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return reminders;
  }

  Future<void> save(List<Reminder> reminders) async {
    final encoded =
        jsonEncode(reminders.map((reminder) => reminder.toJson()).toList());
    await (await _prefs).setString(_key, encoded);
  }
}
