import 'sentinel.dart';

enum BehaviorType { value, event }

enum DataType { integer, float, datetime, freeText }

class Counter {
  Counter({
    required this.id,
    required this.name,
    this.description = '',
    required this.behaviorType,
    required this.dataType,
    required List<String> tags,
    this.changeStep,
    this.backgroundColor,
    this.autoSaveDelay = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  }) : tags = List.unmodifiable(tags);

  final String id;
  final String name;
  final String description;
  final BehaviorType behaviorType;
  final DataType dataType;
  final List<String> tags;
  final String? changeStep;
  // Stores color as ARGB integer (same encoding as Flutter's Color.value).
  final int? backgroundColor;
  final bool autoSaveDelay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Counter copyWith({
    String? id,
    String? name,
    String? description,
    BehaviorType? behaviorType,
    DataType? dataType,
    List<String>? tags,
    Object? changeStep = kSentinel,
    Object? backgroundColor = kSentinel,
    bool? autoSaveDelay,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = kSentinel,
  }) {
    return Counter(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      behaviorType: behaviorType ?? this.behaviorType,
      dataType: dataType ?? this.dataType,
      tags: tags ?? this.tags,
      changeStep:
          changeStep == kSentinel ? this.changeStep : changeStep as String?,
      backgroundColor: backgroundColor == kSentinel
          ? this.backgroundColor
          : backgroundColor as int?,
      autoSaveDelay: autoSaveDelay ?? this.autoSaveDelay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt:
          deletedAt == kSentinel ? this.deletedAt : deletedAt as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Counter && id == other.id && updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(id, updatedAt);

  @override
  String toString() => 'Counter(id: $id, name: $name, dataType: $dataType)';
}
