import 'package:drift/drift.dart';

import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/database/tables/disciplines_table.dart';

part 'disciplines_dao.g.dart';

@DriftAccessor(
  tables: [
    Disciplines,
  ],
)
class DisciplinesDao extends DatabaseAccessor<AppDatabase>
    with _$DisciplinesDaoMixin {
  DisciplinesDao(super.attachedDatabase);

  Future<List<Discipline>> getAllDisciplines() {
    return select(disciplines).get();
  }

  Stream<List<Discipline>> watchAllDisciplines() {
    return select(disciplines).watch();
  }

  Future<int> insertDiscipline(DisciplinesCompanion discipline) {
    return into(disciplines).insert(discipline);
  }

  Future<bool> updateDiscipline(Discipline discipline) {
    return update(disciplines).replace(discipline);
  }

  Future<int> deleteDiscipline(Discipline discipline) {
    return delete(disciplines).delete(discipline);
  }
}