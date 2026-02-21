import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import '../../providers/counters_provider.dart';
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

class CounterDetailScreen extends ConsumerStatefulWidget {
  const CounterDetailScreen({super.key, required this.counterId});

  final String counterId;

  @override
  ConsumerState<CounterDetailScreen> createState() =>
      _CounterDetailScreenState();
}

class _CounterDetailScreenState extends ConsumerState<CounterDetailScreen> {
  final TextEditingController _valueController = TextEditingController();
  Timer? _autoSaveTimer;

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _valueController.dispose();
    super.dispose();
  }

  void _onValueChanged(String value) {
    final counterAsync = ref.read(counterByIdProvider(widget.counterId));
    final counter = counterAsync.valueOrNull;
    if (counter?.autoSave != true) return;
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), () {
      if (_valueController.text.trim().isNotEmpty) {
        _logEntry().then((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Saved'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        });
      }
    });
  }

  Future<void> _logEntry() async {
    final value = _valueController.text.trim();
    if (value.isEmpty) return;
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: widget.counterId,
      eventType: EventType.value,
      value: value,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref
        .read(entryNotifierProvider(widget.counterId).notifier)
        .addEntry(entry);
    ref.invalidate(lastEntryProvider(widget.counterId));
    _valueController.clear();
  }

  Future<void> _logEventEntry(EventType eventType) async {
    final value = _valueController.text.trim();
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: widget.counterId,
      eventType: eventType,
      value: value.isEmpty ? null : value,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref
        .read(entryNotifierProvider(widget.counterId).notifier)
        .addEntry(entry);
    ref.invalidate(lastEntryProvider(widget.counterId));
  }

  Future<void> _handleStep(Counter counter, CounterEntry? lastEntry,
      double multiplier) async {
    final step = double.parse(counter.changeStep!);
    final lastValue = lastEntry?.numericValue ?? 0;
    final newValue = lastValue + (step * multiplier);
    final formatted = _formatValue(newValue, counter.dataType);
    final now = DateTime.now();
    final entry = CounterEntry(
      id: _uuid.v4(),
      counterId: widget.counterId,
      eventType: EventType.value,
      value: formatted,
      recordedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref
        .read(entryNotifierProvider(widget.counterId).notifier)
        .addEntry(entry);
    ref.invalidate(lastEntryProvider(widget.counterId));
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !mounted) return;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    _valueController.text = combined.toIso8601String();
  }

  bool _showStepButtons(Counter counter) {
    if (counter.changeStep == null) return false;
    if (double.tryParse(counter.changeStep!) == null) return false;
    return counter.dataType == DataType.integer ||
        counter.dataType == DataType.float;
  }

  Widget _buildInputSection(Counter counter, CounterEntry? lastEntry) {
    final currentValue = lastEntry?.value ?? '—';

    TextInputType keyboardType;
    switch (counter.dataType) {
      case DataType.integer:
        keyboardType = TextInputType.number;
      case DataType.float:
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
      case DataType.datetime:
        keyboardType = TextInputType.datetime;
      case DataType.freeText:
        keyboardType = TextInputType.multiline;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current value card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Current Value',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    currentValue,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Value input field
          if (counter.dataType == DataType.datetime) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _valueController,
                    decoration: const InputDecoration(labelText: 'New value'),
                    keyboardType: keyboardType,
                    maxLines: 1,
                    onChanged: _onValueChanged,
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _pickDateTime,
                  child: const Text('Pick date & time'),
                ),
              ],
            ),
          ] else ...[
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'New value'),
              keyboardType: keyboardType,
              maxLines: counter.dataType == DataType.freeText ? 3 : 1,
              onChanged: _onValueChanged,
            ),
          ],
          const SizedBox(height: 16),

          // Step buttons (numeric types with changeStep)
          if (_showStepButtons(counter)) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.remove),
                    label: Text('−${counter.changeStep}'),
                    onPressed: () => _handleStep(counter, lastEntry, -1.0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text('+${counter.changeStep}'),
                    onPressed: () => _handleStep(counter, lastEntry, 1.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Event buttons (event behavior type)
          if (counter.behaviorType == BehaviorType.event) ...[
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _logEventEntry(EventType.start),
                    child: const Text('Start'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _logEventEntry(EventType.continueEvent),
                    child: const Text('Continue'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _logEventEntry(EventType.finish),
                    child: const Text('Finish'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Log button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _logEntry,
              child: const Text('Log'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final counterAsync = ref.watch(counterByIdProvider(widget.counterId));
    final lastEntryAsync = ref.watch(lastEntryProvider(widget.counterId));
    // Start watching entries for this counter (used in Step 13)
    ref.watch(entriesForCounterProvider(widget.counterId));

    return counterAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $error')),
      ),
      data: (counter) {
        if (counter == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Counter not found')),
          );
        }

        final lastEntry = lastEntryAsync.valueOrNull;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // 1. SliverAppBar
              SliverAppBar(
                title: Text(counter.name),
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit counter',
                    onPressed: () => context.push(
                      '/counter/${widget.counterId}/edit',
                      extra: counter,
                    ),
                  ),
                ],
              ),

              // 2. Top input section
              SliverToBoxAdapter(
                child: _buildInputSection(counter, lastEntry),
              ),

              // 3. Placeholder for chart (Step 17)
              const SliverToBoxAdapter(child: SizedBox.shrink()),

              // 4. History header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Text(
                    'History',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),

              // 5. History entries placeholder (Step 13)
              SliverList.builder(
                itemCount: 1,
                itemBuilder: (context, index) =>
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('History coming in Step 13'),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
