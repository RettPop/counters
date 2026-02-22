// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CountersTable extends Counters with TableInfo<$CountersTable, Counter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _behaviorTypeMeta =
      const VerificationMeta('behaviorType');
  @override
  late final GeneratedColumn<String> behaviorType = GeneratedColumn<String>(
      'behavior_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataTypeMeta =
      const VerificationMeta('dataType');
  @override
  late final GeneratedColumn<String> dataType = GeneratedColumn<String>(
      'data_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _changeStepMeta =
      const VerificationMeta('changeStep');
  @override
  late final GeneratedColumn<String> changeStep = GeneratedColumn<String>(
      'change_step', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _backgroundColorMeta =
      const VerificationMeta('backgroundColor');
  @override
  late final GeneratedColumn<int> backgroundColor = GeneratedColumn<int>(
      'background_color', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _autoSaveMeta =
      const VerificationMeta('autoSave');
  @override
  late final GeneratedColumn<bool> autoSave = GeneratedColumn<bool>(
      'auto_save', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("auto_save" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        behaviorType,
        dataType,
        tags,
        changeStep,
        backgroundColor,
        autoSave,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'counters';
  @override
  VerificationContext validateIntegrity(Insertable<Counter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('behavior_type')) {
      context.handle(
          _behaviorTypeMeta,
          behaviorType.isAcceptableOrUnknown(
              data['behavior_type']!, _behaviorTypeMeta));
    }
    if (data.containsKey('data_type')) {
      context.handle(_dataTypeMeta,
          dataType.isAcceptableOrUnknown(data['data_type']!, _dataTypeMeta));
    } else if (isInserting) {
      context.missing(_dataTypeMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('change_step')) {
      context.handle(
          _changeStepMeta,
          changeStep.isAcceptableOrUnknown(
              data['change_step']!, _changeStepMeta));
    }
    if (data.containsKey('background_color')) {
      context.handle(
          _backgroundColorMeta,
          backgroundColor.isAcceptableOrUnknown(
              data['background_color']!, _backgroundColorMeta));
    }
    if (data.containsKey('auto_save')) {
      context.handle(_autoSaveMeta,
          autoSave.isAcceptableOrUnknown(data['auto_save']!, _autoSaveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Counter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Counter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      behaviorType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}behavior_type']),
      dataType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_type'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      changeStep: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}change_step']),
      backgroundColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}background_color']),
      autoSave: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_save'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $CountersTable createAlias(String alias) {
    return $CountersTable(attachedDatabase, alias);
  }
}

class Counter extends DataClass implements Insertable<Counter> {
  final String id;
  final String name;
  final String description;
  final String? behaviorType;
  final String dataType;
  final String tags;
  final String? changeStep;
  final int? backgroundColor;
  final bool autoSave;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Counter(
      {required this.id,
      required this.name,
      required this.description,
      this.behaviorType,
      required this.dataType,
      required this.tags,
      this.changeStep,
      this.backgroundColor,
      required this.autoSave,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || behaviorType != null) {
      map['behavior_type'] = Variable<String>(behaviorType);
    }
    map['data_type'] = Variable<String>(dataType);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || changeStep != null) {
      map['change_step'] = Variable<String>(changeStep);
    }
    if (!nullToAbsent || backgroundColor != null) {
      map['background_color'] = Variable<int>(backgroundColor);
    }
    map['auto_save'] = Variable<bool>(autoSave);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CountersCompanion toCompanion(bool nullToAbsent) {
    return CountersCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      behaviorType: behaviorType == null && nullToAbsent
          ? const Value.absent()
          : Value(behaviorType),
      dataType: Value(dataType),
      tags: Value(tags),
      changeStep: changeStep == null && nullToAbsent
          ? const Value.absent()
          : Value(changeStep),
      backgroundColor: backgroundColor == null && nullToAbsent
          ? const Value.absent()
          : Value(backgroundColor),
      autoSave: Value(autoSave),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Counter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Counter(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      behaviorType: serializer.fromJson<String?>(json['behaviorType']),
      dataType: serializer.fromJson<String>(json['dataType']),
      tags: serializer.fromJson<String>(json['tags']),
      changeStep: serializer.fromJson<String?>(json['changeStep']),
      backgroundColor: serializer.fromJson<int?>(json['backgroundColor']),
      autoSave: serializer.fromJson<bool>(json['autoSave']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'behaviorType': serializer.toJson<String?>(behaviorType),
      'dataType': serializer.toJson<String>(dataType),
      'tags': serializer.toJson<String>(tags),
      'changeStep': serializer.toJson<String?>(changeStep),
      'backgroundColor': serializer.toJson<int?>(backgroundColor),
      'autoSave': serializer.toJson<bool>(autoSave),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Counter copyWith(
          {String? id,
          String? name,
          String? description,
          Value<String?> behaviorType = const Value.absent(),
          String? dataType,
          String? tags,
          Value<String?> changeStep = const Value.absent(),
          Value<int?> backgroundColor = const Value.absent(),
          bool? autoSave,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Counter(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        behaviorType:
            behaviorType.present ? behaviorType.value : this.behaviorType,
        dataType: dataType ?? this.dataType,
        tags: tags ?? this.tags,
        changeStep: changeStep.present ? changeStep.value : this.changeStep,
        backgroundColor: backgroundColor.present
            ? backgroundColor.value
            : this.backgroundColor,
        autoSave: autoSave ?? this.autoSave,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Counter copyWithCompanion(CountersCompanion data) {
    return Counter(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      behaviorType: data.behaviorType.present
          ? data.behaviorType.value
          : this.behaviorType,
      dataType: data.dataType.present ? data.dataType.value : this.dataType,
      tags: data.tags.present ? data.tags.value : this.tags,
      changeStep:
          data.changeStep.present ? data.changeStep.value : this.changeStep,
      backgroundColor: data.backgroundColor.present
          ? data.backgroundColor.value
          : this.backgroundColor,
      autoSave: data.autoSave.present ? data.autoSave.value : this.autoSave,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Counter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('behaviorType: $behaviorType, ')
          ..write('dataType: $dataType, ')
          ..write('tags: $tags, ')
          ..write('changeStep: $changeStep, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('autoSave: $autoSave, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      behaviorType,
      dataType,
      tags,
      changeStep,
      backgroundColor,
      autoSave,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Counter &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.behaviorType == this.behaviorType &&
          other.dataType == this.dataType &&
          other.tags == this.tags &&
          other.changeStep == this.changeStep &&
          other.backgroundColor == this.backgroundColor &&
          other.autoSave == this.autoSave &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CountersCompanion extends UpdateCompanion<Counter> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> behaviorType;
  final Value<String> dataType;
  final Value<String> tags;
  final Value<String?> changeStep;
  final Value<int?> backgroundColor;
  final Value<bool> autoSave;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const CountersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.behaviorType = const Value.absent(),
    this.dataType = const Value.absent(),
    this.tags = const Value.absent(),
    this.changeStep = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.autoSave = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CountersCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.behaviorType = const Value.absent(),
    required String dataType,
    this.tags = const Value.absent(),
    this.changeStep = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.autoSave = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        dataType = Value(dataType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Counter> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? behaviorType,
    Expression<String>? dataType,
    Expression<String>? tags,
    Expression<String>? changeStep,
    Expression<int>? backgroundColor,
    Expression<bool>? autoSave,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (behaviorType != null) 'behavior_type': behaviorType,
      if (dataType != null) 'data_type': dataType,
      if (tags != null) 'tags': tags,
      if (changeStep != null) 'change_step': changeStep,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (autoSave != null) 'auto_save': autoSave,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CountersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String?>? behaviorType,
      Value<String>? dataType,
      Value<String>? tags,
      Value<String?>? changeStep,
      Value<int?>? backgroundColor,
      Value<bool>? autoSave,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return CountersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      behaviorType: behaviorType ?? this.behaviorType,
      dataType: dataType ?? this.dataType,
      tags: tags ?? this.tags,
      changeStep: changeStep ?? this.changeStep,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      autoSave: autoSave ?? this.autoSave,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (behaviorType.present) {
      map['behavior_type'] = Variable<String>(behaviorType.value);
    }
    if (dataType.present) {
      map['data_type'] = Variable<String>(dataType.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (changeStep.present) {
      map['change_step'] = Variable<String>(changeStep.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<int>(backgroundColor.value);
    }
    if (autoSave.present) {
      map['auto_save'] = Variable<bool>(autoSave.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CountersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('behaviorType: $behaviorType, ')
          ..write('dataType: $dataType, ')
          ..write('tags: $tags, ')
          ..write('changeStep: $changeStep, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('autoSave: $autoSave, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CounterEntriesTable extends CounterEntries
    with TableInfo<$CounterEntriesTable, CounterEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CounterEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _counterIdMeta =
      const VerificationMeta('counterId');
  @override
  late final GeneratedColumn<String> counterId = GeneratedColumn<String>(
      'counter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        counterId,
        eventType,
        value,
        comment,
        recordedAt,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'counter_entries';
  @override
  VerificationContext validateIntegrity(Insertable<CounterEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('counter_id')) {
      context.handle(_counterIdMeta,
          counterId.isAcceptableOrUnknown(data['counter_id']!, _counterIdMeta));
    } else if (isInserting) {
      context.missing(_counterIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CounterEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CounterEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      counterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}counter_id'])!,
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $CounterEntriesTable createAlias(String alias) {
    return $CounterEntriesTable(attachedDatabase, alias);
  }
}

class CounterEntry extends DataClass implements Insertable<CounterEntry> {
  final String id;
  final String counterId;
  final String eventType;
  final String? value;
  final String? comment;
  final DateTime recordedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const CounterEntry(
      {required this.id,
      required this.counterId,
      required this.eventType,
      this.value,
      this.comment,
      required this.recordedAt,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['counter_id'] = Variable<String>(counterId);
    map['event_type'] = Variable<String>(eventType);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CounterEntriesCompanion toCompanion(bool nullToAbsent) {
    return CounterEntriesCompanion(
      id: Value(id),
      counterId: Value(counterId),
      eventType: Value(eventType),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      recordedAt: Value(recordedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory CounterEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CounterEntry(
      id: serializer.fromJson<String>(json['id']),
      counterId: serializer.fromJson<String>(json['counterId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      value: serializer.fromJson<String?>(json['value']),
      comment: serializer.fromJson<String?>(json['comment']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'counterId': serializer.toJson<String>(counterId),
      'eventType': serializer.toJson<String>(eventType),
      'value': serializer.toJson<String?>(value),
      'comment': serializer.toJson<String?>(comment),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  CounterEntry copyWith(
          {String? id,
          String? counterId,
          String? eventType,
          Value<String?> value = const Value.absent(),
          Value<String?> comment = const Value.absent(),
          DateTime? recordedAt,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      CounterEntry(
        id: id ?? this.id,
        counterId: counterId ?? this.counterId,
        eventType: eventType ?? this.eventType,
        value: value.present ? value.value : this.value,
        comment: comment.present ? comment.value : this.comment,
        recordedAt: recordedAt ?? this.recordedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  CounterEntry copyWithCompanion(CounterEntriesCompanion data) {
    return CounterEntry(
      id: data.id.present ? data.id.value : this.id,
      counterId: data.counterId.present ? data.counterId.value : this.counterId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      value: data.value.present ? data.value.value : this.value,
      comment: data.comment.present ? data.comment.value : this.comment,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CounterEntry(')
          ..write('id: $id, ')
          ..write('counterId: $counterId, ')
          ..write('eventType: $eventType, ')
          ..write('value: $value, ')
          ..write('comment: $comment, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, counterId, eventType, value, comment,
      recordedAt, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CounterEntry &&
          other.id == this.id &&
          other.counterId == this.counterId &&
          other.eventType == this.eventType &&
          other.value == this.value &&
          other.comment == this.comment &&
          other.recordedAt == this.recordedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CounterEntriesCompanion extends UpdateCompanion<CounterEntry> {
  final Value<String> id;
  final Value<String> counterId;
  final Value<String> eventType;
  final Value<String?> value;
  final Value<String?> comment;
  final Value<DateTime> recordedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const CounterEntriesCompanion({
    this.id = const Value.absent(),
    this.counterId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.value = const Value.absent(),
    this.comment = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CounterEntriesCompanion.insert({
    required String id,
    required String counterId,
    required String eventType,
    this.value = const Value.absent(),
    this.comment = const Value.absent(),
    required DateTime recordedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        counterId = Value(counterId),
        eventType = Value(eventType),
        recordedAt = Value(recordedAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CounterEntry> custom({
    Expression<String>? id,
    Expression<String>? counterId,
    Expression<String>? eventType,
    Expression<String>? value,
    Expression<String>? comment,
    Expression<DateTime>? recordedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (counterId != null) 'counter_id': counterId,
      if (eventType != null) 'event_type': eventType,
      if (value != null) 'value': value,
      if (comment != null) 'comment': comment,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CounterEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? counterId,
      Value<String>? eventType,
      Value<String?>? value,
      Value<String?>? comment,
      Value<DateTime>? recordedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return CounterEntriesCompanion(
      id: id ?? this.id,
      counterId: counterId ?? this.counterId,
      eventType: eventType ?? this.eventType,
      value: value ?? this.value,
      comment: comment ?? this.comment,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (counterId.present) {
      map['counter_id'] = Variable<String>(counterId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CounterEntriesCompanion(')
          ..write('id: $id, ')
          ..write('counterId: $counterId, ')
          ..write('eventType: $eventType, ')
          ..write('value: $value, ')
          ..write('comment: $comment, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntryPhotosTable extends EntryPhotos
    with TableInfo<$EntryPhotosTable, EntryPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntryPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entryIdMeta =
      const VerificationMeta('entryId');
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
      'entry_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES counter_entries (id)'));
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, entryId, localPath, createdAt, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entry_photos';
  @override
  VerificationContext validateIntegrity(Insertable<EntryPhoto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(_entryIdMeta,
          entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta));
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntryPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryPhoto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry_id'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $EntryPhotosTable createAlias(String alias) {
    return $EntryPhotosTable(attachedDatabase, alias);
  }
}

class EntryPhoto extends DataClass implements Insertable<EntryPhoto> {
  final String id;
  final String entryId;
  final String localPath;
  final DateTime createdAt;
  final DateTime? deletedAt;
  const EntryPhoto(
      {required this.id,
      required this.entryId,
      required this.localPath,
      required this.createdAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_id'] = Variable<String>(entryId);
    map['local_path'] = Variable<String>(localPath);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EntryPhotosCompanion toCompanion(bool nullToAbsent) {
    return EntryPhotosCompanion(
      id: Value(id),
      entryId: Value(entryId),
      localPath: Value(localPath),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EntryPhoto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryPhoto(
      id: serializer.fromJson<String>(json['id']),
      entryId: serializer.fromJson<String>(json['entryId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryId': serializer.toJson<String>(entryId),
      'localPath': serializer.toJson<String>(localPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  EntryPhoto copyWith(
          {String? id,
          String? entryId,
          String? localPath,
          DateTime? createdAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      EntryPhoto(
        id: id ?? this.id,
        entryId: entryId ?? this.entryId,
        localPath: localPath ?? this.localPath,
        createdAt: createdAt ?? this.createdAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  EntryPhoto copyWithCompanion(EntryPhotosCompanion data) {
    return EntryPhoto(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryPhoto(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('localPath: $localPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entryId, localPath, createdAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryPhoto &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.localPath == this.localPath &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class EntryPhotosCompanion extends UpdateCompanion<EntryPhoto> {
  final Value<String> id;
  final Value<String> entryId;
  final Value<String> localPath;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EntryPhotosCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntryPhotosCompanion.insert({
    required String id,
    required String entryId,
    required String localPath,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entryId = Value(entryId),
        localPath = Value(localPath),
        createdAt = Value(createdAt);
  static Insertable<EntryPhoto> custom({
    Expression<String>? id,
    Expression<String>? entryId,
    Expression<String>? localPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (localPath != null) 'local_path': localPath,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntryPhotosCompanion copyWith(
      {Value<String>? id,
      Value<String>? entryId,
      Value<String>? localPath,
      Value<DateTime>? createdAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return EntryPhotosCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      localPath: localPath ?? this.localPath,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryPhotosCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('localPath: $localPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CountersTable counters = $CountersTable(this);
  late final $CounterEntriesTable counterEntries = $CounterEntriesTable(this);
  late final $EntryPhotosTable entryPhotos = $EntryPhotosTable(this);
  late final CountersDao countersDao = CountersDao(this as AppDatabase);
  late final EntriesDao entriesDao = EntriesDao(this as AppDatabase);
  late final PhotosDao photosDao = PhotosDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [counters, counterEntries, entryPhotos];
}

typedef $$CountersTableCreateCompanionBuilder = CountersCompanion Function({
  required String id,
  required String name,
  Value<String> description,
  Value<String?> behaviorType,
  required String dataType,
  Value<String> tags,
  Value<String?> changeStep,
  Value<int?> backgroundColor,
  Value<bool> autoSave,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$CountersTableUpdateCompanionBuilder = CountersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String?> behaviorType,
  Value<String> dataType,
  Value<String> tags,
  Value<String?> changeStep,
  Value<int?> backgroundColor,
  Value<bool> autoSave,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$CountersTableFilterComposer
    extends Composer<_$AppDatabase, $CountersTable> {
  $$CountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get behaviorType => $composableBuilder(
      column: $table.behaviorType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dataType => $composableBuilder(
      column: $table.dataType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changeStep => $composableBuilder(
      column: $table.changeStep, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get backgroundColor => $composableBuilder(
      column: $table.backgroundColor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoSave => $composableBuilder(
      column: $table.autoSave, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$CountersTableOrderingComposer
    extends Composer<_$AppDatabase, $CountersTable> {
  $$CountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get behaviorType => $composableBuilder(
      column: $table.behaviorType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataType => $composableBuilder(
      column: $table.dataType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changeStep => $composableBuilder(
      column: $table.changeStep, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get backgroundColor => $composableBuilder(
      column: $table.backgroundColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoSave => $composableBuilder(
      column: $table.autoSave, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$CountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CountersTable> {
  $$CountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get behaviorType => $composableBuilder(
      column: $table.behaviorType, builder: (column) => column);

  GeneratedColumn<String> get dataType =>
      $composableBuilder(column: $table.dataType, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get changeStep => $composableBuilder(
      column: $table.changeStep, builder: (column) => column);

  GeneratedColumn<int> get backgroundColor => $composableBuilder(
      column: $table.backgroundColor, builder: (column) => column);

  GeneratedColumn<bool> get autoSave =>
      $composableBuilder(column: $table.autoSave, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$CountersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CountersTable,
    Counter,
    $$CountersTableFilterComposer,
    $$CountersTableOrderingComposer,
    $$CountersTableAnnotationComposer,
    $$CountersTableCreateCompanionBuilder,
    $$CountersTableUpdateCompanionBuilder,
    (Counter, BaseReferences<_$AppDatabase, $CountersTable, Counter>),
    Counter,
    PrefetchHooks Function()> {
  $$CountersTableTableManager(_$AppDatabase db, $CountersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> behaviorType = const Value.absent(),
            Value<String> dataType = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> changeStep = const Value.absent(),
            Value<int?> backgroundColor = const Value.absent(),
            Value<bool> autoSave = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CountersCompanion(
            id: id,
            name: name,
            description: description,
            behaviorType: behaviorType,
            dataType: dataType,
            tags: tags,
            changeStep: changeStep,
            backgroundColor: backgroundColor,
            autoSave: autoSave,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> description = const Value.absent(),
            Value<String?> behaviorType = const Value.absent(),
            required String dataType,
            Value<String> tags = const Value.absent(),
            Value<String?> changeStep = const Value.absent(),
            Value<int?> backgroundColor = const Value.absent(),
            Value<bool> autoSave = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CountersCompanion.insert(
            id: id,
            name: name,
            description: description,
            behaviorType: behaviorType,
            dataType: dataType,
            tags: tags,
            changeStep: changeStep,
            backgroundColor: backgroundColor,
            autoSave: autoSave,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CountersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CountersTable,
    Counter,
    $$CountersTableFilterComposer,
    $$CountersTableOrderingComposer,
    $$CountersTableAnnotationComposer,
    $$CountersTableCreateCompanionBuilder,
    $$CountersTableUpdateCompanionBuilder,
    (Counter, BaseReferences<_$AppDatabase, $CountersTable, Counter>),
    Counter,
    PrefetchHooks Function()>;
typedef $$CounterEntriesTableCreateCompanionBuilder = CounterEntriesCompanion
    Function({
  required String id,
  required String counterId,
  required String eventType,
  Value<String?> value,
  Value<String?> comment,
  required DateTime recordedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$CounterEntriesTableUpdateCompanionBuilder = CounterEntriesCompanion
    Function({
  Value<String> id,
  Value<String> counterId,
  Value<String> eventType,
  Value<String?> value,
  Value<String?> comment,
  Value<DateTime> recordedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$CounterEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $CounterEntriesTable, CounterEntry> {
  $$CounterEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntryPhotosTable, List<EntryPhoto>>
      _entryPhotosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.entryPhotos,
              aliasName: $_aliasNameGenerator(
                  db.counterEntries.id, db.entryPhotos.entryId));

  $$EntryPhotosTableProcessedTableManager get entryPhotosRefs {
    final manager = $$EntryPhotosTableTableManager($_db, $_db.entryPhotos)
        .filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entryPhotosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CounterEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CounterEntriesTable> {
  $$CounterEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get counterId => $composableBuilder(
      column: $table.counterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> entryPhotosRefs(
      Expression<bool> Function($$EntryPhotosTableFilterComposer f) f) {
    final $$EntryPhotosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entryPhotos,
        getReferencedColumn: (t) => t.entryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntryPhotosTableFilterComposer(
              $db: $db,
              $table: $db.entryPhotos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CounterEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CounterEntriesTable> {
  $$CounterEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get counterId => $composableBuilder(
      column: $table.counterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$CounterEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CounterEntriesTable> {
  $$CounterEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get counterId =>
      $composableBuilder(column: $table.counterId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> entryPhotosRefs<T extends Object>(
      Expression<T> Function($$EntryPhotosTableAnnotationComposer a) f) {
    final $$EntryPhotosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entryPhotos,
        getReferencedColumn: (t) => t.entryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntryPhotosTableAnnotationComposer(
              $db: $db,
              $table: $db.entryPhotos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CounterEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CounterEntriesTable,
    CounterEntry,
    $$CounterEntriesTableFilterComposer,
    $$CounterEntriesTableOrderingComposer,
    $$CounterEntriesTableAnnotationComposer,
    $$CounterEntriesTableCreateCompanionBuilder,
    $$CounterEntriesTableUpdateCompanionBuilder,
    (CounterEntry, $$CounterEntriesTableReferences),
    CounterEntry,
    PrefetchHooks Function({bool entryPhotosRefs})> {
  $$CounterEntriesTableTableManager(
      _$AppDatabase db, $CounterEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CounterEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CounterEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CounterEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> counterId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CounterEntriesCompanion(
            id: id,
            counterId: counterId,
            eventType: eventType,
            value: value,
            comment: comment,
            recordedAt: recordedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String counterId,
            required String eventType,
            Value<String?> value = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            required DateTime recordedAt,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CounterEntriesCompanion.insert(
            id: id,
            counterId: counterId,
            eventType: eventType,
            value: value,
            comment: comment,
            recordedAt: recordedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CounterEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({entryPhotosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entryPhotosRefs) db.entryPhotos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entryPhotosRefs)
                    await $_getPrefetchedData<CounterEntry,
                            $CounterEntriesTable, EntryPhoto>(
                        currentTable: table,
                        referencedTable: $$CounterEntriesTableReferences
                            ._entryPhotosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CounterEntriesTableReferences(db, table, p0)
                                .entryPhotosRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.entryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CounterEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CounterEntriesTable,
    CounterEntry,
    $$CounterEntriesTableFilterComposer,
    $$CounterEntriesTableOrderingComposer,
    $$CounterEntriesTableAnnotationComposer,
    $$CounterEntriesTableCreateCompanionBuilder,
    $$CounterEntriesTableUpdateCompanionBuilder,
    (CounterEntry, $$CounterEntriesTableReferences),
    CounterEntry,
    PrefetchHooks Function({bool entryPhotosRefs})>;
typedef $$EntryPhotosTableCreateCompanionBuilder = EntryPhotosCompanion
    Function({
  required String id,
  required String entryId,
  required String localPath,
  required DateTime createdAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$EntryPhotosTableUpdateCompanionBuilder = EntryPhotosCompanion
    Function({
  Value<String> id,
  Value<String> entryId,
  Value<String> localPath,
  Value<DateTime> createdAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$EntryPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $EntryPhotosTable, EntryPhoto> {
  $$EntryPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CounterEntriesTable _entryIdTable(_$AppDatabase db) =>
      db.counterEntries.createAlias(
          $_aliasNameGenerator(db.entryPhotos.entryId, db.counterEntries.id));

  $$CounterEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$CounterEntriesTableTableManager($_db, $_db.counterEntries)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EntryPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $EntryPhotosTable> {
  $$EntryPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  $$CounterEntriesTableFilterComposer get entryId {
    final $$CounterEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entryId,
        referencedTable: $db.counterEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CounterEntriesTableFilterComposer(
              $db: $db,
              $table: $db.counterEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntryPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $EntryPhotosTable> {
  $$EntryPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  $$CounterEntriesTableOrderingComposer get entryId {
    final $$CounterEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entryId,
        referencedTable: $db.counterEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CounterEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.counterEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntryPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntryPhotosTable> {
  $$EntryPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$CounterEntriesTableAnnotationComposer get entryId {
    final $$CounterEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entryId,
        referencedTable: $db.counterEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CounterEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.counterEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntryPhotosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntryPhotosTable,
    EntryPhoto,
    $$EntryPhotosTableFilterComposer,
    $$EntryPhotosTableOrderingComposer,
    $$EntryPhotosTableAnnotationComposer,
    $$EntryPhotosTableCreateCompanionBuilder,
    $$EntryPhotosTableUpdateCompanionBuilder,
    (EntryPhoto, $$EntryPhotosTableReferences),
    EntryPhoto,
    PrefetchHooks Function({bool entryId})> {
  $$EntryPhotosTableTableManager(_$AppDatabase db, $EntryPhotosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntryPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntryPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntryPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entryId = const Value.absent(),
            Value<String> localPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntryPhotosCompanion(
            id: id,
            entryId: entryId,
            localPath: localPath,
            createdAt: createdAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entryId,
            required String localPath,
            required DateTime createdAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntryPhotosCompanion.insert(
            id: id,
            entryId: entryId,
            localPath: localPath,
            createdAt: createdAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EntryPhotosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (entryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entryId,
                    referencedTable:
                        $$EntryPhotosTableReferences._entryIdTable(db),
                    referencedColumn:
                        $$EntryPhotosTableReferences._entryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EntryPhotosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntryPhotosTable,
    EntryPhoto,
    $$EntryPhotosTableFilterComposer,
    $$EntryPhotosTableOrderingComposer,
    $$EntryPhotosTableAnnotationComposer,
    $$EntryPhotosTableCreateCompanionBuilder,
    $$EntryPhotosTableUpdateCompanionBuilder,
    (EntryPhoto, $$EntryPhotosTableReferences),
    EntryPhoto,
    PrefetchHooks Function({bool entryId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CountersTableTableManager get counters =>
      $$CountersTableTableManager(_db, _db.counters);
  $$CounterEntriesTableTableManager get counterEntries =>
      $$CounterEntriesTableTableManager(_db, _db.counterEntries);
  $$EntryPhotosTableTableManager get entryPhotos =>
      $$EntryPhotosTableTableManager(_db, _db.entryPhotos);
}
