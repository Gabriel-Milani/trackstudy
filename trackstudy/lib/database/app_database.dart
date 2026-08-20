import 'package:drift/drift.dart';

import 'package:trackstudy/database/database_connection.dart';

import 'package:trackstudy/database/tables/disciplines_table.dart';
import 'package:trackstudy/database/daos/disciplines_dao.dart';

import 'package:trackstudy/database/tables/study_sessions_table.dart';
import 'package:trackstudy/database/daos/study_sessions_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Disciplines,
    StudySessions,
  ],
  daos: [
    DisciplinesDao,
    StudySessionsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 2;
}