import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reminder_app/main.dart';
import 'package:reminder_app/model/reminder.dart';
import 'package:reminder_app/page/reminder_form_page.dart';
import 'package:reminder_app/repository/reminder_repository.dart';
import 'package:reminder_app/service/notification_service.dart';

Reminder reminderAt(DateTime dueAt, {String title = 'Call the dentist',
    Repeat repeat = Repeat.never, bool done = false}) {
  return Reminder(
    id: '${dueAt.microsecondsSinceEpoch}-$title',
    title: title,
    dueAt: dueAt,
    repeat: repeat,
    done: done,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Reminder', () {
    test('survives a JSON round trip', () {
      final reminder = Reminder(
        id: 'r1',
        title: 'Water the plants',
        dueAt: DateTime(2026, 8, 6, 9, 30),
        notes: 'The big one on the balcony',
        repeat: Repeat.weekly,
        done: true,
      );

      expect(Reminder.fromJson(reminder.toJson()), reminder);
    });

    test('is overdue only while it is not done', () {
      final now = DateTime(2026, 8, 5, 12);
      final past = reminderAt(DateTime(2026, 8, 4));

      expect(past.isOverdue(now), isTrue);
      expect(past.copyWith(done: true).isOverdue(now), isFalse);
    });

    test('a one-off reminder has no next occurrence', () {
      expect(reminderAt(DateTime(2026, 8, 4)).nextOccurrence(DateTime(2026, 8, 5)),
          isNull);
    });

    test('a daily reminder repeats past the given moment', () {
      final reminder = reminderAt(DateTime(2026, 8, 1, 7), repeat: Repeat.daily);

      expect(
        reminder.nextOccurrence(DateTime(2026, 8, 5, 12)),
        DateTime(2026, 8, 6, 7),
      );
    });

    test('a weekly reminder keeps its weekday', () {
      final reminder =
          reminderAt(DateTime(2026, 8, 1, 7), repeat: Repeat.weekly);
      final next = reminder.nextOccurrence(DateTime(2026, 8, 5, 12));

      expect(next, DateTime(2026, 8, 8, 7));
      expect(next!.weekday, DateTime(2026, 8, 1).weekday);
    });

    test('falls back to never for an unknown repeat', () {
      expect(Repeat.fromName('hourly'), Repeat.never);
    });
  });

  group('ReminderRepository', () {
    test('returns an empty list when nothing was stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});

      expect(await ReminderRepository().load(), isEmpty);
    });

    test('reads reminders back in due order', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final repository = ReminderRepository();
      final later = reminderAt(DateTime(2026, 8, 9), title: 'Later');
      final sooner = reminderAt(DateTime(2026, 8, 6), title: 'Sooner');

      await repository.save(<Reminder>[later, sooner]);

      expect(
        (await repository.load()).map((r) => r.title),
        <String>['Sooner', 'Later'],
      );
    });
  });

  group('NotificationService', () {
    test('is unavailable until it initializes, and stays silent', () async {
      final service = NotificationService();

      expect(service.available, isFalse);
      // Must not throw when notifications are unavailable.
      await service.schedule(reminderAt(DateTime(2030, 1, 1)));
      await service.cancel(reminderAt(DateTime(2030, 1, 1)));
    });
  });

  group('ReminderFormPage', () {
    testWidgets('requires a title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ReminderFormPage()));

      await tester.tap(find.text('Save reminder'));
      await tester.pump();

      expect(find.text('Give the reminder a title'), findsOneWidget);
    });

    testWidgets('returns the edited reminder', (WidgetTester tester) async {
      final existing = reminderAt(DateTime(2026, 8, 6, 9), title: 'Old title');

      await tester.pumpWidget(
        MaterialApp(home: ReminderFormPage(reminder: existing)),
      );
      await tester.enterText(find.byType(TextFormField).first, 'New title');
      await tester.tap(find.text('Save reminder'));
      await tester.pumpAndSettle();

      expect(find.text('New title'), findsNothing);
    });
  });

  testWidgets('groups reminders into overdue, today and upcoming',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final repository = ReminderRepository();
    final now = DateTime.now();
    await repository.save(<Reminder>[
      reminderAt(now.subtract(const Duration(days: 1)), title: 'Overdue one'),
      reminderAt(now.add(const Duration(minutes: 30)), title: 'Later today'),
      reminderAt(now.add(const Duration(days: 3)), title: 'Next week'),
      reminderAt(now.subtract(const Duration(days: 2)),
          title: 'Finished', done: true),
    ]);

    await tester.pumpWidget(
      ReminderApp(
        repository: repository,
        notifications: NotificationService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Overdue one'), findsOneWidget);
    expect(find.text('Finished'), findsOneWidget);
  });
}
