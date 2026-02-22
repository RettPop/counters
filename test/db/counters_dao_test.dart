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

  domain.Counter makeCounter({
    String id = 'c-1',
    String name = 'Steps',
    List<String> tags = const ['fitness', 'daily'],
    int? backgroundColor = 0xFFFF5733,
    String? changeStep = '1',
    DateTime? createdAt,
  }) =>
      domain.Counter(
        id: id,
        name: name,
        description: 'A test counter',
        dataType: domain.DataType.numeric,
        tags: tags,
        changeStep: changeStep,
        backgroundColor: backgroundColor,
        autoSave: false,
        createdAt: createdAt ?? now,
        updatedAt: now,
      );

  group('CountersDao', () {
    test('insert and retrieve counter by id', () async {
      await db.countersDao.insertCounter(makeCounter());

      final fetched = await db.countersDao.getCounterById('c-1');
      expect(fetched, isNotNull);
      expect(fetched!.id, 'c-1');
      expect(fetched.name, 'Steps');
      expect(fetched.description, 'A test counter');
      expect(fetched.dataType, domain.DataType.numeric);
      expect(fetched.tags, ['fitness', 'daily']);
      expect(fetched.backgroundColor, 0xFFFF5733);
      expect(fetched.changeStep, '1');
      expect(fetched.autoSave, false);
    });

    test('tags list returned from DB is unmodifiable', () async {
      await db.countersDao.insertCounter(makeCounter());
      final fetched = await db.countersDao.getCounterById('c-1');
      expect(() => fetched!.tags.add('extra'), throwsUnsupportedError);
    });

    test('watchAllCounters emits inserted counters ordered by createdAt',
        () async {
      final c1 = makeCounter(id: 'c-1', name: 'Alpha');
      final c2 = makeCounter(
        id: 'c-2',
        name: 'Beta',
        createdAt: now.add(const Duration(seconds: 1)),
      );

      await db.countersDao.insertCounter(c2);
      await db.countersDao.insertCounter(c1);

      final list = await db.countersDao.watchAllCounters().first;
      expect(list.length, 2);
      expect(list[0].id, 'c-1'); // earlier createdAt comes first
      expect(list[1].id, 'c-2');
    });

    test('getCounterById returns null for unknown id', () async {
      final result = await db.countersDao.getCounterById('no-such-id');
      expect(result, isNull);
    });

    test('updateCounter updates name and returns rows affected', () async {
      await db.countersDao.insertCounter(makeCounter());

      final updated = makeCounter().copyWith(
        name: 'Updated Name',
        updatedAt: now.add(const Duration(hours: 1)),
      );
      final rowsAffected = await db.countersDao.updateCounter(updated);
      expect(rowsAffected, 1);

      final fetched = await db.countersDao.getCounterById('c-1');
      expect(fetched!.name, 'Updated Name');
    });

    test('softDeleteCounter hides counter from queries', () async {
      await db.countersDao.insertCounter(makeCounter());
      await db.countersDao.softDeleteCounter('c-1');

      final fetched = await db.countersDao.getCounterById('c-1');
      expect(fetched, isNull);

      final list = await db.countersDao.watchAllCounters().first;
      expect(list, isEmpty);
    });

    test('nullable backgroundColor round-trips as null', () async {
      await db.countersDao
          .insertCounter(makeCounter(backgroundColor: null));
      final fetched = await db.countersDao.getCounterById('c-1');
      expect(fetched!.backgroundColor, isNull);
    });

    test('counter with empty tags round-trips', () async {
      await db.countersDao.insertCounter(makeCounter(tags: []));
      final fetched = await db.countersDao.getCounterById('c-1');
      expect(fetched!.tags, isEmpty);
    });
  });
}
