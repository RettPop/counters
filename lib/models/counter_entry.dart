enum EventType { value, start, continueEvent, finish }

const _sentinel = Object();

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
    Object? value = _sentinel,
    Object? comment = _sentinel,
    DateTime? recordedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _sentinel,
  }) {
    return CounterEntry(
      id: id ?? this.id,
      counterId: counterId ?? this.counterId,
      eventType: eventType ?? this.eventType,
      value: value == _sentinel ? this.value : value as String?,
      comment: comment == _sentinel ? this.comment : comment as String?,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt:
          deletedAt == _sentinel ? this.deletedAt : deletedAt as DateTime?,
    );
  }
}
