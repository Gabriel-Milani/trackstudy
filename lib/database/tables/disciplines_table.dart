import 'package:drift/drift.dart';

class Disciplines extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get weeklyGoalMinutes => integer()();
}
