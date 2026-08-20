// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DisciplinesTable extends Disciplines
    with TableInfo<$DisciplinesTable, Discipline> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DisciplinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weeklyGoalMinutesMeta = const VerificationMeta(
    'weeklyGoalMinutes',
  );
  @override
  late final GeneratedColumn<int> weeklyGoalMinutes = GeneratedColumn<int>(
    'weekly_goal_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, weeklyGoalMinutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'disciplines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Discipline> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('weekly_goal_minutes')) {
      context.handle(
        _weeklyGoalMinutesMeta,
        weeklyGoalMinutes.isAcceptableOrUnknown(
          data['weekly_goal_minutes']!,
          _weeklyGoalMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weeklyGoalMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Discipline map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Discipline(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      weeklyGoalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_goal_minutes'],
      )!,
    );
  }

  @override
  $DisciplinesTable createAlias(String alias) {
    return $DisciplinesTable(attachedDatabase, alias);
  }
}

class Discipline extends DataClass implements Insertable<Discipline> {
  final int id;
  final String name;
  final int weeklyGoalMinutes;
  const Discipline({
    required this.id,
    required this.name,
    required this.weeklyGoalMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['weekly_goal_minutes'] = Variable<int>(weeklyGoalMinutes);
    return map;
  }

  DisciplinesCompanion toCompanion(bool nullToAbsent) {
    return DisciplinesCompanion(
      id: Value(id),
      name: Value(name),
      weeklyGoalMinutes: Value(weeklyGoalMinutes),
    );
  }

  factory Discipline.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Discipline(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      weeklyGoalMinutes: serializer.fromJson<int>(json['weeklyGoalMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'weeklyGoalMinutes': serializer.toJson<int>(weeklyGoalMinutes),
    };
  }

  Discipline copyWith({int? id, String? name, int? weeklyGoalMinutes}) =>
      Discipline(
        id: id ?? this.id,
        name: name ?? this.name,
        weeklyGoalMinutes: weeklyGoalMinutes ?? this.weeklyGoalMinutes,
      );
  Discipline copyWithCompanion(DisciplinesCompanion data) {
    return Discipline(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      weeklyGoalMinutes: data.weeklyGoalMinutes.present
          ? data.weeklyGoalMinutes.value
          : this.weeklyGoalMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Discipline(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weeklyGoalMinutes: $weeklyGoalMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, weeklyGoalMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Discipline &&
          other.id == this.id &&
          other.name == this.name &&
          other.weeklyGoalMinutes == this.weeklyGoalMinutes);
}

class DisciplinesCompanion extends UpdateCompanion<Discipline> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> weeklyGoalMinutes;
  const DisciplinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.weeklyGoalMinutes = const Value.absent(),
  });
  DisciplinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int weeklyGoalMinutes,
  }) : name = Value(name),
       weeklyGoalMinutes = Value(weeklyGoalMinutes);
  static Insertable<Discipline> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? weeklyGoalMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (weeklyGoalMinutes != null) 'weekly_goal_minutes': weeklyGoalMinutes,
    });
  }

  DisciplinesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? weeklyGoalMinutes,
  }) {
    return DisciplinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      weeklyGoalMinutes: weeklyGoalMinutes ?? this.weeklyGoalMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (weeklyGoalMinutes.present) {
      map['weekly_goal_minutes'] = Variable<int>(weeklyGoalMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DisciplinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weeklyGoalMinutes: $weeklyGoalMinutes')
          ..write(')'))
        .toString();
  }
}

class $StudySessionsTable extends StudySessions
    with TableInfo<$StudySessionsTable, StudySession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _disciplineIdMeta = const VerificationMeta(
    'disciplineId',
  );
  @override
  late final GeneratedColumn<int> disciplineId = GeneratedColumn<int>(
    'discipline_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES disciplines (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    disciplineId,
    startedAt,
    endedAt,
    durationSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudySession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('discipline_id')) {
      context.handle(
        _disciplineIdMeta,
        disciplineId.isAcceptableOrUnknown(
          data['discipline_id']!,
          _disciplineIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_disciplineIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      disciplineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discipline_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
    );
  }

  @override
  $StudySessionsTable createAlias(String alias) {
    return $StudySessionsTable(attachedDatabase, alias);
  }
}

