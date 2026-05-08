import 'dart:math' show min, max;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/counter.dart';
import '../../models/counter_entry.dart';
import '../../theme/app_theme.dart';

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

    if (counter.dataType != DataType.numeric) {
      return const SizedBox.shrink();
    }

    final numericEntries = entries
        .where((e) => e.numericValue != null)
        .toList()
        .reversed
        .toList();

    if (numericEntries.length < 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
          ),
          child: Center(
            child: Text(
              l10n.chartNotEnoughData,
              style: const TextStyle(color: AppColors.ink3),
            ),
          ),
        ),
      );
    }

    final tint = tintFromBackgroundColor(counter.backgroundColor);

    final spots = numericEntries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.numericValue!);
    }).toList();

    final minY = spots.map((s) => s.y).reduce(min);
    final maxY = spots.map((s) => s.y).reduce(max);
    final yRange = maxY - minY;
    final padding = yRange == 0 ? 1.0 : yRange * 0.1;

    // Compute stats
    final values = numericEntries.map((e) => e.numericValue!).toList();
    final avg = values.reduce((a, b) => a + b) / values.length;
    final low = values.reduce(min);
    final high = values.reduce(max);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 140,
              child: LineChart(
                LineChartData(
                  minY: minY - padding,
                  maxY: maxY + padding,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: yRange == 0 ? 1 : yRange / 3,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppColors.line,
                      strokeWidth: 1,
                      dashArray: [2, 4],
                    ),
                  ),
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
                      color: tint.dot,
                      barWidth: 2,
                      dotData: FlDotData(
                        show: spots.length <= 20,
                        getDotPainter: (spot, _, __, index) {
                          final isLast = index == spots.length - 1;
                          return FlDotCirclePainter(
                            radius: isLast ? 4 : 2,
                            color: isLast ? tint.ink : tint.dot,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: tint.dot.withAlpha(36),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Stat(label: 'Avg', value: avg.toStringAsFixed(1)),
                _Stat(label: 'Low', value: low.toStringAsFixed(1)),
                _Stat(label: 'High', value: high.toStringAsFixed(1)),
                _Stat(label: 'Logs', value: '${values.length}'),
              ],
            ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppColors.ink3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'SF Mono',
            fontSize: 18,
            color: AppColors.ink,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
