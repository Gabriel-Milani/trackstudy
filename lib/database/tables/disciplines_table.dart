import 'package:drift/drift.dart';

class Disciplines extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get weeklyGoalMinutes => integer()();

  /// Categoria da disciplina (chave de DisciplineCategory), usada para
  /// escolher o ícone exibido nos cards. Ex: 'exatas', 'tecnologia'.
  TextColumn get category => text().withDefault(const Constant('outras'))();
}
