import 'dart:math' show min, max;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/counter.dart';
import '../../models/counter_entry.dart';

class CounterHistoryChart extends StatelessWidget {
  const CounterHistoryChart({
    super.key,
    required this.entries,
    required this.counter,
  });

  final List<CounterEntry> entries;
  final Counter counter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (counter.dataType != DataType.integer &&
        counter.dataType != DataType.float) {
      return const SizedBox.shrink();
    }

    final numericEntries = entries
        .where((e) => e.numericValue != null)
        .toList()
        .reversed
        .toList();

    if (numericEntries.length < 2) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(
            l10n.chartNotEnoughData,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    final spots = numericEntries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.numericValue!);
    }).toList();

    final minY = spots.map((s) => s.y).reduce(min);
    final maxY = spots.map((s) => s.y).reduce(max);
    final yRange = maxY - minY;
    final padding = yRange == 0 ? 1.0 : yRange * 0.1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
      child: SizedBox(
        height: 160,
        child: LineChart(
          LineChartData(
            minY: minY - padding,
            maxY: maxY + padding,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(
              leftTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.3,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 2,
                dotData: FlDotData(
                  show: spots.length <= 20,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
