import 'package:drift/drift.dart';

class CounterEntries extends Table {
  TextColumn get id => text()();
  TextColumn get counterId => text()();
  TextColumn get eventType => text()(); // EventType enum as string
  TextColumn get value => text().nullable()();
  TextColumn get comment => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
