import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../model/reminder.dart';

/// Schedules the reminder notifications.
///
/// Notifications are not available on every platform the examples run on, so
/// every call is a no-op when initialization did not succeed. The rest of the
/// app works either way.
class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'reminders';

  final FlutterLocalNotificationsPlugin _plugin;

  bool _available = false;

  bool get available => _available;

  Future<void> initialize() async {
    try {
      tz.initializeTimeZones();
      _available = await _plugin.initialize(
            settings: const InitializationSettings(
              android: AndroidInitializationSettings('@mipmap/ic_launcher'),
              linux: LinuxInitializationSettings(defaultActionName: 'Open'),
            ),
          ) ??
          false;
    } on Exception catch (error) {
      debugPrint('Notifications unavailable: $error');
      _available = false;
    }
  }

  Future<void> schedule(Reminder reminder) async {
    if (!_available || reminder.done) {
      return;
    }
    final when = reminder.dueAt.isAfter(DateTime.now())
        ? reminder.dueAt
        : reminder.nextOccurrence(DateTime.now());
    if (when == null) {
      return;
    }

    await _plugin.zonedSchedule(
      id: reminder.id.hashCode,
      title: reminder.title,
      body: reminder.notes.isEmpty ? null : reminder.notes,
      scheduledDate: tz.TZDateTime.from(when, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(_channelId, 'Reminders'),
        linux: LinuxNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancel(Reminder reminder) async {
    if (!_available) {
      return;
    }
    await _plugin.cancel(id: reminder.id.hashCode);
  }
}
