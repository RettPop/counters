import 'package:counters/models/models.dart';
import 'package:counters/screens/counter_list/counter_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('eventStepIcon', () {
    late DateTime now;

    setUp(() {
      now = DateTime.now();
    });

    test('returns play_arrow when lastEntry is null (not started)', () {
      expect(eventStepIcon(null), Icons.play_arrow);
    });

    test('returns fast_forward when lastEntry.eventType is start (ongoing)', () {
      final entry = CounterEntry(
        id: 'e1',
        counterId: 'c1',
        eventType: EventType.start,
        recordedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(eventStepIcon(entry), Icons.fast_forward);
    });

    test('returns fast_forward when lastEntry.eventType is continueEvent (ongoing)', () {
      final entry = CounterEntry(
        id: 'e2',
        counterId: 'c1',
        eventType: EventType.continueEvent,
        recordedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(eventStepIcon(entry), Icons.fast_forward);
    });

    test('returns replay when lastEntry.eventType is finish (finished)', () {
      final entry = CounterEntry(
        id: 'e3',
        counterId: 'c1',
        eventType: EventType.finish,
        recordedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(eventStepIcon(entry), Icons.replay);
    });
  });
}
