import 'sentinel.dart';

enum DataType { numeric, datetime, freeText, event }

class Counter {
  Counter({
    required this.id,
    required this.name,
    this.description = '',
    required this.dataType,
    required List<String> tags,
    this.changeStep,
    this.backgroundColor,
    this.autoSave = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  }) : tags = List.unmodifiable(tags);

  final String id;
  final String name;
  final String description;
  final DataType dataType;
  final List<String> tags;
  final String? changeStep;
  final int? backgroundColor;
  final bool autoSave;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Counter copyWith({
    String? id,
    String? name,
    String? description,
    DataType? dataType,
    List<String>? tags,
    Object? changeStep = kSentinel,
    Object? backgroundColor = kSentinel,
    bool? autoSave,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = kSentinel,
  }) {
    return Counter(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dataType: dataType ?? this.dataType,
      tags: tags ?? this.tags,
      changeStep:
          changeStep == kSentinel ? this.changeStep : changeStep as String?,
      backgroundColor: backgroundColor == kSentinel
          ? this.backgroundColor
          : backgroundColor as int?,
      autoSave: autoSave ?? this.autoSave,
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
