import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'database_provider.dart';

/// Watches all non-deleted counters ordered by creation date.
final countersProvider = StreamProvider<List<Counter>>((ref) {
  return ref.watch(databaseProvider).countersDao.watchAllCounters();
});

/// Fetches a single counter by its [id]. Returns null if not found or deleted.
/// Used as a fallback when navigating to the edit screen without passing the
/// counter object via [GoRouterState.extra] (e.g. deep link or hot restart).
final counterByIdProvider =
    FutureProvider.family<Counter?, String>((ref, id) {
  return ref.watch(databaseProvider).countersDao.getCounterById(id);
});

/// Handles all counter mutations (insert, update, soft-delete).
class CounterNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createCounter(Counter c) async {
    await ref.read(databaseProvider).countersDao.insertCounter(c);
  }

  Future<void> updateCounter(Counter c) async {
    await ref.read(databaseProvider).countersDao.updateCounter(c);
  }

  Future<void> deleteCounter(String id) async {
    await ref.read(databaseProvider).countersDao.softDeleteCounter(id);
  }
}

final counterNotifierProvider =
    AsyncNotifierProvider<CounterNotifier, void>(() => CounterNotifier());
