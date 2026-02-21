import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import '../../providers/entries_provider.dart';

const _uuid = Uuid();

String _formatValue(double val, DataType dataType) {
  if (dataType == DataType.integer) {
    return val.truncate().toString();
  }
  // float: up to 2 decimals, trim trailing zeros
  String s = val.toStringAsFixed(2);
  s = s.replaceAll(RegExp(r'0+$'), '');
  s = s.replaceAll(RegExp(r'\.$'), '');
  return s;
}

class CounterCell extends ConsumerWidget {
  const CounterCell({super.key, required this.counter});

  final Counter counter;

  bool get _showQuickActions {
    if (counter.changeStep == null) return false;
    if (double.tryParse(counter.changeStep!) == null) return false;
    return counter.dataType == DataType.integer ||
        counter.dataType == DataType.float;
  }

  void _handleDecrement(WidgetRef ref, CounterEntry? lastEntry) {
    final step = double.parse(counter.changeStep!);
    final currentValue = lastEntry?.numericValue;
    final newValue = (currentValue ?? 0) - step;
    final valueStr = _formatValue(newValue, counter.dataType);
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: EventType.value,
      value: valueStr,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
    ref.invalidate(lastEntryProvider(counter.id));
  }

  void _handleIncrement(WidgetRef ref, CounterEntry? lastEntry) {
    final step = double.parse(counter.changeStep!);
    final currentValue = lastEntry?.numericValue;
    final newValue = (currentValue ?? 0) + step;
    final valueStr = _formatValue(newValue, counter.dataType);
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: EventType.value,
      value: valueStr,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
    ref.invalidate(lastEntryProvider(counter.id));
  }

  void _handleTimestamp(WidgetRef ref, CounterEntry? lastEntry) {
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: counter.id,
      eventType: EventType.value,
      value: lastEntry?.value,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    ref.read(entryNotifierProvider(counter.id).notifier).addEntry(entry);
    ref.invalidate(lastEntryProvider(counter.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastEntryAsync = ref.watch(lastEntryProvider(counter.id));

    final backgroundColor = counter.backgroundColor != null
        ? Color(counter.backgroundColor!)
        : Theme.of(context).colorScheme.surface;

    final currentValueText = lastEntryAsync.when(
      loading: () => const Text('...'),
      data: (entry) => Text(entry?.value ?? '—'),
      error: (_, __) => const Text('—'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _handleDecrement(ref, lastEntry),
                      tooltip: 'Decrement',
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _handleIncrement(ref, lastEntry),
                      tooltip: 'Increment',
                    ),
                    IconButton(
                      icon: const Icon(Icons.radio_button_checked),
                      onPressed: () => _handleTimestamp(ref, lastEntry),
                      tooltip: 'Record timestamp',
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
