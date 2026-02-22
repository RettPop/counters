import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:counters/db/database.dart';
import 'package:counters/models/models.dart' as domain;

AppDatabase openTestDb() => AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDb());
  tearDown(() => db.close());

  final now = DateTime(2024, 6, 1, 12);

  domain.CounterEntry makeEntry({
    String id = 'e-1',
    String counterId = 'c-1',
    domain.EventType eventType = domain.EventType.value,
    String? value = '42',
    String? comment,
    DateTime? recordedAt,
    DateTime? createdAt,
  }) =>
      domain.CounterEntry(
        id: id,
        counterId: counterId,
        eventType: eventType,
        value: value,
        comment: comment,
        recordedAt: recordedAt ?? now,
        createdAt: createdAt ?? now,
        updatedAt: now,
      );

  group('EntriesDao', () {
    test('insert entry and retrieve via watchEntriesForCounter', () async {
      await db.entriesDao.insertEntry(makeEntry());

      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(list.length, 1);
      expect(list[0].id, 'e-1');
      expect(list[0].counterId, 'c-1');
      expect(list[0].eventType, domain.EventType.value);
      expect(list[0].value, '42');
      expect(list[0].comment, isNull);
    });

    test('soft-delete entry disappears from stream', () async {
      await db.entriesDao.insertEntry(makeEntry());

      final before = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(before.length, 1);

      await db.entriesDao.softDeleteEntry('e-1');

      final after = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(after, isEmpty);
    });

    test('getLastEntryForCounter returns most recent by recordedAt', () async {
      final older = makeEntry(
        id: 'e-1',
        recordedAt: now,
      );
      final newer = makeEntry(
        id: 'e-2',
        recordedAt: now.add(const Duration(hours: 1)),
      );

      await db.entriesDao.insertEntry(older);
      await db.entriesDao.insertEntry(newer);

      final last = await db.entriesDao.getLastEntryForCounter('c-1');
      expect(last, isNotNull);
      expect(last!.id, 'e-2');
    });

    test('getLastEntryForCounter returns null when no entries exist', () async {
      final last = await db.entriesDao.getLastEntryForCounter('no-such-counter');
      expect(last, isNull);
    });

    test('updateEntry returns rows affected == 1', () async {
      await db.entriesDao.insertEntry(makeEntry());

      final updated = makeEntry().copyWith(
        value: '99',
        updatedAt: now.add(const Duration(hours: 1)),
      );
      final rowsAffected = await db.entriesDao.updateEntry(updated);
      expect(rowsAffected, 1);

      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(list[0].value, '99');
    });

    test('EventType round-trip — value', () async {
      await db.entriesDao
          .insertEntry(makeEntry(id: 'e-v', eventType: domain.EventType.value));
      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(
        list.firstWhere((e) => e.id == 'e-v').eventType,
        domain.EventType.value,
      );
    });

    test('EventType round-trip — start', () async {
      await db.entriesDao
          .insertEntry(makeEntry(id: 'e-s', eventType: domain.EventType.start));
      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(
        list.firstWhere((e) => e.id == 'e-s').eventType,
        domain.EventType.start,
      );
    });

    test('EventType round-trip — continueEvent', () async {
      await db.entriesDao.insertEntry(
        makeEntry(id: 'e-c', eventType: domain.EventType.continueEvent),
      );
      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(
        list.firstWhere((e) => e.id == 'e-c').eventType,
        domain.EventType.continueEvent,
      );
    });

    test('EventType round-trip — finish', () async {
      await db.entriesDao.insertEntry(
        makeEntry(id: 'e-f', eventType: domain.EventType.finish),
      );
      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(
        list.firstWhere((e) => e.id == 'e-f').eventType,
        domain.EventType.finish,
      );
    });

    test('nullable value round-trips as null', () async {
      await db.entriesDao.insertEntry(makeEntry(value: null));

      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(list[0].value, isNull);
    });

    test('nullable comment round-trips as null', () async {
      await db.entriesDao.insertEntry(makeEntry(comment: null));

      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(list[0].comment, isNull);
    });

    test('nullable comment round-trips with a non-null value', () async {
      await db.entriesDao.insertEntry(makeEntry(comment: 'great run'));

      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(list[0].comment, 'great run');
    });

    test('watchEntriesForCounter orders newest first', () async {
      final e1 = makeEntry(id: 'e-1', recordedAt: now);
      final e2 = makeEntry(
        id: 'e-2',
        recordedAt: now.add(const Duration(seconds: 1)),
      );

      await db.entriesDao.insertEntry(e1);
      await db.entriesDao.insertEntry(e2);

      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(list[0].id, 'e-2'); // newest first
      expect(list[1].id, 'e-1');
    });

    test('watchEntriesForCounter is scoped to the given counterId', () async {
      await db.entriesDao.insertEntry(makeEntry(id: 'e-1', counterId: 'c-1'));
      await db.entriesDao.insertEntry(makeEntry(id: 'e-2', counterId: 'c-2'));

      final list = await db.entriesDao.watchEntriesForCounter('c-1').first;
      expect(list.length, 1);
      expect(list[0].id, 'e-1');
    });
  });
}
