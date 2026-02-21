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
      'behavior_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  static const VerificationMeta _autoSaveDelayMeta =
      const VerificationMeta('autoSaveDelay');
  @override
  late final GeneratedColumn<bool> autoSaveDelay = GeneratedColumn<bool>(
      'auto_save_delay', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_save_delay" IN (0, 1))'),
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
        autoSaveDelay,
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
    } else if (isInserting) {
      context.missing(_behaviorTypeMeta);
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
    if (data.containsKey('auto_save_delay')) {
      context.handle(
          _autoSaveDelayMeta,
          autoSaveDelay.isAcceptableOrUnknown(
              data['auto_save_delay']!, _autoSaveDelayMeta));
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
          .read(DriftSqlType.string, data['${effectivePrefix}behavior_type'])!,
      dataType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_type'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      changeStep: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}change_step']),
      backgroundColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}background_color']),
      autoSaveDelay: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_save_delay'])!,
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
  final String behaviorType;
  final String dataType;
  final String tags;
  final String? changeStep;
  final int? backgroundColor;
  final bool autoSaveDelay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Counter(
      {required this.id,
      required this.name,
      required this.description,
      required this.behaviorType,
      required this.dataType,
      required this.tags,
      this.changeStep,
      this.backgroundColor,
      required this.autoSaveDelay,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['behavior_type'] = Variable<String>(behaviorType);
    map['data_type'] = Variable<String>(dataType);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || changeStep != null) {
      map['change_step'] = Variable<String>(changeStep);
    }
    if (!nullToAbsent || backgroundColor != null) {
      map['background_color'] = Variable<int>(backgroundColor);
    }
    map['auto_save_delay'] = Variable<bool>(autoSaveDelay);
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
      behaviorType: Value(behaviorType),
      dataType: Value(dataType),
      tags: Value(tags),
      changeStep: changeStep == null && nullToAbsent
          ? const Value.absent()
          : Value(changeStep),
      backgroundColor: backgroundColor == null && nullToAbsent
          ? const Value.absent()
          : Value(backgroundColor),
      autoSaveDelay: Value(autoSaveDelay),
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
      behaviorType: serializer.fromJson<String>(json['behaviorType']),
      dataType: serializer.fromJson<String>(json['dataType']),
      tags: serializer.fromJson<String>(json['tags']),
      changeStep: serializer.fromJson<String?>(json['changeStep']),
      backgroundColor: serializer.fromJson<int?>(json['backgroundColor']),
      autoSaveDelay: serializer.fromJson<bool>(json['autoSaveDelay']),
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
      'behaviorType': serializer.toJson<String>(behaviorType),
      'dataType': serializer.toJson<String>(dataType),
      'tags': serializer.toJson<String>(tags),
      'changeStep': serializer.toJson<String?>(changeStep),
      'backgroundColor': serializer.toJson<int?>(backgroundColor),
      'autoSaveDelay': serializer.toJson<bool>(autoSaveDelay),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Counter copyWith(
          {String? id,
          String? name,
          String? description,
          String? behaviorType,
          String? dataType,
          String? tags,
          Value<String?> changeStep = const Value.absent(),
          Value<int?> backgroundColor = const Value.absent(),
          bool? autoSaveDelay,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Counter(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        behaviorType: behaviorType ?? this.behaviorType,
        dataType: dataType ?? this.dataType,
        tags: tags ?? this.tags,
        changeStep: changeStep.present ? changeStep.value : this.changeStep,
        backgroundColor: backgroundColor.present
            ? backgroundColor.value
            : this.backgroundColor,
        autoSaveDelay: autoSaveDelay ?? this.autoSaveDelay,
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
      autoSaveDelay: data.autoSaveDelay.present
          ? data.autoSaveDelay.value
          : this.autoSaveDelay,
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
          ..write('autoSaveDelay: $autoSaveDelay, ')
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
      autoSaveDelay,
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
          other.autoSaveDelay == this.autoSaveDelay &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CountersCompanion extends UpdateCompanion<Counter> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> behaviorType;
  final Value<String> dataType;
  final Value<String> tags;
  final Value<String?> changeStep;
  final Value<int?> backgroundColor;
  final Value<bool> autoSaveDelay;
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
    this.autoSaveDelay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CountersCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String behaviorType,
    required String dataType,
    this.tags = const Value.absent(),
    this.changeStep = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.autoSaveDelay = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        behaviorType = Value(behaviorType),
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
    Expression<bool>? autoSaveDelay,
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
      if (autoSaveDelay != null) 'auto_save_delay': autoSaveDelay,
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
      Value<String>? behaviorType,
      Value<String>? dataType,
      Value<String>? tags,
      Value<String?>? changeStep,
      Value<int?>? backgroundColor,
      Value<bool>? autoSaveDelay,
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
      autoSaveDelay: autoSaveDelay ?? this.autoSaveDelay,
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
    if (autoSaveDelay.present) {
      map['auto_save_delay'] = Variable<bool>(autoSaveDelay.value);
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
          ..write('autoSaveDelay: $autoSaveDelay, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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
  late final CountersDao countersDao = CountersDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [counters];
}

typedef $$CountersTableCreateCompanionBuilder = CountersCompanion Function({
  required String id,
  required String name,
  Value<String> description,
  required String behaviorType,
  required String dataType,
  Value<String> tags,
  Value<String?> changeStep,
  Value<int?> backgroundColor,
  Value<bool> autoSaveDelay,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$CountersTableUpdateCompanionBuilder = CountersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> behaviorType,
  Value<String> dataType,
  Value<String> tags,
  Value<String?> changeStep,
  Value<int?> backgroundColor,
  Value<bool> autoSaveDelay,
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

  ColumnFilters<bool> get autoSaveDelay => $composableBuilder(
      column: $table.autoSaveDelay, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<bool> get autoSaveDelay => $composableBuilder(
      column: $table.autoSaveDelay,
      builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<bool> get autoSaveDelay => $composableBuilder(
      column: $table.autoSaveDelay, builder: (column) => column);

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
            Value<String> behaviorType = const Value.absent(),
            Value<String> dataType = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> changeStep = const Value.absent(),
            Value<int?> backgroundColor = const Value.absent(),
            Value<bool> autoSaveDelay = const Value.absent(),
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
            autoSaveDelay: autoSaveDelay,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> description = const Value.absent(),
            required String behaviorType,
            required String dataType,
            Value<String> tags = const Value.absent(),
            Value<String?> changeStep = const Value.absent(),
            Value<int?> backgroundColor = const Value.absent(),
            Value<bool> autoSaveDelay = const Value.absent(),
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
            autoSaveDelay: autoSaveDelay,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CountersTableTableManager get counters =>
      $$CountersTableTableManager(_db, _db.counters);
}
