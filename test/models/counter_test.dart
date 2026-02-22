import 'package:flutter_test/flutter_test.dart';
import 'package:counters/models/counter.dart';
import 'package:counters/models/counter_entry.dart';
import 'package:counters/models/entry_photo.dart';

void main() {
  final now = DateTime(2024, 1, 1);

  // ---------------------------------------------------------------------------
  // Counter
  // ---------------------------------------------------------------------------
  group('Counter.copyWith', () {
    final base = Counter(
      id: 'c1',
      name: 'Steps',
      behaviorType: BehaviorType.value,
      dataType: DataType.integer,
      tags: const ['fitness'],
      backgroundColor: 0xFFFF0000,
      changeStep: '1',
      deletedAt: DateTime(2024, 6, 1),
      createdAt: now,
      updatedAt: now,
    );

    test('no arguments returns equivalent instance', () {
      final copy = base.copyWith();
      expect(copy, equals(base));
      expect(copy.name, base.name);
      expect(copy.tags, base.tags);
      expect(copy.backgroundColor, base.backgroundColor);
      expect(copy.changeStep, base.changeStep);
      expect(copy.deletedAt, base.deletedAt);
    });

    test('setting nullable backgroundColor to null clears it', () {
      final copy = base.copyWith(backgroundColor: null);
      expect(copy.backgroundColor, isNull);
    });

    test('setting nullable changeStep to null clears it', () {
      final copy = base.copyWith(changeStep: null);
      expect(copy.changeStep, isNull);
    });

    test('setting nullable deletedAt to null clears it', () {
      final copy = base.copyWith(deletedAt: null);
      expect(copy.deletedAt, isNull);
    });

    test('tags list is unmodifiable', () {
      final counter = Counter(
        id: 'c2',
        name: 'Test',
        behaviorType: BehaviorType.event,
        dataType: DataType.float,
        tags: ['a', 'b'],
        createdAt: now,
        updatedAt: now,
      );
      expect(() => counter.tags.add('c'), throwsUnsupportedError);
    });
  });

  // ---------------------------------------------------------------------------
  // CounterEntry.numericValue
  // ---------------------------------------------------------------------------
  group('CounterEntry.numericValue', () {
    CounterEntry makeEntry(String? value) => CounterEntry(
          id: 'e1',
          counterId: 'c1',
          eventType: EventType.value,
          value: value,
          recordedAt: now,
          createdAt: now,
          updatedAt: now,
        );

    test('parses a valid float string', () {
      expect(makeEntry('3.14').numericValue, 3.14);
    });

    test('parses a valid integer string', () {
      expect(makeEntry('42').numericValue, 42.0);
    });

    test('returns null for null value', () {
      expect(makeEntry(null).numericValue, isNull);
    });

    test('returns null for non-numeric string', () {
      expect(makeEntry('hello').numericValue, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // EntryPhoto.copyWith
  // ---------------------------------------------------------------------------
  group('EntryPhoto.copyWith', () {
    final base = EntryPhoto(
      id: 'p1',
      entryId: 'e1',
      localPath: '/tmp/photo.jpg',
      createdAt: now,
      deletedAt: DateTime(2024, 6, 1),
    );

    test('setting deletedAt to null clears it', () {
      final copy = base.copyWith(deletedAt: null);
      expect(copy.deletedAt, isNull);
    });

    test('no arguments returns equivalent instance', () {
      final copy = base.copyWith();
      expect(copy.id, base.id);
      expect(copy.entryId, base.entryId);
      expect(copy.localPath, base.localPath);
      expect(copy.createdAt, base.createdAt);
      expect(copy.deletedAt, base.deletedAt);
    });
  });
}
