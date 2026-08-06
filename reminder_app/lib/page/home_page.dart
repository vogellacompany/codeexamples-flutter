import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/reminder.dart';
import '../repository/reminder_repository.dart';
import '../service/notification_service.dart';
import 'reminder_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.repository,
    required this.notifications,
  });

  final ReminderRepository repository;
  final NotificationService notifications;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Reminder>? _reminders;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final reminders = await widget.repository.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _reminders = reminders;
    });
  }

  Future<void> _persist(List<Reminder> reminders) async {
    reminders.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    setState(() {
      _reminders = reminders;
    });
    await widget.repository.save(reminders);
  }

  Future<void> _openForm({Reminder? reminder}) async {
    final saved = await Navigator.of(context).push<Reminder>(
      MaterialPageRoute<Reminder>(
        builder: (context) => ReminderFormPage(reminder: reminder),
      ),
    );
    if (saved == null) {
      return;
    }
    final reminders = <Reminder>[
      for (final existing in _reminders ?? <Reminder>[])
        if (existing.id != saved.id) existing,
      saved,
    ];
    await _persist(reminders);
    await widget.notifications.schedule(saved);
  }

  Future<void> _toggleDone(Reminder reminder) async {
    final updated = reminder.copyWith(done: !reminder.done);
    await _persist(<Reminder>[
      for (final existing in _reminders ?? <Reminder>[])
        if (existing.id == reminder.id) updated else existing,
    ]);
    if (updated.done) {
      await widget.notifications.cancel(updated);
    } else {
      await widget.notifications.schedule(updated);
    }
  }

  Future<void> _delete(Reminder reminder) async {
    await _persist(<Reminder>[
      for (final existing in _reminders ?? <Reminder>[])
        if (existing.id != reminder.id) existing,
    ]);
    await widget.notifications.cancel(reminder);
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _reminders;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        child: const Icon(Icons.add),
      ),
      body: reminders == null
          ? const Center(child: CircularProgressIndicator())
          : reminders.isEmpty
              ? const Center(child: Text('No reminders yet. Add one below.'))
              : ListView(
                  padding: const EdgeInsets.only(bottom: 88),
                  children: <Widget>[
                    ..._section(
                      'Overdue',
                      reminders.where((r) => r.isOverdue(now)),
                    ),
                    ..._section(
                      'Today',
                      reminders.where(
                        (r) => !r.done && !r.isOverdue(now) && r.isDueOn(now),
                      ),
                    ),
                    ..._section(
                      'Upcoming',
                      reminders.where(
                        (r) => !r.done && !r.isOverdue(now) && !r.isDueOn(now),
                      ),
                    ),
                    ..._section('Done', reminders.where((r) => r.done)),
                  ],
                ),
    );
  }

  List<Widget> _section(String title, Iterable<Reminder> reminders) {
    if (reminders.isEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
      for (final reminder in reminders)
        _ReminderTile(
          reminder: reminder,
          onToggle: () => _toggleDone(reminder),
          onEdit: () => _openForm(reminder: reminder),
          onDelete: () => _delete(reminder),
        ),
    ];
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.reminder,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Reminder reminder;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overdue = reminder.isOverdue(DateTime.now());
    final subtitle = StringBuffer(
      DateFormat.yMMMd().add_Hm().format(reminder.dueAt),
    );
    if (reminder.repeat != Repeat.never) {
      subtitle.write(' · ${reminder.repeat.label.toLowerCase()}');
    }

    return Dismissible(
      key: ValueKey<String>(reminder.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: theme.colorScheme.errorContainer,
        child: const Icon(Icons.delete),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: Checkbox(
          value: reminder.done,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          reminder.title,
          style: reminder.done
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(
          subtitle.toString(),
          style: overdue ? TextStyle(color: theme.colorScheme.error) : null,
        ),
        trailing: reminder.notes.isEmpty
            ? null
            : const Icon(Icons.notes, size: 18),
        onTap: onEdit,
      ),
    );
  }
}
