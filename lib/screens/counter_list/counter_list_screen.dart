import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/counters_provider.dart';
import 'counter_cell.dart';

class CounterListScreen extends ConsumerWidget {
  const CounterListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countersAsync = ref.watch(countersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Counters')),
      body: countersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (counters) {
          if (counters.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_chart, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'No counters yet.\nTap + to add one.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: counters.length,
            itemBuilder: (context, index) =>
                CounterCell(counter: counters[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/counter/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
