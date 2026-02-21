import 'package:drift/drift.dart';

import '../../models/models.dart' as domain;
import '../database.dart';
import '../tables/counter_entries_table.dart';

part 'entries_dao.g.dart';

@DriftAccessor(tables: [CounterEntries])
class EntriesDao extends DatabaseAccessor<AppDatabase>
    with _$EntriesDaoMixin {
  EntriesDao(super.db);

  /// Stream of entries for a counter, newest-first, excluding soft-deleted.
  Stream<List<domain.CounterEntry>> watchEntriesForCounter(String counterId) {
    return (select(counterEntries)
          ..where(
            (t) => t.counterId.equals(counterId) & t.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .watch()
        .map((rows) => rows.map(_rowToDomain).toList());
  }

  /// Most recent entry for a counter (newest recordedAt, not deleted).
  Future<domain.CounterEntry?> getLastEntryForCounter(String counterId) async {
    final row = await (select(counterEntries)
          ..where(
            (t) => t.counterId.equals(counterId) & t.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _rowToDomain(row);
  }

  /// Insert a new entry.
  Future<void> insertEntry(domain.CounterEntry e) {
    return into(counterEntries).insert(_domainToCompanion(e));
  }

  /// Update an entry (DAO owns updatedAt).
  Future<int> updateEntry(domain.CounterEntry e) {
    return (update(counterEntries)..where((t) => t.id.equals(e.id))).write(
      _domainToCompanion(e).copyWith(
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Soft-delete an entry.
  Future<void> softDeleteEntry(String id) {
    return (update(counterEntries)..where((t) => t.id.equals(id))).write(
      CounterEntriesCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Private mapping helpers
  // ---------------------------------------------------------------------------

  domain.CounterEntry _rowToDomain(CounterEntry row) {
    return domain.CounterEntry(
      id: row.id,
      counterId: row.counterId,
      eventType: domain.EventType.values.byName(row.eventType),
      value: row.value,
      comment: row.comment,
      recordedAt: row.recordedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  CounterEntriesCompanion _domainToCompanion(domain.CounterEntry e) {
    return CounterEntriesCompanion(
      id: Value(e.id),
      counterId: Value(e.counterId),
      eventType: Value(e.eventType.name),
      value: Value(e.value),
      comment: Value(e.comment),
      recordedAt: Value(e.recordedAt),
      createdAt: Value(e.createdAt),
      updatedAt: Value(e.updatedAt),
      deletedAt: Value(e.deletedAt),
    );
  }
}
