// ignore_for_file: avoid_print

import 'package:counters/db/database.dart' show AppDatabase;
import 'package:counters/models/models.dart';
import 'package:counters/providers/counters_provider.dart';
import 'package:counters/providers/database_provider.dart';
import 'package:counters/providers/entries_provider.dart';
import 'package:counters/providers/photos_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates an in-memory [AppDatabase] and overrides [databaseProvider].
ProviderContainer makeContainer() {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  return ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
    ],
  );
}

void main() {
  group('databaseProvider', () {
    test('provides an AppDatabase instance', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final db = container.read(databaseProvider);
      expect(db, isA<AppDatabase>());
    });
  });

  group('countersProvider', () {
    test('emits an empty list on a fresh database', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final stream = container.read(countersProvider.future);
      final result = await stream;
      expect(result, isEmpty);
    });

    test('emits updated list after inserting a counter', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      final counter = Counter(
        id: 'c1',
        name: 'Test Counter',
        behaviorType: BehaviorType.value,
        dataType: DataType.integer,
        tags: const [],
        createdAt: now,
        updatedAt: now,
      );

      await container.read(counterNotifierProvider.notifier).createCounter(counter);

      final result = await container.read(countersProvider.future);
      expect(result, hasLength(1));
      expect(result.first.id, equals('c1'));
      expect(result.first.name, equals('Test Counter'));
    });
  });

  group('counterNotifierProvider', () {
    test('build completes without error', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await expectLater(
        container.read(counterNotifierProvider.future),
        completes,
      );
    });

    test('deleteCounter soft-deletes a counter', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      final counter = Counter(
        id: 'c-del',
        name: 'To Delete',
        behaviorType: BehaviorType.event,
        dataType: DataType.freeText,
        tags: const [],
        createdAt: now,
        updatedAt: now,
      );

      final notifier = container.read(counterNotifierProvider.notifier);

      // Collect emissions from the stream before & after mutations.
      final db = container.read(databaseProvider);
      final emissions = <List<Counter>>[];
      final sub = db.countersDao.watchAllCounters().listen(emissions.add);
      addTearDown(sub.cancel);

      await notifier.createCounter(counter);

      // Wait until stream has emitted the inserted counter.
      for (var i = 0; i < 50; i++) {
        if (emissions.isNotEmpty && emissions.last.isNotEmpty) break;
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(emissions.last, hasLength(1));

      await notifier.deleteCounter('c-del');

      // Wait until stream has emitted the empty list after soft-delete.
      for (var i = 0; i < 50; i++) {
        if (emissions.isNotEmpty && emissions.last.isEmpty) break;
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(emissions.last, isEmpty);
    });
  });

  group('entriesForCounterProvider', () {
    test('emits an empty list when no entries exist', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final result = await container.read(
        entriesForCounterProvider('counter-none').future,
      );
      expect(result, isEmpty);
    });

    test('emits entries after adding one', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      // Insert parent counter first to satisfy FK constraint
      final now = DateTime.now();
      final counter = Counter(
        id: 'c2',
        name: 'Parent',
        behaviorType: BehaviorType.value,
        dataType: DataType.integer,
        tags: const [],
        createdAt: now,
        updatedAt: now,
      );
      await container.read(databaseProvider).countersDao.insertCounter(counter);

      final entry = CounterEntry(
        id: 'e1',
        counterId: 'c2',
        eventType: EventType.value,
        value: '42',
        recordedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await container
          .read(entryNotifierProvider('c2').notifier)
          .addEntry(entry);

      final result = await container.read(
        entriesForCounterProvider('c2').future,
      );
      expect(result, hasLength(1));
      expect(result.first.id, equals('e1'));
      expect(result.first.numericValue, equals(42.0));
    });
  });

  group('lastEntryProvider', () {
    test('returns null when no entries exist', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final result =
          await container.read(lastEntryProvider('no-counter').future);
      expect(result, isNull);
    });
  });

  group('photosForEntryProvider', () {
    test('emits an empty list when no photos exist', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final result = await container.read(
        photosForEntryProvider('entry-none').future,
      );
      expect(result, isEmpty);
    });
  });

  group('photoNotifierProvider', () {
    test('build completes without error', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await expectLater(
        container.read(photoNotifierProvider('e1').future),
        completes,
      );
    });
  });
}
