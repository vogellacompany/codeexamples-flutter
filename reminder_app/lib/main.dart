import 'package:flutter/material.dart';

import 'page/home_page.dart';
import 'repository/reminder_repository.dart';
import 'service/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notifications = NotificationService();
  await notifications.initialize();

  runApp(
    ReminderApp(
      repository: ReminderRepository(),
      notifications: notifications,
    ),
  );
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({
    super.key,
    required this.repository,
    required this.notifications,
  });

  final ReminderRepository repository;
  final NotificationService notifications;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminders',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: HomePage(repository: repository, notifications: notifications),
    );
  }
}
