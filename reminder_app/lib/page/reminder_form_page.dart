import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/reminder.dart';

class ReminderFormPage extends StatefulWidget {
  const ReminderFormPage({super.key, this.reminder});

  /// The reminder being edited, or null when creating a new one.
  final Reminder? reminder;

  @override
  State<ReminderFormPage> createState() => _ReminderFormPageState();
}

class _ReminderFormPageState extends State<ReminderFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _title;
  late final TextEditingController _notes;
  late DateTime _dueAt;
  late Repeat _repeat;

  @override
  void initState() {
    super.initState();
    final reminder = widget.reminder;
    _title = TextEditingController(text: reminder?.title ?? '');
    _notes = TextEditingController(text: reminder?.notes ?? '');
    _repeat = reminder?.repeat ?? Repeat.never;
    _dueAt = reminder?.dueAt ??
        DateTime.now().add(const Duration(hours: 1)).copyWith(
              minute: 0,
              second: 0,
              millisecond: 0,
              microsecond: 0,
            );
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _dueAt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _dueAt.hour,
          _dueAt.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueAt),
    );
    if (picked != null) {
      setState(() {
        _dueAt = DateTime(
          _dueAt.year,
          _dueAt.month,
          _dueAt.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(
      Reminder(
        id: widget.reminder?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        title: _title.text.trim(),
        notes: _notes.text.trim(),
        dueAt: _dueAt,
        repeat: _repeat,
        done: widget.reminder?.done ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'New reminder' : 'Edit reminder'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _title,
              autofocus: widget.reminder == null,
              decoration: const InputDecoration(labelText: 'Title'),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Give the reminder a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('Date'),
              subtitle: Text(DateFormat.yMMMMd().format(_dueAt)),
              onTap: _pickDate,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: const Text('Time'),
              subtitle: Text(DateFormat.Hm().format(_dueAt)),
              onTap: _pickTime,
            ),
            DropdownButtonFormField<Repeat>(
              initialValue: _repeat,
              decoration: const InputDecoration(labelText: 'Repeat'),
              items: <DropdownMenuItem<Repeat>>[
                for (final repeat in Repeat.values)
                  DropdownMenuItem<Repeat>(
                    value: repeat,
                    child: Text(repeat.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _repeat = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: const Text('Save reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
