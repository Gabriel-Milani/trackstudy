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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DisciplinesTable disciplines = $DisciplinesTable(this);
  late final DisciplinesDao disciplinesDao = DisciplinesDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [disciplines];
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
          (
            Discipline,
            BaseReferences<_$AppDatabase, $DisciplinesTable, Discipline>,
          ),
          Discipline,
          PrefetchHooks Function()
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        Discipline,
        BaseReferences<_$AppDatabase, $DisciplinesTable, Discipline>,
      ),
      Discipline,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DisciplinesTableTableManager get disciplines =>
      $$DisciplinesTableTableManager(_db, _db.disciplines);
}
