import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/counters_dao.dart';
import 'daos/entries_dao.dart';
import 'daos/photos_dao.dart';
import 'tables/counter_entries_table.dart';
import 'tables/counters_table.dart';
import 'tables/entry_photos_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Counters, CounterEntries, EntryPhotos],
  daos: [CountersDao, EntriesDao, PhotosDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Named constructor for testing — accepts an injected [QueryExecutor].
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(counterEntries);
        await m.createTable(entryPhotos);
      }
      if (from < 3) {
        await customStatement(
          "UPDATE counters SET dataType = 'numeric' WHERE dataType IN ('integer', 'float') AND behaviorType != 'event'",
        );
        await customStatement(
          "UPDATE counters SET dataType = 'event' WHERE behaviorType = 'event'",
        );
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'counters_db');
}
