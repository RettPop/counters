import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import '../../providers/counters_provider.dart';
import '../../providers/entries_provider.dart';

const _uuid = Uuid();

class CounterDetailScreen extends ConsumerStatefulWidget {
  const CounterDetailScreen({super.key, required this.counterId});

  final String counterId;

  @override
  ConsumerState<CounterDetailScreen> createState() =>
      _CounterDetailScreenState();
}

class _CounterDetailScreenState extends ConsumerState<CounterDetailScreen> {
  final TextEditingController _valueController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _onValueChanged(String value) {
    // Placeholder for auto-save timer (Step 12)
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
