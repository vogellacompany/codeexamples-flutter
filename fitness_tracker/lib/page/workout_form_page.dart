import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/workout.dart';

/// Form for adding or editing a workout.
class WorkoutFormPage extends StatefulWidget {
  const WorkoutFormPage({super.key, this.workout});

  /// The workout being edited, or null when adding a new one.
  final Workout? workout;

  @override
  State<WorkoutFormPage> createState() => _WorkoutFormPageState();
}

class _WorkoutFormPageState extends State<WorkoutFormPage> {
  final _formKey = GlobalKey<FormState>();

  late WorkoutType _type;
  late DateTime _date;
  late final TextEditingController _minutes;
  late final TextEditingController _distance;

  @override
  void initState() {
    super.initState();
    final workout = widget.workout;
    _type = workout?.type ?? WorkoutType.running;
    _date = workout?.date ?? DateTime.now();
    _minutes = TextEditingController(
      text: workout == null ? '' : '${workout.duration.inMinutes}',
    );
    _distance = TextEditingController(
      text: workout?.distanceKm == null ? '' : '${workout!.distanceKm}',
    );
  }

  @override
  void dispose() {
    _minutes.dispose();
    _distance.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final distance = _distance.text.trim();
    final workout = Workout(
      id: widget.workout?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      type: _type,
      date: _date,
      duration: Duration(minutes: int.parse(_minutes.text.trim())),
      distanceKm: distance.isEmpty ? null : double.parse(distance),
    );
    Navigator.of(context).pop(workout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout == null ? 'New workout' : 'Edit workout'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            DropdownButtonFormField<WorkoutType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: <DropdownMenuItem<WorkoutType>>[
                for (final type in WorkoutType.values)
                  DropdownMenuItem<WorkoutType>(
                    value: type,
                    child: Text(type.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _type = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(DateFormat.yMMMMd().format(_date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            TextFormField(
              controller: _minutes,
              decoration: const InputDecoration(
                labelText: 'Duration',
                suffixText: 'minutes',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                final minutes = int.tryParse(value?.trim() ?? '');
                if (minutes == null || minutes <= 0) {
                  return 'Enter the duration in whole minutes';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _distance,
              decoration: const InputDecoration(
                labelText: 'Distance (optional)',
                suffixText: 'km',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return null;
                }
                final distance = double.tryParse(text);
                if (distance == null || distance <= 0) {
                  return 'Enter a distance greater than zero, or leave empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: const Text('Save workout'),
            ),
          ],
        ),
      ),
    );
  }
}
