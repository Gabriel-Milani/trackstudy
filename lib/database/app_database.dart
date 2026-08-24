import 'package:drift/drift.dart';

import 'package:trackstudy/database/database_connection.dart';

import 'package:trackstudy/database/tables/disciplines_table.dart';
import 'package:trackstudy/database/daos/disciplines_dao.dart';

import 'package:trackstudy/database/tables/study_sessions_table.dart';
import 'package:trackstudy/database/daos/study_sessions_dao.dart';
import 'package:trackstudy/database/tables/activities_table.dart';
import 'package:trackstudy/database/daos/activities_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Disciplines, StudySessions, Activities],
  daos: [DisciplinesDao, StudySessionsDao, ActivitiesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(studySessions);
      }
      if (from == 2) {
        await migrator.addColumn(studySessions, studySessions.notes);
      }
      if (from < 3) {
        await migrator.createTable(activities);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
