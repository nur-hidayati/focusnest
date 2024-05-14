// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_timer_database.dart';

// ignore_for_file: type=lint
class $ActivityTimersTable extends ActivityTimers
    with TableInfo<$ActivityTimersTable, ActivityTimer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityTimersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _activityLabelMeta =
      const VerificationMeta('activityLabel');
  @override
  late final GeneratedColumn<String> activityLabel = GeneratedColumn<String>(
      'activity_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationInSecondsMeta =
      const VerificationMeta('durationInSeconds');
  @override
  late final GeneratedColumn<int> durationInSeconds = GeneratedColumn<int>(
      'duration_in_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startDateTimeMeta =
      const VerificationMeta('startDateTime');
  @override
  late final GeneratedColumn<DateTime> startDateTime =
      GeneratedColumn<DateTime>('start_date_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateTimeMeta =
      const VerificationMeta('endDateTime');
  @override
  late final GeneratedColumn<DateTime> endDateTime = GeneratedColumn<DateTime>(
      'end_date_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        activityLabel,
        durationInSeconds,
        startDateTime,
        endDateTime,
        createdDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_timers';
  @override
  VerificationContext validateIntegrity(Insertable<ActivityTimer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_label')) {
      context.handle(
          _activityLabelMeta,
          activityLabel.isAcceptableOrUnknown(
              data['activity_label']!, _activityLabelMeta));
    } else if (isInserting) {
      context.missing(_activityLabelMeta);
    }
    if (data.containsKey('duration_in_seconds')) {
      context.handle(
          _durationInSecondsMeta,
          durationInSeconds.isAcceptableOrUnknown(
              data['duration_in_seconds']!, _durationInSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationInSecondsMeta);
    }
    if (data.containsKey('start_date_time')) {
      context.handle(
          _startDateTimeMeta,
          startDateTime.isAcceptableOrUnknown(
              data['start_date_time']!, _startDateTimeMeta));
    } else if (isInserting) {
      context.missing(_startDateTimeMeta);
    }
    if (data.containsKey('end_date_time')) {
      context.handle(
          _endDateTimeMeta,
          endDateTime.isAcceptableOrUnknown(
              data['end_date_time']!, _endDateTimeMeta));
    } else if (isInserting) {
      context.missing(_endDateTimeMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityTimer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityTimer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      activityLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity_label'])!,
      durationInSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}duration_in_seconds'])!,
      startDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}start_date_time'])!,
      endDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}end_date_time'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
    );
  }

  @override
  $ActivityTimersTable createAlias(String alias) {
    return $ActivityTimersTable(attachedDatabase, alias);
  }
}

class ActivityTimer extends DataClass implements Insertable<ActivityTimer> {
  final String id;
  final String activityLabel;
  final int durationInSeconds;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final DateTime createdDate;
  const ActivityTimer(
      {required this.id,
      required this.activityLabel,
      required this.durationInSeconds,
      required this.startDateTime,
      required this.endDateTime,
      required this.createdDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['activity_label'] = Variable<String>(activityLabel);
    map['duration_in_seconds'] = Variable<int>(durationInSeconds);
    map['start_date_time'] = Variable<DateTime>(startDateTime);
    map['end_date_time'] = Variable<DateTime>(endDateTime);
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  ActivityTimersCompanion toCompanion(bool nullToAbsent) {
    return ActivityTimersCompanion(
      id: Value(id),
      activityLabel: Value(activityLabel),
      durationInSeconds: Value(durationInSeconds),
      startDateTime: Value(startDateTime),
      endDateTime: Value(endDateTime),
      createdDate: Value(createdDate),
    );
  }

  factory ActivityTimer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityTimer(
      id: serializer.fromJson<String>(json['id']),
      activityLabel: serializer.fromJson<String>(json['activityLabel']),
      durationInSeconds: serializer.fromJson<int>(json['durationInSeconds']),
      startDateTime: serializer.fromJson<DateTime>(json['startDateTime']),
      endDateTime: serializer.fromJson<DateTime>(json['endDateTime']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'activityLabel': serializer.toJson<String>(activityLabel),
      'durationInSeconds': serializer.toJson<int>(durationInSeconds),
      'startDateTime': serializer.toJson<DateTime>(startDateTime),
      'endDateTime': serializer.toJson<DateTime>(endDateTime),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  ActivityTimer copyWith(
          {String? id,
          String? activityLabel,
          int? durationInSeconds,
          DateTime? startDateTime,
          DateTime? endDateTime,
          DateTime? createdDate}) =>
      ActivityTimer(
        id: id ?? this.id,
        activityLabel: activityLabel ?? this.activityLabel,
        durationInSeconds: durationInSeconds ?? this.durationInSeconds,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        createdDate: createdDate ?? this.createdDate,
      );
  @override
  String toString() {
    return (StringBuffer('ActivityTimer(')
          ..write('id: $id, ')
          ..write('activityLabel: $activityLabel, ')
          ..write('durationInSeconds: $durationInSeconds, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, activityLabel, durationInSeconds,
      startDateTime, endDateTime, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityTimer &&
          other.id == this.id &&
          other.activityLabel == this.activityLabel &&
          other.durationInSeconds == this.durationInSeconds &&
          other.startDateTime == this.startDateTime &&
          other.endDateTime == this.endDateTime &&
          other.createdDate == this.createdDate);
}

class ActivityTimersCompanion extends UpdateCompanion<ActivityTimer> {
  final Value<String> id;
  final Value<String> activityLabel;
  final Value<int> durationInSeconds;
  final Value<DateTime> startDateTime;
  final Value<DateTime> endDateTime;
  final Value<DateTime> createdDate;
  final Value<int> rowid;
  const ActivityTimersCompanion({
    this.id = const Value.absent(),
    this.activityLabel = const Value.absent(),
    this.durationInSeconds = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityTimersCompanion.insert({
    this.id = const Value.absent(),
    required String activityLabel,
    required int durationInSeconds,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required DateTime createdDate,
    this.rowid = const Value.absent(),
  })  : activityLabel = Value(activityLabel),
        durationInSeconds = Value(durationInSeconds),
        startDateTime = Value(startDateTime),
        endDateTime = Value(endDateTime),
        createdDate = Value(createdDate);
  static Insertable<ActivityTimer> custom({
    Expression<String>? id,
    Expression<String>? activityLabel,
    Expression<int>? durationInSeconds,
    Expression<DateTime>? startDateTime,
    Expression<DateTime>? endDateTime,
    Expression<DateTime>? createdDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityLabel != null) 'activity_label': activityLabel,
      if (durationInSeconds != null) 'duration_in_seconds': durationInSeconds,
      if (startDateTime != null) 'start_date_time': startDateTime,
      if (endDateTime != null) 'end_date_time': endDateTime,
      if (createdDate != null) 'created_date': createdDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityTimersCompanion copyWith(
      {Value<String>? id,
      Value<String>? activityLabel,
      Value<int>? durationInSeconds,
      Value<DateTime>? startDateTime,
      Value<DateTime>? endDateTime,
      Value<DateTime>? createdDate,
      Value<int>? rowid}) {
    return ActivityTimersCompanion(
      id: id ?? this.id,
      activityLabel: activityLabel ?? this.activityLabel,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      createdDate: createdDate ?? this.createdDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (activityLabel.present) {
      map['activity_label'] = Variable<String>(activityLabel.value);
    }
    if (durationInSeconds.present) {
      map['duration_in_seconds'] = Variable<int>(durationInSeconds.value);
    }
    if (startDateTime.present) {
      map['start_date_time'] = Variable<DateTime>(startDateTime.value);
    }
    if (endDateTime.present) {
      map['end_date_time'] = Variable<DateTime>(endDateTime.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityTimersCompanion(')
          ..write('id: $id, ')
          ..write('activityLabel: $activityLabel, ')
          ..write('durationInSeconds: $durationInSeconds, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('createdDate: $createdDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ActivityTimerDatabase extends GeneratedDatabase {
  _$ActivityTimerDatabase(QueryExecutor e) : super(e);
  _$ActivityTimerDatabaseManager get managers =>
      _$ActivityTimerDatabaseManager(this);
  late final $ActivityTimersTable activityTimers = $ActivityTimersTable(this);
  late final ActivityTimersDao activityTimersDao =
      ActivityTimersDao(this as ActivityTimerDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [activityTimers];
}

typedef $$ActivityTimersTableInsertCompanionBuilder = ActivityTimersCompanion
    Function({
  Value<String> id,
  required String activityLabel,
  required int durationInSeconds,
  required DateTime startDateTime,
  required DateTime endDateTime,
  required DateTime createdDate,
  Value<int> rowid,
});
typedef $$ActivityTimersTableUpdateCompanionBuilder = ActivityTimersCompanion
    Function({
  Value<String> id,
  Value<String> activityLabel,
  Value<int> durationInSeconds,
  Value<DateTime> startDateTime,
  Value<DateTime> endDateTime,
  Value<DateTime> createdDate,
  Value<int> rowid,
});

class $$ActivityTimersTableTableManager extends RootTableManager<
    _$ActivityTimerDatabase,
    $ActivityTimersTable,
    ActivityTimer,
    $$ActivityTimersTableFilterComposer,
    $$ActivityTimersTableOrderingComposer,
    $$ActivityTimersTableProcessedTableManager,
    $$ActivityTimersTableInsertCompanionBuilder,
    $$ActivityTimersTableUpdateCompanionBuilder> {
  $$ActivityTimersTableTableManager(
      _$ActivityTimerDatabase db, $ActivityTimersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ActivityTimersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ActivityTimersTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ActivityTimersTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> activityLabel = const Value.absent(),
            Value<int> durationInSeconds = const Value.absent(),
            Value<DateTime> startDateTime = const Value.absent(),
            Value<DateTime> endDateTime = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityTimersCompanion(
            id: id,
            activityLabel: activityLabel,
            durationInSeconds: durationInSeconds,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            createdDate: createdDate,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            required String activityLabel,
            required int durationInSeconds,
            required DateTime startDateTime,
            required DateTime endDateTime,
            required DateTime createdDate,
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityTimersCompanion.insert(
            id: id,
            activityLabel: activityLabel,
            durationInSeconds: durationInSeconds,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            createdDate: createdDate,
            rowid: rowid,
          ),
        ));
}

class $$ActivityTimersTableProcessedTableManager extends ProcessedTableManager<
    _$ActivityTimerDatabase,
    $ActivityTimersTable,
    ActivityTimer,
    $$ActivityTimersTableFilterComposer,
    $$ActivityTimersTableOrderingComposer,
    $$ActivityTimersTableProcessedTableManager,
    $$ActivityTimersTableInsertCompanionBuilder,
    $$ActivityTimersTableUpdateCompanionBuilder> {
  $$ActivityTimersTableProcessedTableManager(super.$state);
}

class $$ActivityTimersTableFilterComposer
    extends FilterComposer<_$ActivityTimerDatabase, $ActivityTimersTable> {
  $$ActivityTimersTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get activityLabel => $state.composableBuilder(
      column: $state.table.activityLabel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get durationInSeconds => $state.composableBuilder(
      column: $state.table.durationInSeconds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get startDateTime => $state.composableBuilder(
      column: $state.table.startDateTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get endDateTime => $state.composableBuilder(
      column: $state.table.endDateTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdDate => $state.composableBuilder(
      column: $state.table.createdDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ActivityTimersTableOrderingComposer
    extends OrderingComposer<_$ActivityTimerDatabase, $ActivityTimersTable> {
  $$ActivityTimersTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get activityLabel => $state.composableBuilder(
      column: $state.table.activityLabel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get durationInSeconds => $state.composableBuilder(
      column: $state.table.durationInSeconds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get startDateTime => $state.composableBuilder(
      column: $state.table.startDateTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get endDateTime => $state.composableBuilder(
      column: $state.table.endDateTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdDate => $state.composableBuilder(
      column: $state.table.createdDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$ActivityTimerDatabaseManager {
  final _$ActivityTimerDatabase _db;
  _$ActivityTimerDatabaseManager(this._db);
  $$ActivityTimersTableTableManager get activityTimers =>
      $$ActivityTimersTableTableManager(_db, _db.activityTimers);
}
