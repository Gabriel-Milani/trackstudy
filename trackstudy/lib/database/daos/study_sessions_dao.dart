import 'package:drift/drift.dart';

import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/database/tables/disciplines_table.dart';
import 'package:trackstudy/database/tables/study_sessions_table.dart';

part 'study_sessions_dao.g.dart';

@DriftAccessor(tables: [Disciplines, StudySessions])
class StudySessionsDao extends DatabaseAccessor<AppDatabase>
    with _$StudySessionsDaoMixin {
  StudySessionsDao(super.attachedDatabase);

  Future<List<StudySession>> getAllStudySessions() {
    return _orderedSessions().get();
  }

  Stream<List<StudySession>> watchAllStudySessions() {
    return _orderedSessions().watch();
  }

  Stream<List<StudySession>> watchStudySessions() => watchAllStudySessions();

  Future<int> insertStudySession(StudySessionsCompanion studySession) {
    return into(studySessions).insert(studySession);
  }

  Future<bool> updateStudySession(StudySession studySession) {
    return update(studySessions).replace(studySession);
  }

  Future<int> deleteStudySession(StudySession studySession) {
    return delete(studySessions).delete(studySession);
  }

  Future<List<StudySession>> getSessionsByDiscipline(int disciplineId) {
    return (select(studySessions)
          ..where((session) => session.disciplineId.equals(disciplineId))
          ..orderBy([(session) => OrderingTerm.desc(session.startedAt)]))
        .get();
  }

  Future<int> getTotalSecondsByDiscipline(int disciplineId) {
    return _getTotalSeconds(studySessions.disciplineId.equals(disciplineId));
  }

  Future<int> getTotalSecondsByDisciplineBetween(
    int disciplineId,
    DateTime start,
    DateTime end,
  ) {
    final interval =
        studySessions.startedAt.isBiggerOrEqualValue(start) &
        studySessions.startedAt.isSmallerThanValue(end);
    return _getTotalSeconds(
      studySessions.disciplineId.equals(disciplineId) & interval,
    );
  }

  Stream<List<StudySessionWithDiscipline>> watchSessionsWithDiscipline() {
    final query = select(studySessions).join([
      innerJoin(
        disciplines,
        disciplines.id.equalsExp(studySessions.disciplineId),
      ),
    ])..orderBy([OrderingTerm.desc(studySessions.startedAt)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => StudySessionWithDiscipline(
              session: row.readTable(studySessions),
              discipline: row.readTable(disciplines),
            ),
          )
          .toList(),
    );
  }

  SimpleSelectStatement<$StudySessionsTable, StudySession> _orderedSessions() {
    return select(studySessions)
      ..orderBy([(session) => OrderingTerm.desc(session.startedAt)]);
  }

  Future<int> _getTotalSeconds(Expression<bool> filter) async {
    final total = studySessions.durationSeconds.sum();
    final query = selectOnly(studySessions)
      ..addColumns([total])
      ..where(filter);
    final row = await query.getSingle();
    return row.read(total) ?? 0;
  }
}

class StudySessionWithDiscipline {
  const StudySessionWithDiscipline({
    required this.session,
    required this.discipline,
  });

  final StudySession session;
  final Discipline discipline;
}
