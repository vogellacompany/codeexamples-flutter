// Entry point used to capture the book figures, with seeded reminders so
// every section of the list is visible.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reminder_app/main.dart';
import 'package:reminder_app/model/reminder.dart';
import 'package:reminder_app/page/reminder_form_page.dart';
import 'package:reminder_app/repository/reminder_repository.dart';
import 'package:reminder_app/service/notification_service.dart';

const screen = String.fromEnvironment('SCREEN', defaultValue: 'home');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  final repository = ReminderRepository();
  final now = DateTime.now();
  await repository.save(<Reminder>[
    _reminder('Renew the domain', now.subtract(const Duration(hours: 20))),
    _reminder('Call the dentist', now.add(const Duration(hours: 3))),
    _reminder('Stand up and stretch', now.add(const Duration(hours: 5)),
        repeat: Repeat.daily),
    _reminder('Team retrospective', now.add(const Duration(days: 2)),
        repeat: Repeat.weekly, notes: 'Prepare the board beforehand'),
    _reminder('Book the train tickets', now.add(const Duration(days: 6))),
    _reminder('Water the plants', now.subtract(const Duration(days: 1)),
        done: true),
  ]);

  runApp(
    screen == 'form'
        ? const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ReminderFormPage(),
          )
        : ReminderApp(
            repository: repository,
            notifications: NotificationService(),
          ),
  );
}

Reminder _reminder(
  String title,
  DateTime dueAt, {
  Repeat repeat = Repeat.never,
  String notes = '',
  bool done = false,
}) {
  return Reminder(
    id: title,
    title: title,
    dueAt: dueAt,
    repeat: repeat,
    notes: notes,
    done: done,
  );
}
