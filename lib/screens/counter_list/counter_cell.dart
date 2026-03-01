import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/entries_provider.dart';

const _uuid = Uuid();

String _formatLastChanged(DateTime dt) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final d = dt.day.toString().padLeft(2, '0');
  final mon = months[dt.month - 1];
  final y = dt.year;
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$d $mon $y, $h:$m';
}

IconData _dataTypeIcon(DataType type) {
  return switch (type) {
    DataType.numeric  => Icons.exposure,
    DataType.datetime => Icons.calendar_today,
    DataType.freeText => Icons.notes,
    DataType.event    => Icons.flag,
  };
}

String _formatValue(double val) {
  String s = val.toStringAsFixed(2);
  s = s.replaceAll(RegExp(r'0+$'), '');
  s = s.replaceAll(RegExp(r'\.$'), '');
  return s;
}

/// Returns the icon for the event step button based on [lastEntry]'s state.
IconData eventStepIcon(CounterEntry? lastEntry) {
  if (lastEntry == null) return Icons.play_arrow;
  if (lastEntry.eventType == EventType.finish) return Icons.replay;
  return Icons.fast_forward; // ongoing (start/continueEvent) → advance
}

class CounterCell extends ConsumerWidget {
  const CounterCell({super.key, required this.counter});

  final Counter counter;

  bool get _showQuickActions {
    if (counter.changeStep == null) return false;
    if (double.tryParse(counter.changeStep!) == null) return false;
    return counter.dataType == DataType.numeric;
  }

  bool get _showNumericTimestamp =>
      counter.dataType == DataType.numeric && !_showQuickActions;

  bool get _isEventCounter => counter.dataType == DataType.event;

  bool get _showTextAction => counter.dataType == DataType.freeText;

  /// Applies a step change to the counter. [multiplier] is +1.0 for increment,
  /// -1.0 for decrement.
  Future<void> _handleStep(
    WidgetRef ref,
    CounterEntry? lastEntry,
    double multiplier,
  ) async {
    final step = double.tryParse(counter.changeStep ?? '');
    if (step == null) return;
    final lastValue = lastEntry?.numericValue ?? 0;
    final newValue = lastValue + (step * multiplier);
    final formatted = _formatValue(newValue);

    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: EventType.value,
      value: formatted,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );

    await ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
    // Stream auto-updates; no manual invalidation needed.
  }

  Future<void> _handleDecrement(WidgetRef ref, CounterEntry? lastEntry) =>
      _handleStep(ref, lastEntry, -1.0);

  Future<void> _handleIncrement(WidgetRef ref, CounterEntry? lastEntry) =>
      _handleStep(ref, lastEntry, 1.0);

  Future<void> _handleTimestamp(WidgetRef ref, CounterEntry? lastEntry) async {
    // value is nullable in the DB schema (counter_entries_table.dart), so
    // carrying forward the previous entry's value (or null for the first
    // timestamp) is intentional.
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: EventType.value,
      value: lastEntry?.value, // nullable — matches the nullable DB column
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
    // Stream auto-updates; no manual invalidation needed.
  }

  Future<void> _handleEventStep(WidgetRef ref, CounterEntry? lastEntry) async {
    final eventType =
        (lastEntry == null || lastEntry.eventType == EventType.finish)
            ? EventType.start
            : EventType.continueEvent;
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: eventType,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
    // Stream auto-updates; no manual invalidation needed.
  }

  Future<void> _handleEventFinish(WidgetRef ref) async {
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: EventType.finish,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lastEntryAsync = ref.watch(lastEntryStreamProvider(counter.id));

    final backgroundColor = counter.backgroundColor != null
        ? Color(counter.backgroundColor!)
        : Theme.of(context).colorScheme.surface;

    final currentValueText = lastEntryAsync.when(
      loading: () => const Text('...'),
      data: (entry) => Text(entry?.value ?? l10n.noValuePlaceholder),
      error: (_, __) => Text(l10n.noValuePlaceholder),
    );

    final lastEntry = lastEntryAsync.valueOrNull;

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/counter/${counter.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      counter.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ) ??
                        const TextStyle(),
                    child: currentValueText,
                  ),
                ],
              ),
              if (counter.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: counter.tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          labelStyle: const TextStyle(fontSize: 11),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ],
              if (_showQuickActions) ...[
                const SizedBox(height: 8),
                Builder(builder: (context) {
                  final stepLabel =
                      _formatValue(double.parse(counter.changeStep!));
                  return Row(
                    children: [
                      IconButton(
                        icon: Text('−$stepLabel'),
                        onPressed: () => _handleDecrement(ref, lastEntry),
                        tooltip: 'Decrement',
                      ),
                      Expanded(
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.radio_button_checked),
                            onPressed: () => _handleTimestamp(ref, lastEntry),
                            tooltip: 'Record timestamp',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Text('+$stepLabel'),
                        onPressed: () => _handleIncrement(ref, lastEntry),
                        tooltip: 'Increment',
                      ),
                    ],
                  );
                }),
              ],
              if (_showNumericTimestamp) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.radio_button_checked),
                          onPressed: () => _handleTimestamp(ref, lastEntry),
                          tooltip: 'Record timestamp',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (_showTextAction) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.radio_button_checked),
                          onPressed: () => _handleTimestamp(ref, lastEntry),
                          tooltip: 'Record timestamp',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (_isEventCounter) ...[
                const SizedBox(height: 8),
                if (lastEntry == null || lastEntry.eventType == EventType.finish)
                  // Not started or finished → single centered button
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: IconButton(
                            icon: Icon(lastEntry == null
                                ? Icons.play_arrow
                                : Icons.replay),
                            onPressed: () =>
                                _handleEventStep(ref, lastEntry),
                            tooltip: l10n.buttonStart,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // Ongoing → centered ⊙ (continue) + right-aligned finish.
                  // The SizedBox mirrors the Finish button width so that
                  // Expanded(Center(...)) lands on the true row centre.
                  Row(
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.radio_button_checked),
                            onPressed: () =>
                                _handleEventStep(ref, lastEntry),
                            tooltip: l10n.buttonContinue,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () => _handleEventFinish(ref),
                        tooltip: l10n.buttonFinish,
                      ),
                    ],
                  ),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    _dataTypeIcon(counter.dataType),
                    size: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
                  ),
                  if (lastEntry != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      _formatLastChanged(lastEntry.recordedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.55),
                          ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
