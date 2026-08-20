import 'package:drift/drift.dart';

import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/database/tables/study_sessions_table.dart';

part 'study_sessions_dao.g.dart';

@DriftAccessor(
  tables: [
    StudySessions,
  ],
)
class StudySessionsDao extends DatabaseAccessor<AppDatabase>
    with _$StudySessionsDaoMixin {
  StudySessionsDao(super.attachedDatabase);

  Future<List<StudySession>> getAllStudySessions() {
    return select(studySessions).get();
  }

  Stream<List<StudySession>> watchAllStudySessions() {
    return select(studySessions).watch();
  }

  Future<int> insertStudySession(StudySessionsCompanion studySession) {
    return into(studySessions).insert(studySession);
  }

  Future<bool> updateStudySession(StudySession studySession) {
    return update(studySessions).replace(studySession);
  }

  Future<int> deleteStudySession(StudySession studySession) {
    return delete(studySessions).delete(studySession);
  }
}