class StudySession extends DataClass implements Insertable<StudySession> {
  final int id;
  final int disciplineId;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationSeconds;
  const StudySession({
    required this.id,
    required this.disciplineId,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['discipline_id'] = Variable<int>(disciplineId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    return map;
  }

  StudySessionsCompanion toCompanion(bool nullToAbsent) {
    return StudySessionsCompanion(
      id: Value(id),
      disciplineId: Value(disciplineId),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      durationSeconds: Value(durationSeconds),
    );
  }

  factory StudySession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySession(
      id: serializer.fromJson<int>(json['id']),
      disciplineId: serializer.fromJson<int>(json['disciplineId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'disciplineId': serializer.toJson<int>(disciplineId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
    };
  }

  StudySession copyWith({
    int? id,
    int? disciplineId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationSeconds,
  }) => StudySession(
    id: id ?? this.id,
    disciplineId: disciplineId ?? this.disciplineId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
  );
  StudySession copyWithCompanion(StudySessionsCompanion data) {
    return StudySession(
      id: data.id.present ? data.id.value : this.id,
      disciplineId: data.disciplineId.present
          ? data.disciplineId.value
          : this.disciplineId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySession(')
          ..write('id: $id, ')
          ..write('disciplineId: $disciplineId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, disciplineId, startedAt, endedAt, durationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySession &&
          other.id == this.id &&
          other.disciplineId == this.disciplineId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds);
}

class StudySessionsCompanion extends UpdateCompanion<StudySession> {
  final Value<int> id;
  final Value<int> disciplineId;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> durationSeconds;
  const StudySessionsCompanion({
    this.id = const Value.absent(),
    this.disciplineId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  StudySessionsCompanion.insert({
    this.id = const Value.absent(),
    required int disciplineId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
  }) : disciplineId = Value(disciplineId),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       durationSeconds = Value(durationSeconds);
  static Insertable<StudySession> custom({
    Expression<int>? id,
    Expression<int>? disciplineId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (disciplineId != null) 'discipline_id': disciplineId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  StudySessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? disciplineId,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? durationSeconds,
  }) {
    return StudySessionsCompanion(
      id: id ?? this.id,
      disciplineId: disciplineId ?? this.disciplineId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (disciplineId.present) {
      map['discipline_id'] = Variable<int>(disciplineId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionsCompanion(')
          ..write('id: $id, ')
          ..write('disciplineId: $disciplineId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DisciplinesTable disciplines = $DisciplinesTable(this);
  late final $StudySessionsTable studySessions = $StudySessionsTable(this);
  late final DisciplinesDao disciplinesDao = DisciplinesDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    disciplines,
    studySessions,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'disciplines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_sessions', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$DisciplinesTableCreateCompanionBuilder =
    DisciplinesCompanion Function({
      Value<int> id,
      required String name,
      required int weeklyGoalMinutes,
    });
typedef $$DisciplinesTableUpdateCompanionBuilder =
    DisciplinesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> weeklyGoalMinutes,
    });

final class $$DisciplinesTableReferences
    extends BaseReferences<_$AppDatabase, $DisciplinesTable, Discipline> {
  $$DisciplinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudySessionsTable, List<StudySession>>
  _studySessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studySessions,
    aliasName: 'disciplines__id__study_sessions__discipline_id',
  );

  $$StudySessionsTableProcessedTableManager get studySessionsRefs {
    final manager = $$StudySessionsTableTableManager(
      $_db,
      $_db.studySessions,
    ).filter((f) => f.disciplineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_studySessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DisciplinesTableFilterComposer
    extends Composer<_$AppDatabase, $DisciplinesTable> {
  $$DisciplinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyGoalMinutes => $composableBuilder(
    column: $table.weeklyGoalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> studySessionsRefs(
    Expression<bool> Function($$StudySessionsTableFilterComposer f) f,
  ) {
    final $$StudySessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.disciplineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableFilterComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DisciplinesTableOrderingComposer
    extends Composer<_$AppDatabase, $DisciplinesTable> {
  $$DisciplinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyGoalMinutes => $composableBuilder(
    column: $table.weeklyGoalMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DisciplinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DisciplinesTable> {
  $$DisciplinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get weeklyGoalMinutes => $composableBuilder(
    column: $table.weeklyGoalMinutes,
    builder: (column) => column,
  );

  Expression<T> studySessionsRefs<T extends Object>(
    Expression<T> Function($$StudySessionsTableAnnotationComposer a) f,
  ) {
    final $$StudySessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.disciplineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DisciplinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DisciplinesTable,
          Discipline,
          $$DisciplinesTableFilterComposer,
          $$DisciplinesTableOrderingComposer,
          $$DisciplinesTableAnnotationComposer,
          $$DisciplinesTableCreateCompanionBuilder,
          $$DisciplinesTableUpdateCompanionBuilder,
          (Discipline, $$DisciplinesTableReferences),
          Discipline,
          PrefetchHooks Function({bool studySessionsRefs})
        > {
  $$DisciplinesTableTableManager(_$AppDatabase db, $DisciplinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DisciplinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DisciplinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DisciplinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> weeklyGoalMinutes = const Value.absent(),
              }) => DisciplinesCompanion(
                id: id,
                name: name,
                weeklyGoalMinutes: weeklyGoalMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int weeklyGoalMinutes,
              }) => DisciplinesCompanion.insert(
                id: id,
                name: name,
                weeklyGoalMinutes: weeklyGoalMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DisciplinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studySessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (studySessionsRefs) db.studySessions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studySessionsRefs)
                    await $_getPrefetchedData<
                      Discipline,
                      $DisciplinesTable,
                      StudySession
                    >(
                      currentTable: table,
                      referencedTable: $$DisciplinesTableReferences
                          ._studySessionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DisciplinesTableReferences(
                            db,
                            table,
                            p0,
                          ).studySessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.disciplineId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DisciplinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DisciplinesTable,
      Discipline,
      $$DisciplinesTableFilterComposer,
      $$DisciplinesTableOrderingComposer,
      $$DisciplinesTableAnnotationComposer,
      $$DisciplinesTableCreateCompanionBuilder,
      $$DisciplinesTableUpdateCompanionBuilder,
      (Discipline, $$DisciplinesTableReferences),
      Discipline,
      PrefetchHooks Function({bool studySessionsRefs})
    >;
typedef $$StudySessionsTableCreateCompanionBuilder =
    StudySessionsCompanion Function({
      Value<int> id,
      required int disciplineId,
      required DateTime startedAt,
      required DateTime endedAt,
      required int durationSeconds,
    });
typedef $$StudySessionsTableUpdateCompanionBuilder =
    StudySessionsCompanion Function({
      Value<int> id,
      Value<int> disciplineId,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> durationSeconds,
    });

final class $$StudySessionsTableReferences
    extends BaseReferences<_$AppDatabase, $StudySessionsTable, StudySession> {
  $$StudySessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DisciplinesTable _disciplineIdTable(_$AppDatabase db) => db
      .disciplines
      .createAlias('study_sessions__discipline_id__disciplines__id');

  $$DisciplinesTableProcessedTableManager get disciplineId {
    final $_column = $_itemColumn<int>('discipline_id')!;

    final manager = $$DisciplinesTableTableManager(
      $_db,
      $_db.disciplines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_disciplineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudySessionsTableFilterComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  $$DisciplinesTableFilterComposer get disciplineId {
    final $$DisciplinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.disciplineId,
      referencedTable: $db.disciplines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DisciplinesTableFilterComposer(
            $db: $db,
            $table: $db.disciplines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  $$DisciplinesTableOrderingComposer get disciplineId {
    final $$DisciplinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.disciplineId,
      referencedTable: $db.disciplines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DisciplinesTableOrderingComposer(
            $db: $db,
            $table: $db.disciplines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  $$DisciplinesTableAnnotationComposer get disciplineId {
    final $$DisciplinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.disciplineId,
      referencedTable: $db.disciplines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DisciplinesTableAnnotationComposer(
            $db: $db,
            $table: $db.disciplines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudySessionsTable,
          StudySession,
          $$StudySessionsTableFilterComposer,
          $$StudySessionsTableOrderingComposer,
          $$StudySessionsTableAnnotationComposer,
          $$StudySessionsTableCreateCompanionBuilder,
          $$StudySessionsTableUpdateCompanionBuilder,
          (StudySession, $$StudySessionsTableReferences),
          StudySession,
          PrefetchHooks Function({bool disciplineId})
        > {
  $$StudySessionsTableTableManager(_$AppDatabase db, $StudySessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudySessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> disciplineId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
              }) => StudySessionsCompanion(
                id: id,
                disciplineId: disciplineId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int disciplineId,
                required DateTime startedAt,
                required DateTime endedAt,
                required int durationSeconds,
              }) => StudySessionsCompanion.insert(
                id: id,
                disciplineId: disciplineId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudySessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({disciplineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (disciplineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.disciplineId,
                                referencedTable: $$StudySessionsTableReferences
                                    ._disciplineIdTable(db),
                                referencedColumn: $$StudySessionsTableReferences
                                    ._disciplineIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StudySessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudySessionsTable,
      StudySession,
      $$StudySessionsTableFilterComposer,
      $$StudySessionsTableOrderingComposer,
      $$StudySessionsTableAnnotationComposer,
      $$StudySessionsTableCreateCompanionBuilder,
      $$StudySessionsTableUpdateCompanionBuilder,
      (StudySession, $$StudySessionsTableReferences),
      StudySession,
      PrefetchHooks Function({bool disciplineId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DisciplinesTableTableManager get disciplines =>
      $$DisciplinesTableTableManager(_db, _db.disciplines);
  $$StudySessionsTableTableManager get studySessions =>
      $$StudySessionsTableTableManager(_db, _db.studySessions);
}
