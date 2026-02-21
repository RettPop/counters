import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/models.dart';
import '../../providers/entries_provider.dart';

class CounterCell extends ConsumerWidget {
  const CounterCell({super.key, required this.counter});

  final Counter counter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastEntryAsync = ref.watch(lastEntryProvider(counter.id));

    final backgroundColor = counter.backgroundColor != null
        ? Color(counter.backgroundColor!)
        : Theme.of(context).cardColor;

    final currentValueText = lastEntryAsync.when(
      loading: () => const Text('...'),
      data: (entry) => Text(entry?.value ?? '—'),
      error: (_, __) => const Text('—'),
    );

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/counter/${counter.id}'),
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
            ],
          ),
        ),
      ),
    );
  }
}
