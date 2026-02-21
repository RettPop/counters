import 'package:flutter/material.dart';

enum BehaviorType { value, event }

enum DataType { integer, float, datetime, freeText }

const _sentinel = Object();

class Counter {
  const Counter({
    required this.id,
    required this.name,
    this.description = '',
    required this.behaviorType,
    required this.dataType,
    required this.tags,
    this.changeStep,
    this.backgroundColor,
    this.autoSaveDelay = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String name;
  final String description;
  final BehaviorType behaviorType;
  final DataType dataType;
  final List<String> tags;
  final String? changeStep;
  final Color? backgroundColor;
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
    Object? changeStep = _sentinel,
    Object? backgroundColor = _sentinel,
    bool? autoSaveDelay,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _sentinel,
  }) {
    return Counter(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      behaviorType: behaviorType ?? this.behaviorType,
      dataType: dataType ?? this.dataType,
      tags: tags ?? this.tags,
      changeStep:
          changeStep == _sentinel ? this.changeStep : changeStep as String?,
      backgroundColor: backgroundColor == _sentinel
          ? this.backgroundColor
          : backgroundColor as Color?,
      autoSaveDelay: autoSaveDelay ?? this.autoSaveDelay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt:
          deletedAt == _sentinel ? this.deletedAt : deletedAt as DateTime?,
    );
  }
}
