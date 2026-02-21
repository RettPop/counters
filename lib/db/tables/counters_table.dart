import 'package:drift/drift.dart';

class Counters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get behaviorType => text()();
  TextColumn get dataType => text()();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  TextColumn get changeStep => text().nullable()();
  IntColumn get backgroundColor => integer().nullable()();
  BoolColumn get autoSaveDelay =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
