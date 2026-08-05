import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/weekly_summary.dart';

/// Bar chart of the minutes trained on each of the last seven days.
class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key, required this.summary});

  final WeeklySummary summary;

  @override
  Widget build(BuildContext context) {
    final days = summary.days;
    final maxMinutes = days
        .map((day) => day.duration.inMinutes)
        .fold(0, (a, b) => a > b ? a : b);
    final colorScheme = Theme.of(context).colorScheme;

    return BarChart(
      BarChartData(
        // Keep a visible baseline even in a week without any workout.
        maxY: (maxMinutes == 0 ? 60 : maxMinutes * 1.2).toDouble(),
        barGroups: <BarChartGroupData>[
          for (var i = 0; i < days.length; i++)
            BarChartGroupData(
              x: i,
              barRods: <BarChartRodData>[
                BarChartRodData(
                  toY: days[i].duration.inMinutes.toDouble(),
                  color: colorScheme.primary,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            ),
        ],
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= days.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat.E().format(days[index].date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: false),
      ),
    );
  }
}
