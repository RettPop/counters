import 'package:drift/drift.dart';

import 'counter_entries_table.dart';

class EntryPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get entryId => text().references(CounterEntries, #id)();
  TextColumn get localPath => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
