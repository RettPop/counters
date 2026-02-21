import 'dart:convert';

import 'package:drift/drift.dart';

import '../../models/models.dart' as domain;
import '../database.dart';
import '../tables/counters_table.dart';

part 'counters_dao.g.dart';

@DriftAccessor(tables: [Counters])
class CountersDao extends DatabaseAccessor<AppDatabase>
    with _$CountersDaoMixin {
  CountersDao(super.db);

  Stream<List<domain.Counter>> watchAllCounters() {
    return (select(counters)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_rowToDomain).toList());
  }

  Future<domain.Counter?> getCounterById(String id) async {
    final row = await (select(counters)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull())
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _rowToDomain(row);
  }

  Future<void> insertCounter(domain.Counter c) {
    return into(counters).insert(_domainToCompanion(c));
  }

  Future<void> updateCounter(domain.Counter c) {
    return (update(counters)..where((t) => t.id.equals(c.id))).write(
      _domainToCompanion(c).copyWith(
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> softDeleteCounter(String id) {
    return (update(counters)..where((t) => t.id.equals(id))).write(
      CountersCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Private mapping helpers
  // ---------------------------------------------------------------------------

  domain.Counter _rowToDomain(Counter row) {
    return domain.Counter(
      id: row.id,
      name: row.name,
      description: row.description,
      behaviorType: domain.BehaviorType.values.byName(row.behaviorType),
      dataType: domain.DataType.values.byName(row.dataType),
      tags: List.unmodifiable(
        (jsonDecode(row.tags) as List).cast<String>(),
      ),
      changeStep: row.changeStep,
      backgroundColor: row.backgroundColor,
      autoSaveDelay: row.autoSaveDelay,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  CountersCompanion _domainToCompanion(domain.Counter c) {
    return CountersCompanion(
      id: Value(c.id),
      name: Value(c.name),
      description: Value(c.description),
      behaviorType: Value(c.behaviorType.name),
      dataType: Value(c.dataType.name),
      tags: Value(jsonEncode(c.tags)),
      changeStep: Value(c.changeStep),
      backgroundColor: Value(c.backgroundColor),
      autoSaveDelay: Value(c.autoSaveDelay),
      createdAt: Value(c.createdAt),
      updatedAt: Value(c.updatedAt),
      deletedAt: Value(c.deletedAt),
    );
  }
}
