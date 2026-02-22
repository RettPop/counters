import 'sentinel.dart';

enum EventType { value, start, continueEvent, finish }

class CounterEntry {
  const CounterEntry({
    required this.id,
    required this.counterId,
    required this.eventType,
    this.value,
    this.comment,
    required this.recordedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String counterId;
  final EventType eventType;
  final String? value;
  final String? comment;
  final DateTime recordedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  double? get numericValue => double.tryParse(value ?? '');

  CounterEntry copyWith({
    String? id,
    String? counterId,
    EventType? eventType,
    Object? value = kSentinel,
    Object? comment = kSentinel,
    DateTime? recordedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = kSentinel,
  }) {
    return CounterEntry(
      id: id ?? this.id,
      counterId: counterId ?? this.counterId,
      eventType: eventType ?? this.eventType,
      value: value == kSentinel ? this.value : value as String?,
      comment: comment == kSentinel ? this.comment : comment as String?,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt:
          deletedAt == kSentinel ? this.deletedAt : deletedAt as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterEntry &&
          id == other.id &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(id, updatedAt);

  @override
  String toString() =>
      'CounterEntry(id: $id, counterId: $counterId, value: $value)';
}
