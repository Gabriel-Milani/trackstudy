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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    disciplineId,
    startedAt,
    endedAt,
    durationSeconds,
    notes,
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
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
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
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
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
  final String? notes;
  const StudySession({
    required this.id,
    required this.disciplineId,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['discipline_id'] = Variable<int>(disciplineId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  StudySessionsCompanion toCompanion(bool nullToAbsent) {
    return StudySessionsCompanion(
      id: Value(id),
      disciplineId: Value(disciplineId),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      durationSeconds: Value(durationSeconds),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
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
      notes: serializer.fromJson<String?>(json['notes']),
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
      'notes': serializer.toJson<String?>(notes),
    };
  }

  StudySession copyWith({
    int? id,
    int? disciplineId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationSeconds,
    Value<String?> notes = const Value.absent(),
  }) => StudySession(
    id: id ?? this.id,
    disciplineId: disciplineId ?? this.disciplineId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    notes: notes.present ? notes.value : this.notes,
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
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySession(')
          ..write('id: $id, ')
          ..write('disciplineId: $disciplineId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, disciplineId, startedAt, endedAt, durationSeconds, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySession &&
          other.id == this.id &&
          other.disciplineId == this.disciplineId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.notes == this.notes);
}

class StudySessionsCompanion extends UpdateCompanion<StudySession> {
  final Value<int> id;
  final Value<int> disciplineId;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> durationSeconds;
  final Value<String?> notes;
  const StudySessionsCompanion({
    this.id = const Value.absent(),
    this.disciplineId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.notes = const Value.absent(),
  });
  StudySessionsCompanion.insert({
    this.id = const Value.absent(),
    required int disciplineId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    this.notes = const Value.absent(),
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
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (disciplineId != null) 'discipline_id': disciplineId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (notes != null) 'notes': notes,
    });
  }

  StudySessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? disciplineId,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? durationSeconds,
    Value<String?>? notes,
  }) {
    return StudySessionsCompanion(
      id: id ?? this.id,
      disciplineId: disciplineId ?? this.disciplineId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      notes: notes ?? this.notes,
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
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
          ..write('durationSeconds: $durationSeconds, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    disciplineId,
    title,
    dueAt,
    estimatedMinutes,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
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
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      disciplineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discipline_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class Activity extends DataClass implements Insertable<Activity> {
  final int id;
  final int disciplineId;
  final String title;
  final DateTime dueAt;
  final int estimatedMinutes;
  final bool isCompleted;
  const Activity({
    required this.id,
    required this.disciplineId,
    required this.title,
    required this.dueAt,
    required this.estimatedMinutes,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['discipline_id'] = Variable<int>(disciplineId);
    map['title'] = Variable<String>(title);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      disciplineId: Value(disciplineId),
      title: Value(title),
      dueAt: Value(dueAt),
      estimatedMinutes: Value(estimatedMinutes),
      isCompleted: Value(isCompleted),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<int>(json['id']),
      disciplineId: serializer.fromJson<int>(json['disciplineId']),
      title: serializer.fromJson<String>(json['title']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'disciplineId': serializer.toJson<int>(disciplineId),
      'title': serializer.toJson<String>(title),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  Activity copyWith({
    int? id,
    int? disciplineId,
    String? title,
    DateTime? dueAt,
    int? estimatedMinutes,
    bool? isCompleted,
  }) => Activity(
    id: id ?? this.id,
    disciplineId: disciplineId ?? this.disciplineId,
    title: title ?? this.title,
    dueAt: dueAt ?? this.dueAt,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      disciplineId: data.disciplineId.present
          ? data.disciplineId.value
          : this.disciplineId,
      title: data.title.present ? data.title.value : this.title,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('disciplineId: $disciplineId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    disciplineId,
    title,
    dueAt,
    estimatedMinutes,
    isCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.disciplineId == this.disciplineId &&
          other.title == this.title &&
          other.dueAt == this.dueAt &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.isCompleted == this.isCompleted);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> id;
  final Value<int> disciplineId;
  final Value<String> title;
  final Value<DateTime> dueAt;
  final Value<int> estimatedMinutes;
  final Value<bool> isCompleted;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.disciplineId = const Value.absent(),
    this.title = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required int disciplineId,
    required String title,
    required DateTime dueAt,
    this.estimatedMinutes = const Value.absent(),
    this.isCompleted = const Value.absent(),
  }) : disciplineId = Value(disciplineId),
       title = Value(title),
       dueAt = Value(dueAt);
  static Insertable<Activity> custom({
    Expression<int>? id,
    Expression<int>? disciplineId,
    Expression<String>? title,
    Expression<DateTime>? dueAt,
    Expression<int>? estimatedMinutes,
    Expression<bool>? isCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (disciplineId != null) 'discipline_id': disciplineId,
      if (title != null) 'title': title,
      if (dueAt != null) 'due_at': dueAt,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (isCompleted != null) 'is_completed': isCompleted,
    });
  }

  ActivitiesCompanion copyWith({
    Value<int>? id,
    Value<int>? disciplineId,
    Value<String>? title,
    Value<DateTime>? dueAt,
    Value<int>? estimatedMinutes,
    Value<bool>? isCompleted,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      disciplineId: disciplineId ?? this.disciplineId,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('disciplineId: $disciplineId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DisciplinesTable disciplines = $DisciplinesTable(this);
  late final $StudySessionsTable studySessions = $StudySessionsTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final DisciplinesDao disciplinesDao = DisciplinesDao(
    this as AppDatabase,
  );
  late final StudySessionsDao studySessionsDao = StudySessionsDao(
    this as AppDatabase,
  );
  late final ActivitiesDao activitiesDao = ActivitiesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    disciplines,
    studySessions,
    activities,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'disciplines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activities', kind: UpdateKind.delete)],
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

  static MultiTypedResultKey<$ActivitiesTable, List<Activity>>
  _activitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activities,
    aliasName: 'disciplines__id__activities__discipline_id',
  );

  $$ActivitiesTableProcessedTableManager get activitiesRefs {
    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.disciplineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_activitiesRefsTable($_db));
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

  Expression<bool> activitiesRefs(
    Expression<bool> Function($$ActivitiesTableFilterComposer f) f,
  ) {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.disciplineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
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

  Expression<T> activitiesRefs<T extends Object>(
    Expression<T> Function($$ActivitiesTableAnnotationComposer a) f,
  ) {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.disciplineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
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
          PrefetchHooks Function({bool studySessionsRefs, bool activitiesRefs})
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
          prefetchHooksCallback:
              ({studySessionsRefs = false, activitiesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (studySessionsRefs) db.studySessions,
                    if (activitiesRefs) db.activities,
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
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.disciplineId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activitiesRefs)
                        await $_getPrefetchedData<
                          Discipline,
                          $DisciplinesTable,
                          Activity
                        >(
                          currentTable: table,
                          referencedTable: $$DisciplinesTableReferences
                              ._activitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DisciplinesTableReferences(
                                db,
                                table,
                                p0,
                              ).activitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
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
      PrefetchHooks Function({bool studySessionsRefs, bool activitiesRefs})
    >;
typedef $$StudySessionsTableCreateCompanionBuilder =
    StudySessionsCompanion Function({
      Value<int> id,
      required int disciplineId,
      required DateTime startedAt,
      required DateTime endedAt,
      required int durationSeconds,
      Value<String?> notes,
    });
typedef $$StudySessionsTableUpdateCompanionBuilder =
    StudySessionsCompanion Function({
      Value<int> id,
      Value<int> disciplineId,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> durationSeconds,
      Value<String?> notes,
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

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

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
                Value<String?> notes = const Value.absent(),
              }) => StudySessionsCompanion(
                id: id,
                disciplineId: disciplineId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int disciplineId,
                required DateTime startedAt,
                required DateTime endedAt,
                required int durationSeconds,
                Value<String?> notes = const Value.absent(),
              }) => StudySessionsCompanion.insert(
                id: id,
                disciplineId: disciplineId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                notes: notes,
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
typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int> id,
      required int disciplineId,
      required String title,
      required DateTime dueAt,
      Value<int> estimatedMinutes,
      Value<bool> isCompleted,
    });
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int> id,
      Value<int> disciplineId,
      Value<String> title,
      Value<DateTime> dueAt,
      Value<int> estimatedMinutes,
      Value<bool> isCompleted,
    });

final class $$ActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $ActivitiesTable, Activity> {
  $$ActivitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DisciplinesTable _disciplineIdTable(_$AppDatabase db) =>
      db.disciplines.createAlias('activities__discipline_id__disciplines__id');

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

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
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

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
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

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
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

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, $$ActivitiesTableReferences),
          Activity,
          PrefetchHooks Function({bool disciplineId})
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> disciplineId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                disciplineId: disciplineId,
                title: title,
                dueAt: dueAt,
                estimatedMinutes: estimatedMinutes,
                isCompleted: isCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int disciplineId,
                required String title,
                required DateTime dueAt,
                Value<int> estimatedMinutes = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                id: id,
                disciplineId: disciplineId,
                title: title,
                dueAt: dueAt,
                estimatedMinutes: estimatedMinutes,
                isCompleted: isCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivitiesTableReferences(db, table, e),
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
                                referencedTable: $$ActivitiesTableReferences
                                    ._disciplineIdTable(db),
                                referencedColumn: $$ActivitiesTableReferences
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

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, $$ActivitiesTableReferences),
      Activity,
      PrefetchHooks Function({bool disciplineId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DisciplinesTableTableManager get disciplines =>
      $$DisciplinesTableTableManager(_db, _db.disciplines);
  $$StudySessionsTableTableManager get studySessions =>
      $$StudySessionsTableTableManager(_db, _db.studySessions);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
}
