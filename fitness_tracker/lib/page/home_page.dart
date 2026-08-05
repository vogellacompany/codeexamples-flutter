import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/weekly_summary.dart';
import '../model/workout.dart';
import '../repository/workout_repository.dart';
import '../widget/weekly_chart.dart';
import 'workout_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.repository});

  final WorkoutRepository repository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Workout>? _workouts;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final workouts = await widget.repository.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _workouts = workouts;
    });
  }

  Future<void> _persist(List<Workout> workouts) async {
    workouts.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      _workouts = workouts;
    });
    await widget.repository.save(workouts);
  }

  Future<void> _addWorkout() async {
    final created = await Navigator.of(context).push<Workout>(
      MaterialPageRoute<Workout>(builder: (context) => const WorkoutFormPage()),
    );
    if (created != null) {
      await _persist(<Workout>[...?_workouts, created]);
    }
  }

  Future<void> _delete(Workout workout) async {
    final remaining =
        (_workouts ?? <Workout>[]).where((w) => w.id != workout.id).toList();
    await _persist(remaining);
  }

  @override
  Widget build(BuildContext context) {
    final workouts = _workouts;

    return Scaffold(
      appBar: AppBar(title: const Text('Fitness tracker')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWorkout,
        child: const Icon(Icons.add),
      ),
      body: workouts == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                _SummaryCard(summary: WeeklySummary(workouts)),
                if (workouts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('Add your first workout with the plus button.'),
                    ),
                  )
                else
                  for (final workout in workouts)
                    _WorkoutTile(
                      workout: workout,
                      onDelete: () => _delete(workout),
                    ),
              ],
            ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final WeeklySummary summary;

  @override
  Widget build(BuildContext context) {
    final hours = summary.totalDuration.inMinutes / 60;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('This week', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _Stat(label: 'Workouts', value: '${summary.workoutCount}'),
                _Stat(label: 'Hours', value: hours.toStringAsFixed(1)),
                _Stat(
                  label: 'Kilometers',
                  value: summary.totalDistanceKm.toStringAsFixed(1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(height: 140, child: WeeklyChart(summary: summary)),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Text(value, style: theme.textTheme.headlineSmall),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  const _WorkoutTile({required this.workout, required this.onDelete});

  final Workout workout;
  final VoidCallback onDelete;

  static const _icons = <WorkoutType, IconData>{
    WorkoutType.running: Icons.directions_run,
    WorkoutType.cycling: Icons.directions_bike,
    WorkoutType.swimming: Icons.pool,
    WorkoutType.strength: Icons.fitness_center,
  };

  @override
  Widget build(BuildContext context) {
    final distance = workout.distanceKm;
    final subtitle = StringBuffer(DateFormat.yMMMd().format(workout.date))
      ..write(' · ${workout.duration.inMinutes} min');
    if (distance != null) {
      subtitle.write(' · ${distance.toStringAsFixed(1)} km');
    }

    return Dismissible(
      key: ValueKey<String>(workout.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Theme.of(context).colorScheme.errorContainer,
        child: const Icon(Icons.delete),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: Icon(_icons[workout.type]),
        title: Text(workout.type.label),
        subtitle: Text(subtitle.toString()),
      ),
    );
  }
}
