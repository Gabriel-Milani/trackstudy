import 'package:drift/drift.dart';
import 'package:trackstudy/database/tables/disciplines_table.dart';

class StudySessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get disciplineId => integer().references(
        Disciplines,
        #id,
        onDelete: KeyAction.cascade,
      )();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get endedAt => dateTime()();

  IntColumn get durationSeconds => integer()();
}