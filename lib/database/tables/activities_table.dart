import 'package:drift/drift.dart';
import 'package:trackstudy/database/tables/disciplines_table.dart';

class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get disciplineId =>
      integer().references(Disciplines, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text()();

  DateTimeColumn get dueAt => dateTime()();

  IntColumn get estimatedMinutes => integer().withDefault(const Constant(0))();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
