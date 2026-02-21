import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'database_provider.dart';

/// Watches all non-deleted entries for [counterId], newest-first.
final entriesForCounterProvider =
    StreamProvider.family<List<CounterEntry>, String>((ref, counterId) {
  return ref
      .watch(databaseProvider)
      .entriesDao
      .watchEntriesForCounter(counterId);
});

/// Returns the most recent entry for [counterId], or null if none exist.
final lastEntryProvider =
    FutureProvider.family<CounterEntry?, String>((ref, counterId) {
  return ref
      .watch(databaseProvider)
      .entriesDao
      .getLastEntryForCounter(counterId);
});

/// Handles entry mutations (insert, update) scoped to a specific counter.
class EntryNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<void> addEntry(CounterEntry e) async {
    await ref.read(databaseProvider).entriesDao.insertEntry(e);
  }

  Future<void> updateEntry(CounterEntry e) async {
    await ref.read(databaseProvider).entriesDao.updateEntry(e);
  }
}

final entryNotifierProvider =
    AsyncNotifierProvider.family<EntryNotifier, void, String>(
        () => EntryNotifier());
